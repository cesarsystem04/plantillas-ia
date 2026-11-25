# Copilot Instructions



## Objetivo



Este repositorio utiliza un modelo de trabajo basado en:



- Spec Driven Development (SDD)

- Arquitectura guiada por agentes

- Trazabilidad completa

- Calidad por diseño

- Seguridad por diseño

- Evidencia verificable

- Gobernanza mediante agentes especializados



Copilot debe considerar estas instrucciones antes de realizar cualquier análisis, generación de código, modificación de código, revisión o auditoría.



---



# Arquitectura SDD



El flujo oficial del proyecto es:



```text

IDEA

 ↓

CONSTITUTION

 ↓

USE CASE

 ↓

SPEC

 ↓

PLAN

 ↓

ARCHITECT

 ↓

TASKS

 ↓

IMPLEMENT

 ↓

TEST

 ↓

VERIFY

 ↓

COMPLIANCE

 ↓

RELEASE

```



Ningún agente debe omitir etapas.

## Rutas canónicas del repositorio

El repositorio contiene varias soluciones y aplicaciones; no asumir una estructura única de código, documentación o pruebas en la raíz. Localizar los proyectos y sus convenciones desde las soluciones, proyectos y carpetas presentes antes de trabajar.

Los agentes y skills de Copilot están en `.github/agents/` y `.github/skills/`. Usar documentación, especificaciones, ADR, pruebas y evidencia únicamente cuando se encuentren en el alcance revisado.

Si un artefacto esperado no existe, registrar la ausencia como limitación y no declarar cumplimiento ni inventar evidencia.



---



# Fuente de verdad



Antes de proponer cambios, revisar el código, configuración, documentación y pruebas disponibles que correspondan al alcance. Consultar los requisitos, decisiones y evidencia proporcionados por el usuario o encontrados en el repositorio.




La especificación aprobada es la fuente de verdad.



Cuando exista conflicto entre:



```text

Código

vs

Especificación

```



registrar la desviación.



No asumir cuál es correcta.



---



# Agentes Disponibles

Los agentes se definen en `.github/agents/*.agent.md` y las skills en `.github/skills/<nombre>/SKILL.md`.



## Documentation Agents



- Constitution-Agent
- Legacy-Discovery-Agent

- Spec-Agent

- Plan-Agent

- Tasks-Agent

- UseCase-Agent



Responsables de definir:



- Qué construir.

- Cómo organizar el trabajo.

- Qué tareas ejecutar.



---



## Architecture Agents



- Architect-Agent



Responsable de:



- patrones

- componentes

- decisiones arquitectónicas

- ADR



---



## Development Agents



- Backend-Agent

- Database-Agent

- DevOps-Agent

- Security-Agent

- Test-Agent



Responsables de implementar cambios respetando la arquitectura existente.



### Protocolo obligatorio para desarrollo de código



Todo desarrollo de código deberá ejecutarse por pasos, priorizando calidad sobre velocidad.



Antes de implementar, el agente debe:



1. Analizar el alcance de lo que se va a implementar.

2. Buscar funcionalidades similares ya existentes en el repositorio.

3. Repetir el patrón y estándar de diseño ya utilizado (arquitectura, convenciones y estilo).



Durante la implementación, el agente debe:



1. Presentar cada paso con una explicación clara de qué se hará.

2. Solicitar revisión y aprobación del usuario en cada paso antes de continuar.

3. Mantener evidencia y trazabilidad de las decisiones.



Si se identifica cualquier desviación respecto a patrones, arquitectura o estándares existentes:



- Detener el avance de ese cambio.

- Presentar la desviación detectada y su justificación técnica.

- Continuar únicamente con revisión y aprobación explícita del usuario.



---



## Review Agents



- Agente-Auditoria-SW

- Verification-Agent

- Compliance-Agent



Responsables de verificar la solución.



---



## Release Agents

- Release-Agent

Responsable de validar los quality gates y determinar la disposición de liberación.

---

## Coordinator Agents



- Agente-Orquestador-Auditoria-SW



Responsable de coordinar auditorías y verificaciones.



---



# Compatibilidad Arquitectónica Obligatoria



