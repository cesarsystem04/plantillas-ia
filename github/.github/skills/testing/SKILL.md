---
name: testing
description: "Definir una estrategia de pruebas verificable, priorizada por riesgo y alineada con criterios de aceptacion. Usar cuando: Implementacion de nuevas features; Correccion de defectos; Preparacion de release."
---

# Skill: testing

## Proposito

Definir una estrategia de pruebas verificable, priorizada por riesgo y alineada con criterios de aceptacion.

## Cuando usar

- Implementacion de nuevas features
- Correccion de defectos
- Preparacion de release

## Entradas requeridas

- Criterios de aceptacion
- Casos de uso y reglas de negocio
- Suite actual de pruebas en /tests cuando exista

## Salidas esperadas

- Plan de pruebas por nivel (unit, integration, architecture, system)
- Matriz requisito -> prueba -> evidencia
- Lista de gaps de cobertura

## Flujo recomendado

1. Mapear criterios de aceptacion a escenarios de prueba.
2. Priorizar escenarios por impacto y probabilidad.
3. Aplicar técnicas ISTQB según riesgo y modelo: equivalence partitioning, boundary value analysis, decision tables, state transition testing y pairwise testing.
4. Ejecutar pruebas unitarias, integración, sistema y arquitectura que correspondan a la arquitectura y herramientas aprobadas.
5. Registrar resultados con evidencia reproducible.
6. Reportar riesgos residuales y decisiones.

## Criterios de aceptacion

- Cada requisito critico tiene evidencia de prueba.
- Se reportan explicitamente pruebas no ejecutadas.
- Los defectos se clasifican por severidad.
- Para .NET, usar NetArchTest.Rules solo con ADR aprobada; Architecture Tests se ubican en `tests/architecture/`.
- No declarar condition coverage a partir de branch coverage; reportarla solo cuando exista una medición independiente soportada.

## Riesgos comunes

- Cobertura alta con baja calidad de escenarios
- Falta de trazabilidad entre requisito y prueba
- Omision de pruebas negativas y bordes

- Reglas de arquitectura documentadas sin prueba automatizada
