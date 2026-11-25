---
name: legacy-system-discovery
description: "Use when: reverse-engineering a legacy or undocumented application, mapping screens and source code to functional use cases, estimating traceable coverage, or preparing characterization tests before modernization. Stack- and repository-neutral workflow."
---

# Skill: Legacy System Discovery

## Propósito

Definir un método repetible y basado en evidencia para comprender el software tal como está implementado antes de redactar requisitos, automatizar pruebas o planear una migración. Adaptar el método al lenguaje, framework, persistencia, documentación y convenciones encontrados en el repositorio.

## Cuándo usar

- El sistema es heredado, está parcialmente documentado o se desconoce su comportamiento.
- Se necesita relacionar casos de uso con pantallas, módulos y código fuente.
- Se requiere una línea base funcional antes de pruebas de caracterización o migración incremental.
- Se solicita un reporte de cobertura con vínculos a casos y evidencia técnica.

## Entradas requeridas

- Repositorio y alcance solicitado (sistema, módulo o conjunto de funciones).
- Código, navegación, configuración, manuales, casos existentes, pruebas y evidencia disponibles.
- Rutas de salida, prefijo/IDs y formato de reporte, si el usuario los proporciona; de lo contrario, detectar convenciones locales.
- Protocolo de revisión/aprobación aplicable.

Si una decisión ambigua cambiaría mucho el alcance o generaría numerosos documentos, preguntar antes de escribirlos. No inventar reglas de negocio ausentes: registrarlas como pendientes.

## Salidas esperadas

- Inventario del estado actual: módulos, pantallas navegables, puntos de entrada, integraciones y fuentes revisadas; distinguir pantallas funcionales de diálogos, helpers y clases generadas.
- Matriz de trazabilidad entre objetivos/casos de uso, escenarios, pantallas, código y evidencia.
- Borradores de casos de uso en la ruta y formato del repositorio, con IDs únicos y referencias verificables.
- Reporte de cobertura que declara alcance, denominador, fórmula, solapamientos, exclusiones, confianza y elementos no revisados.
- Hallazgos, discrepancias, hechos, inferencias, incógnitas y preguntas funcionales.

No declarar pruebas automatizadas, ejecutadas o aprobadas sin evidencia. No modificar código productivo durante descubrimiento.

## Flujo recomendado

1. **Definir alcance y reglas.** Leer instrucciones del repositorio, memoria, lecciones aprendidas, casos previos y convenciones de nombres/rutas. Encontrar las ubicaciones reales; no asumir `src/`, `tests/` ni tecnologías.
2. **Inventariar el estado actual.** Detectar lenguajes, proyectos, entrada de aplicación, navegación, formularios/páginas, diálogos, proveedores de datos, integraciones y pruebas. Una clase UI es solo candidata a pantalla hasta confirmar que es alcanzable.
3. **Contrastar evidencia.** Comparar manuales y casos con navegación y código. Enlazar los hechos a archivos. Marcar OCR, documentación desactualizada, fuentes incompletas o contradicciones como limitaciones; no escoger una fuente silenciosamente.
4. **Separar artefactos.** Un caso de uso representa un objetivo funcional de un actor; un escenario de prueba describe una condición y resultado verificable. Relacionarlos sin asumir correspondencia uno-a-uno, salvo instrucción explícita, y nombrar claramente esa decisión.
5. **Redactar casos.** Seguir plantillas locales. Incluir propósito, actores, disparador, precondiciones, flujo, alternativas/excepciones, resultados, reglas/datos, escenarios, pantallas/fuentes y pendientes. Separar conducta observada, requisito aprobado e intención futura. Marcar lo incierto con `por confirmar` o el término local.
6. **Medir cobertura con transparencia.** Elegir denominador acorde con la afirmación (por ejemplo, pantallas verificadas como activas, objetivos funcionales o requisitos). Declarar fórmula y exclusiones. No equiparar archivos, líneas, pantallas, casos o escenarios con cobertura funcional; no sumar porcentajes de conjuntos que se solapan. Si no hay denominador defendible, presentar una matriz cualitativa.
7. **Validar artefactos.** Verificar IDs, enlaces, existencia de archivos, conteos, diagnósticos Markdown disponibles y que los escenarios propuestos no se presenten como pruebas ejecutadas.
8. **Reportar brechas y handoff.** Resumir cobertura, discrepancias, decisiones funcionales pendientes y áreas no revisadas. No avanzar a automatización, cambios de arquitectura o migración salvo solicitud y autorización.

## Lista de calidad para cada caso de uso

- Describe un objetivo coherente del actor y define su alcance.
- Enlaza pantalla/ruta de navegación y fuentes reales cuando estén identificadas.
- Distingue flujo principal, variantes y errores.
- Etiqueta reglas como observadas, aprobadas, inferidas o pendientes.
- Mantiene escenarios de prueba identificables y trazables al caso.
- No presenta el resultado deseado como comportamiento actual demostrado.
- Declara datos, decisiones y pruebas pendientes.

## Criterios de aceptación

- Cada hallazgo es trazable a evidencia o está marcado como inferencia/pendiente.
- No se inventan comportamiento, requisitos, resultados de pruebas ni aprobaciones.
- Los IDs no colisionan con artefactos existentes.
- Se respetan las rutas y nomenclaturas locales o se documenta la limitación.
- Las estimaciones explican denominador y límites; no producen falsa precisión.
- No se copian secretos ni datos sensibles a los entregables.

## Riesgos comunes

- Tratar manuales OCR o documentos antiguos como requisitos aprobados.
- Contar cada clase de formulario como una pantalla de negocio activa.
- Confundir un escenario de prueba con un caso de uso completo.
- Sumar referencias repetidas y reportarlas como cobertura única.
- Mezclar estado actual con arquitectura futura.
- Iniciar automatización o migración antes de aprobar la línea base y el alcance.