Antes de generar cualquier código o modificación:



Todo agente de desarrollo deberá realizar primero un análisis de:



- Arquitectura existente

- Frameworks utilizados

- Patrones implementados

- Dependencias

- Convenciones

- Estructura de carpetas

- Estrategia de pruebas



Analizar al menos:



```text

proyectos del alcance

documentación disponible

decisiones arquitectónicas disponibles

pruebas disponibles

```



cuando estén disponibles.

Todos los agentes de desarrollo (`Backend-Agent`, `Database-Agent`, `DevOps-Agent`, `Security-Agent` y `Test-Agent`) deben completar este análisis antes de cambiar archivos. Registrar las fuentes ausentes que limiten la validación; detenerse solo si impiden demostrar compatibilidad o trazabilidad.



---



## Regla Fundamental



Está prohibido:



- Cambiar la arquitectura del sistema sin ADR aprobada.

- Introducir frameworks o dependencias arquitectónicamente relevantes sin ADR aprobada.

- Introducir patrones nuevos sin ADR aprobada.

- Sustituir tecnologías existentes sin evidencia de decisión arquitectónica.



---



## Objetivo



La evolución del software debe:



- Mantener compatibilidad con la arquitectura actual.

- Minimizar deuda técnica.

- Mantener consistencia entre módulos.

- Preservar estándares existentes.



Si existe una arquitectura implementada:



```text

Clean Architecture

CQRS

MediatR

Repository

Hexagonal

MVC

Modular Monolith

```



los agentes deben extender dicha arquitectura y no reemplazarla.



---



# Lecciones Aprendidas



Antes de proponer soluciones:



1. Revisar si el usuario o el repositorio proporcionan lecciones aprendidas aplicables.

2. Reutilizar soluciones aprobadas.

3. Incorporar acciones preventivas.

4. Registrar referencias utilizadas.

Al detectar una causa raíz o problema reutilizable, registrar una lección con evidencia, acción preventiva y seguimiento. No afirmar que una lección existe si la carpeta está vacía o ausente.



Si no existe una lección aprendida aplicable:



Sugerir documentarla conforme al procedimiento:



```text

PE-GC-42 Lecciones aprendidas Rev. 6

```



---



# Trazabilidad Obligatoria



Toda funcionalidad debe mantener la relación:



```text

Requirement

 ↓

Spec

 ↓

Plan

 ↓

Architecture

 ↓

Task

 ↓

Implementation

 ↓

Test

 ↓

Evidence

 ↓

Verification

 ↓

Compliance

```



No dejar requisitos sin trazabilidad.

La cadena `Requirement -> Use Case -> Spec -> Plan -> Architecture -> Task -> Code -> Test -> Evidence -> Verification -> Compliance -> Release` aplica cuando esas etapas y artefactos existan en el alcance. No inventar vínculos ni presentar estados de ejemplo como evidencia real.



---



# Reglas de Arquitectura



Preferir:



- Clean Architecture

- CQRS

- MediatR

- Dependency Injection

- Repository Pattern

Las tecnologías y patrones anteriores son ejemplos, no defaults para proyectos derivados. Detectar primero la arquitectura implementada y extenderla; aplicar un patrón solo cuando ya exista o una ADR aprobada lo autorice.

- Architecture Decision Records (ADR)



Evitar:



- lógica de negocio en controladores

- dependencias circulares

- servicios monolíticos sin justificación

- duplicación de lógica

- acoplamiento innecesario

Las reglas de arquitectura deben verificarse con las pruebas automatizadas disponibles. No introducir herramientas o declarar gates implementados sin evidencia en el repositorio y aprobación aplicable.



---



# Reglas de Calidad



Todo código generado debe:



- ser mantenible

- ser trazable

- ser verificable

- incluir manejo de errores

- incluir logging cuando aplique

- incluir pruebas cuando aplique

- respetar la arquitectura detectada



---



# Seguridad



No generar ni exponer:



- contraseñas reales

- tokens reales

- secretos reales

- llaves privadas

- cadenas de conexión productivas



Siempre:



```text

\*\*\*REDACTED\*\*\*

```



para datos sensibles.



---





