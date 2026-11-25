param(
    [Parameter(Mandatory = $true)]
    [string[]]$InputFiles,

    [Parameter(Mandatory = $true)]
    [string]$OutputDocx,

    [string]$ReferenceDoc = "docs/plantilla_referencia_organizacion_pandoc.docx",

    [string]$DocumentLanguage = "es-MX"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Set-DocxLanguage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DocxPath,

        [Parameter(Mandatory = $true)]
        [string]$Language
    )

    if (-not (Test-Path -LiteralPath $DocxPath)) {
        throw "No existe el archivo DOCX para actualizar idioma: $DocxPath"
    }

    $workRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("docx-lang-" + [Guid]::NewGuid().ToString("N"))
    $zipPath = Join-Path $workRoot "source.zip"
    $extractPath = Join-Path $workRoot "x"

    New-Item -ItemType Directory -Path $extractPath -Force | Out-Null

    try {
        Copy-Item -LiteralPath $DocxPath -Destination $zipPath
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

        $stylesPath = Join-Path $extractPath "word/styles.xml"
        $settingsPath = Join-Path $extractPath "word/settings.xml"

        if (Test-Path -LiteralPath $stylesPath) {
            [xml]$stylesXml = Get-Content -LiteralPath $stylesPath -Raw
            $stylesNs = New-Object System.Xml.XmlNamespaceManager($stylesXml.NameTable)
            $stylesNs.AddNamespace("w", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")

            $langNodes = $stylesXml.SelectNodes("//w:lang", $stylesNs)
            foreach ($langNode in $langNodes) {
                $attr = $langNode.Attributes.GetNamedItem("val", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")
                if ($null -ne $attr) {
                    $attr.Value = $Language
                }
            }

            $stylesXml.Save($stylesPath)
        }

        if (Test-Path -LiteralPath $settingsPath) {
            [xml]$settingsXml = Get-Content -LiteralPath $settingsPath -Raw
            $settingsNs = New-Object System.Xml.XmlNamespaceManager($settingsXml.NameTable)
            $settingsNs.AddNamespace("w", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")

            $themeNode = $settingsXml.SelectSingleNode("//w:themeFontLang", $settingsNs)
            if ($null -ne $themeNode) {
                $attr = $themeNode.Attributes.GetNamedItem("val", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")
                if ($null -ne $attr) {
                    $attr.Value = $Language
                }
            }

            $settingsXml.Save($settingsPath)
        }

        Write-Host "Idioma DOCX aplicado: $Language"

        if (Test-Path -LiteralPath $DocxPath) {
            Remove-Item -LiteralPath $DocxPath -Force
        }

        Compress-Archive -Path (Join-Path $extractPath '*') -DestinationPath $zipPath -Force
        Move-Item -LiteralPath $zipPath -Destination $DocxPath -Force
    }
    finally {
        if (Test-Path -LiteralPath $workRoot) {
            Remove-Item -LiteralPath $workRoot -Recurse -Force
        }
    }
}

if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    throw "pandoc no esta disponible en el entorno actual."
}

if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
    throw "npx no esta disponible. Instala Node.js para renderizar bloques Mermaid."
}

$tempBase = $env:TEMP
if ([string]::IsNullOrWhiteSpace($tempBase)) {
    $tempBase = [System.IO.Path]::GetTempPath()
}

$tempRoot = Join-Path $tempBase ("md-mermaid-docx-" + [Guid]::NewGuid().ToString("N"))
$tempMdDir = Join-Path $tempRoot "md"
$tempImgDir = Join-Path $tempRoot "images"
$puppeteerConfigPath = Join-Path $tempRoot "puppeteer-config.json"

New-Item -ItemType Directory -Path $tempMdDir -Force | Out-Null
New-Item -ItemType Directory -Path $tempImgDir -Force | Out-Null

# Required in many CI Linux runners where Chromium sandbox is unavailable.
$puppeteerConfig = @'
{
    "args": [
        "--no-sandbox",
        "--disable-setuid-sandbox"
    ]
}
'@
Set-Content -LiteralPath $puppeteerConfigPath -Value $puppeteerConfig -NoNewline

$processedFiles = New-Object System.Collections.Generic.List[string]

try {
    $fileIndex = 0

    foreach ($inputFile in $InputFiles) {
        if ([string]::IsNullOrWhiteSpace($inputFile)) {
            continue
        }

        if (-not (Test-Path -LiteralPath $inputFile)) {
            throw "No existe el archivo de entrada: $inputFile"
        }

        $raw = Get-Content -LiteralPath $inputFile -Raw
        $pattern = [regex]'```mermaid\s*([\s\S]*?)\s*```'
        $matches = $pattern.Matches($raw)

        $newContent = $raw
        $offset = 0
        $matchIndex = 0

        foreach ($m in $matches) {
            $mermaidCode = $m.Groups[1].Value
            $diagramBase = "diagram-f{0}-m{1}" -f $fileIndex, $matchIndex
            $mmdPath = Join-Path $tempImgDir ($diagramBase + ".mmd")
            $pngPath = Join-Path $tempImgDir ($diagramBase + ".png")

            Set-Content -LiteralPath $mmdPath -Value $mermaidCode -NoNewline

            & npx -y '@mermaid-js/mermaid-cli' -i $mmdPath -o $pngPath -b transparent -p $puppeteerConfigPath
            if ($LASTEXITCODE -ne 0) {
                throw "Error al renderizar Mermaid en '$inputFile' (bloque $matchIndex)."
            }

            $imageUri = ([System.Uri]$pngPath).AbsoluteUri
            $replacement = "`n![Diagrama Mermaid]($imageUri)`n"
            $start = $m.Index + $offset
            $length = $m.Length

            $newContent = $newContent.Remove($start, $length).Insert($start, $replacement)
            $offset += ($replacement.Length - $length)
            $matchIndex++
        }

        $tempMdPath = Join-Path $tempMdDir (("{0:D3}-" -f $fileIndex) + [System.IO.Path]::GetFileName($inputFile))
        Set-Content -LiteralPath $tempMdPath -Value $newContent -NoNewline
        $processedFiles.Add($tempMdPath)
        $fileIndex++
    }

    if ($processedFiles.Count -eq 0) {
        throw "No se encontraron archivos de entrada validos."
    }

    $outputDir = Split-Path -Parent $OutputDocx
    if (-not [string]::IsNullOrWhiteSpace($outputDir) -and -not (Test-Path -LiteralPath $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }

    $pandocArgs = @()
    $pandocArgs += $processedFiles
    $pandocArgs += "-o"
    $pandocArgs += $OutputDocx

    if (Test-Path -LiteralPath $ReferenceDoc) {
        $pandocArgs += "--reference-doc=$ReferenceDoc"
    }

    if (-not [string]::IsNullOrWhiteSpace($DocumentLanguage)) {
        $pandocArgs += "-V"
        $pandocArgs += "lang=$DocumentLanguage"
    }

    & pandoc @pandocArgs
    if ($LASTEXITCODE -ne 0) {
        throw "pandoc fallo al generar el documento DOCX."
    }

    if (-not [string]::IsNullOrWhiteSpace($DocumentLanguage)) {
        Set-DocxLanguage -DocxPath $OutputDocx -Language $DocumentLanguage
    }

    Write-Host "DOCX generado correctamente: $OutputDocx"
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}
