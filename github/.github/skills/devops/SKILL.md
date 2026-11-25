---
name: devops
description: "Asegurar que pipelines, empaquetado y despliegue sean reproducibles, seguros y alineados al proceso SDD. Usar cuando: Creacion o ajuste de workflows; Integracion de quality gates; Mejoras de build, release y deployment."
---

# Skill: devops

## Proposito

Asegurar que pipelines, empaquetado y despliegue sean reproducibles, seguros y alineados al proceso SDD.

## Cuando usar

- Creacion o ajuste de workflows
- Integracion de quality gates
- Mejoras de build, release y deployment

## Entradas requeridas

- Workflows actuales en .github/workflows cuando existan
- Requisitos de seguridad y compliance
- Matriz de entornos y estrategia de release
- Estrategia de ramas, plantilla PR, checks requeridos y rulesets verificables

## Salidas esperadas

- Pipeline documentado con etapas y gates
- Estrategia de despliegue por entorno
- Controles de rollback y observabilidad
- Mapa de workflows separados, triggers, checks y ramas/PR que los ejecutan

## Politica de workflows y PR

- Mantener workflows de CI y documentacion separados, con archivos, triggers y responsabilidades propios. No consolidarlos en un workflow monolitico.
- Mantener controles de build, pruebas, seguridad y cobertura como jobs identificables dentro del workflow de CI; los cambios y publicacion de documentacion permanecen en el workflow documental.
- Revisar `pull_request` y `push` para las ramas permanentes y temporales definidas (`main`, `dev`, `feat/*`, `fix/*`, `sec/*`, `release/*`) y explicar cualquier diferencia de alcance.
- Alinear los checks requeridos de rulesets con los nombres reales de los jobs/checks publicados por CI. No inventar checks ni afirmar que una rama esta protegida sin consultar la configuracion remota o evidencia del repositorio.
- Respetar que `main` solo reciba cambios mediante PR desde `dev` o un flujo de release aprobado; no disenar automatizaciones que hagan push directo a ramas protegidas.
- No trasladar workflows de otro template sin adaptar rutas, sistema operativo, SDK/framework, comandos, tests y dependencias del repositorio objetivo.
- Mantener el conocimiento portable: detectar rutas, stack, runner, pruebas y gates reales del repositorio objetivo. No incluir supuestos ni políticas específicas de otro proyecto en esta skill.
- Mantener generacion/publicacion de documentos desacoplada del build y test de codigo. Cualquier commit o PR automatico de documentos debe evitar bypass de revisiones y rulesets.
- Tratar scripts que administran rulesets o permisos de equipos como operaciones privilegiadas: inspeccionar alcance, usar modo de simulacion cuando exista, confirmar repositorio/equipos y requerir aprobacion explicita antes de cambios remotos.

## Flujo recomendado

1. Inventariar workflows, jobs, triggers, ramas destino de PR, permisos y checks publicados.
2. Mantener CI y documentacion separados; comprobar que cada workflow se ejecute solo para los cambios/eventos correspondientes.
3. Validar build, pruebas, seguridad, cobertura y artefactos contra el stack real, no contra supuestos de otro template.
4. Alinear los checks de rulesets y el protocolo de PR con los nombres/estados que CI produce efectivamente.
5. Detectar fallas recurrentes y aplicar mejoras incrementales sin relajar revisiones, protecciones o controles requeridos.
6. Validar seguridad de permisos/tokens, idempotencia, rollback y trazabilidad; documentar limitaciones y evidencia de ejecucion.

## Criterios de aceptacion

- Pipeline ejecuta controles minimos de calidad.
- Artefactos de build son identificables y versionados.
- Existe plan de rollback para cambios de alto impacto.
- Workflows de CI y documentacion permanecen separados y con responsabilidades explicitas.
- Los checks requeridos para merge coinciden con jobs existentes y se aplican a las ramas/PR esperados.
- Los comandos y gates se validan contra el stack, estructura y pruebas reales del repositorio.
- Ningun workflow hace bypass de PR/revision en `main` ni administra permisos/rulesets sin aprobacion.

## Riesgos comunes

- Secretos expuestos en logs o variables
- Deploy sin evidencia de pruebas
- Workflows fragiles no idempotentes
- Copiar un workflow incompatible con el framework, runner, rutas o proyectos de prueba del repositorio
- Checks requeridos con nombres inexistentes o gates que fallan por estructura asumida
- Automatizacion que escribe directamente en ramas protegidas o modifica rulesets/permisos sin aprobacion
