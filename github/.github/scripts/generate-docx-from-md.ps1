param(
    [Parameter(Mandatory = $true)]
    [string[]]$MarkdownFiles,

    [string]$OutputRoot = "artifacts/docx",

    [string]$ReferenceDoc = "docs/plantilla_referencia_organizacion_pandoc.docx"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    throw "pandoc no esta disponible en el entorno actual."
}

if (-not $MarkdownFiles -or $MarkdownFiles.Count -eq 0) {
    Write-Host "No se recibieron archivos Markdown para convertir."
    exit 0
}

$referenceArgs = @()
if (Test-Path -LiteralPath $ReferenceDoc) {
    $referenceArgs = @("--reference-doc=$ReferenceDoc")
}
else {
    Write-Host "No se encontro plantilla de referencia en '$ReferenceDoc'. Se usara formato default de pandoc."
}

$generated = New-Object System.Collections.Generic.List[string]

foreach ($mdFile in $MarkdownFiles) {
    if ([string]::IsNullOrWhiteSpace($mdFile)) {
        continue
    }

    if (-not (Test-Path -LiteralPath $mdFile)) {
        Write-Host "Se omite '$mdFile' porque no existe en el workspace."
        continue
    }

    $relativePath = $mdFile -replace "^[.]/", ""
    $relativePath = $relativePath -replace "^[.]\\", ""
    $docxRelative = [System.IO.Path]::ChangeExtension($relativePath, ".docx")
    $outputPath = Join-Path $OutputRoot $docxRelative
    $outputDir = Split-Path -Parent $outputPath

    if (-not (Test-Path -LiteralPath $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }

    Write-Host "Convirtiendo '$mdFile' -> '$outputPath'"
    & pandoc $mdFile -o $outputPath @referenceArgs

    if ($LASTEXITCODE -ne 0) {
        throw "Pandoc fallo al convertir '$mdFile'."
    }

    $generated.Add($outputPath)
}

Write-Host "Total DOCX generados: $($generated.Count)"
$generated | ForEach-Object { Write-Host " - $_" }
