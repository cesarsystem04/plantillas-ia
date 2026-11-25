---
name: github
description: "Estandarizar el uso de Git y GitHub para trazabilidad, gobernanza y colaboracion segura. Usar cuando: Preparar cambios para revision; Disenar estrategia de ramas y PR; Definir convenciones de commits y plantillas."
---

# Skill: github

## Proposito

Estandarizar el uso de Git y GitHub para trazabilidad, gobernanza y colaboracion segura.

## Cuando usar

- Preparar cambios para revision
- Disenar estrategia de ramas y PR
- Definir convenciones de commits y plantillas

## Entradas requeridas

- Politica de ramas del proyecto
- Requisitos de calidad y compliance
- Flujos de CI/CD existentes
- Issue, especificacion, tarea o solicitud asociada al cambio

## Salidas esperadas

- Recomendacion de flujo de ramas
- Checklist de PR con calidad minima
- Politica de etiquetas y versionado
- Referencias de trazabilidad y aprobaciones pendientes

## Politica de ramas

- Ramas permanentes: `main` y `dev`.
- Nunca recomendar commits directos a `main`; `main` recibe cambios mediante PR desde `dev` o por un flujo de release aprobado.
- Usar ramas temporales con prefijos `feat/`, `fix/`, `sec/` o `release/`, segun el tipo de cambio.
- Antes de proponer un nombre, clasificar el cambio y confirmar el identificador de Issue/tarea disponible. No inventar IDs ni asumir que una rama ya esta protegida en GitHub.
- No definir una convencion de mensajes de commit si el repositorio no la ha aprobado. Separar claramente recomendaciones de politicas ya vigentes.

## Protocolo de Pull Request

Antes de preparar un PR:

1. Confirmar Issue o solicitud asociada; vincular Spec, criterio de aceptacion y task cuando existan.
2. Confirmar rama origen y destino segun la politica vigente; para `main`, usar `dev` o un flujo de release aprobado.
3. Usar la plantilla PR existente si esta disponible; no reemplazar sus secciones por un resumen libre.
4. Describir objetivo, alcance, archivos relevantes, riesgos y cambios de comportamiento.
5. Declarar pruebas ejecutadas y su resultado; adjuntar evidencia. Si no hay pruebas aplicables o no pudieron ejecutarse, indicarlo con motivo y riesgo residual, nunca marcarlas como exitosas.
6. Resumir cobertura disponible frente al gate configurado, controles de seguridad/dependencias, cambios de documentacion y estado de CHANGELOG cuando apliquen.
7. Declarar uso de IA cuando la plantilla o politica lo solicite, incluyendo revision humana y ausencia de secretos en prompts.
8. Solicitar revisores/CODEOWNERS aplicables y preservar segregacion entre autor y aprobador cuando la politica de GitHub lo requiera.
9. No afirmar que hay aprobaciones, protecciones, checks requeridos o gates activos sin evidencia de configuracion en GitHub.

### Checklist minimo de PR

- [ ] Issue/solicitud y trazabilidad SDD referenciados, cuando existan.
- [ ] Rama temporal con prefijo correcto y destino conforme a la politica.
- [ ] Descripcion, alcance, riesgos y archivos afectados incluidos.
- [ ] Pruebas y evidencia reportadas honestamente; cobertura indicada si esta disponible.
- [ ] Seguridad, dependencias, secretos y documentacion considerados.
- [ ] CHANGELOG actualizado o justificacion de no aplicabilidad.
- [ ] Uso de IA declarado cuando corresponda.
- [ ] Revisiones independientes y CODEOWNERS solicitados cuando apliquen.
- [ ] Checks requeridos visibles y exitosos; no solicitar omitirlos para acelerar el merge.

## Flujo recomendado

1. Confirmar estrategia de ramas e Issue asociado; proponer `feat/`, `fix/`, `sec/` o `release/` sin inventar politica adicional.
2. Confirmar rama destino y preservar el flujo `dev` -> `main` por PR, salvo release aprobado.
3. Revisar plantilla PR, criterios de aceptacion, tareas y evidencia disponible.
4. Definir checks requeridos solo con base en workflows y rulesets realmente configurados.
5. Exigir resultados de pruebas, cobertura disponible, riesgos conocidos y cambios documentales.
6. Registrar revisores, aprobaciones y decision de release; distinguir requisitos del repositorio de recomendaciones.

## Criterios de aceptacion

- Todo cambio relevante llega por PR revisado.
- PR incluye referencia a spec/tarea cuando aplique.
- Estado de checks es visible y auditable.
- No se recomiendan commits directos a `main` ni bypass de revisiones/checks requeridos.
- La rama, el destino del PR y la evidencia declarada corresponden a la politica y configuracion verificables.

## Riesgos comunes

- Merge directo a ramas protegidas
- PR sin evidencia tecnica
- Historial de commits sin contexto
- Convenciones de commit o reglas de proteccion asumidas sin aprobacion/configuracion verificable
- Plantilla PR sustituida u omitida sin autorizacion
