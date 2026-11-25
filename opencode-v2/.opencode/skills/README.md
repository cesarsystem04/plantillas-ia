# Skills Catalog

## Objetivo

Esta carpeta define skills reutilizables para el flujo SDD del repositorio.
Cada skill debe ayudar a producir salidas trazables, verificables y compatibles con la arquitectura existente.

## Separación de responsabilidades

- **Agent = ejecuta:** recibe una tarea, aplica su contrato de entradas y salidas, produce artefactos y realiza el handoff definido.
- **Skill = enseña:** aporta conocimiento reutilizable, métodos, heurísticas y checklists. No asigna trabajo, no aprueba fases y no duplica el ciclo de vida del agente.
- Las skills no sustituyen la constitución, las ADR aprobadas ni los criterios de aceptación.

## Estructura esperada por skill

Cada subcarpeta de skill contiene un archivo `SKILL.md` con:

- Proposito
- Cuando usar
- Entradas requeridas
- Salidas esperadas
- Flujo recomendado
- Criterios de aceptacion
- Riesgos comunes

## Skills disponibles

- clean-architecture
- legacy-system-discovery
- cqrs
- dotnet
- explore_db
- testing
- github
- devops
- security
- auditing
- lessons-learned

## Regla global

Antes de implementar cambios, revisar el código, documentación, pruebas y evidencia que existan para el alcance. Si falta alguna entrada crítica, registrar la limitación y continuar solo con alcance acotado.
