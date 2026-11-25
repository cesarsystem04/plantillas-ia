# AI Agent Architecture

## Objetivo

Este directorio contiene los agentes utilizados para implementar un ciclo de desarrollo basado en:

- Spec-Driven Development (SDD).
- Arquitectura guiada por agentes.
- Trazabilidad de extremo a extremo.
- Calidad y seguridad por diseño.
- Pruebas alineadas con principios ISTQB.
- Verificación basada en evidencia.
- Cumplimiento de procesos.
- Gobernanza de IA.
- Liberación controlada mediante Quality Gates.

Los agentes colaboran para mantener consistencia entre requisitos, arquitectura, implementación, pruebas, auditoría, verificación, cumplimiento y liberación.

## Filosofía del proyecto

La arquitectura existente tiene prioridad sobre nuevas implementaciones.

Todos los agentes deben:

- Analizar antes de modificar.
- Comprender antes de generar.
- Extender antes de reemplazar.
- Mantener consistencia técnica.
- Mantener trazabilidad.
- Producir evidencia verificable.
- Consultar la constitución y las lecciones aprendidas aplicables.

La IA debe adaptarse al sistema existente y no obligar al sistema a adaptarse a la IA.

## Contrato normativo de agentes

Antes de actuar, cada agente revisa las instrucciones del repositorio y los artefactos disponibles que correspondan a su etapa. Los agentes de desarrollo aplican además el preflight indicado en `.github/copilot-instructions.md`.

Cada agente documenta explícitamente:

- **Entradas:** artefactos, IDs y estado de aprobación requeridos. No inferir entradas ausentes.
- **Salidas:** archivos o decisiones producidos, estado final y evidencia verificable.
- **Handoff input/output:** el input identifica el artefacto aprobado recibido; el output enumera el artefacto emitido, su estado, IDs trazados y bloqueos. Un handoff no equivale a aprobación.
- **Estados:** `PENDING`, `ANALYZING`, `EXECUTING`, `BLOCKED`, `COMPLETED` o `FAILED`. Se permiten subestados propios del agente, sin alterar estos estados terminales.
- **Criterios de salida:** todos los requisitos aplicables tienen vínculos RTM; no existen fallos o bloqueos ocultos; las evidencias citadas existen y corresponden al mismo cambio.

El agente que no tenga un handoff definido termina con su salida registrada y no delega implícitamente. Los estados `APPROVED`, `VERIFIED`, `COMPLIANT` y `RELEASED` solo los asigna el agente responsable tras cumplir sus gates.

## Flujo general SDD

```text
IDEA
  |
  v
CONSTITUTION
  |
  v
USE CASE
  |
  v
SPEC
  |
  v
PLAN
  |
  v
ARCHITECT
  |
  v
TASKS
  |
  v
IMPLEMENT
  |
  v
TEST
  |
  v
VERIFY
  |
  v
COMPLIANCE
  |
  v
RELEASE
```

Ningún agente debe omitir etapas sin autorización explícita y evidencia de la decisión.

## Flujo de dependencias entre agentes

```text
Constitution-Agent
        |
        v
      UseCase-Agent
        |
        v
      Spec-Agent
        |
        v
Plan-Agent
        |
        v
Architect-Agent
        |
        v
Tasks-Agent
        |
        +----------------------+----------------------+----------------------+
        |                      |                      |                      |
        v                      v                      v                      v
Backend-Agent          Database-Agent          DevOps-Agent          Security-Agent
        \______________________|______________________|______________________/
                               |
                               v
                         Test-Agent
                               |
                               v
                    Verification-Agent
                               |
                               v
                      Compliance-Agent
                               |
                               v
                        Release-Agent
```

El `Agente-Orquestador-Auditoria-SW` coordina el flujo especializado de auditoría y consolida los resultados del `Agente-Auditoria-SW`, `Verification-Agent` y `Compliance-Agent`.

## Estructura de directorios

```text
.github/
├── copilot-instructions.md
├── agents/
│   ├── Agente-Auditoria-SW.agent.md
│   ├── Agente-Orquestador-Auditoria-SW.agent.md
│   ├── Architect-Agent.agent.md
│   ├── Backend-Agent.agent.md
│   ├── Compliance-Agent.agent.md
│   ├── Constitution-Agent.agent.md
│   ├── Database-Agent.agent.md
│   ├── DevOps-Agent.agent.md
│   ├── Legacy-Discovery-Agent.agent.md
│   ├── Plan-Agent.agent.md
│   ├── Release-Agent.agent.md
│   ├── Security-Agent.agent.md
│   ├── Spec-Agent.agent.md
│   ├── Tasks-Agent.agent.md
│   ├── Test-Agent.agent.md
│   ├── UseCase-Agent.agent.md
│   ├── Verification-Agent.agent.md
├── instructions/
│   └── python.instructions.md
├── prompts/
│   └── auditoria-sw.prompt.md
├── skills/
│   ├── README.md
│   ├── auditing/SKILL.md
│   ├── clean-architecture/SKILL.md
│   ├── cqrs/SKILL.md
│   ├── devops/SKILL.md
│   ├── dotnet/SKILL.md
│   ├── explore_db/SKILL.md
│   ├── github/SKILL.md
│   ├── lessons-learned/SKILL.md
│   ├── legacy-system-discovery/SKILL.md
│   ├── security/SKILL.md
│   ├── testing/SKILL.md
└── docs/
    └── agents-README.md
```

## Coordinator Agents

### Agente-Orquestador-Auditoria-SW

**Ubicación:** `.github/agents/Agente-Orquestador-Auditoria-SW.agent.md`

**Responsabilidades:**

- Validar entradas, agentes, prompts, scripts y dependencias.
- Coordinar auditoría técnica, verificación y cumplimiento.
- Consolidar reportes y validar su consistencia.
- Coordinar la generación de diagramas.
- Registrar estados, errores y criterios de salida.

**Modo de ejecución sin scripts:**

El flujo de auditoría debe conservar los diagramas Mermaid en el reporte y continuar con VERIFY sin depender de herramientas de exportación.

No realiza auditorías directamente ni genera hallazgos técnicos propios.

## Documentation Agents

### Legacy-Discovery-Agent

**Ubicación:** `.github/agents/Legacy-Discovery-Agent.agent.md`

Levanta el estado actual de sistemas heredados con evidencia, relaciona objetivos/casos y escenarios con pantallas y código, y prepara inventarios y reportes de cobertura. Complementa `UseCase-Agent`; no aprueba reglas de negocio, no declara pruebas ejecutadas y no diseña la arquitectura futura.

**Skill asociada:** `legacy-system-discovery`.

**Pregunta principal:** ¿Qué hace actualmente el sistema y qué evidencia respalda cada flujo?

### Constitution-Agent

**Ubicación:** `.github/agents/Constitution-Agent.agent.md`

Define y mantiene las reglas de gobierno del proyecto usando las fuentes disponibles y las rutas acordadas para el alcance.

**Pregunta principal:** ¿Cuáles son las reglas permanentes del proyecto?

### Spec-Agent

**Ubicación:** `.github/agents/Spec-Agent.agent.md`

Transforma necesidades del negocio en especificaciones completas, verificables y trazables.

**Artefactos principales:** Especificación, criterios de aceptación y riesgos de la funcionalidad, en la ubicación acordada para el alcance.

**Pregunta principal:** ¿Qué debemos construir?

### Plan-Agent

**Ubicación:** `.github/agents/Plan-Agent.agent.md`

Convierte una especificación aprobada en una estrategia de ejecución.

**Artefacto principal:** Plan técnico de ejecución en la ubicación acordada para el alcance.

**Pregunta principal:** ¿Cómo organizaremos la implementación?

### Tasks-Agent

**Ubicación:** `.github/agents/Tasks-Agent.agent.md`

Descompone el plan y la arquitectura aprobados en tareas pequeñas, asignables, trazables y verificables.

**Artefacto principal:** Tareas ejecutables en la ubicación acordada para el alcance.

**Pregunta principal:** ¿Qué trabajo específico debe ejecutarse?

### UseCase-Agent

**Ubicación:** `.github/agents/UseCase-Agent.agent.md`

Genera casos de uso en la ubicación acordada, siguiendo el formato de los casos de uso existentes cuando los haya.

**Responsabilidades principales:**

- Solicitar informacion minima obligatoria para identificar modulo/aplicacion objetivo.
- Crear carpeta destino en `docs/use-cases/<modulo-o-aplicacion>/` cuando no exista.
- Generar casos de uso trazables, verificables y estructurados.
- Marcar supuestos y pendientes como `por confirmar` cuando no haya evidencia.

**Pregunta principal:** ¿Como debe documentarse funcionalmente este modulo con casos de uso verificables?

## Architecture Agents

### Architect-Agent

**Ubicación:** `.github/agents/Architect-Agent.agent.md`

Define la arquitectura técnica compatible con la solución actual.

**Artefactos principales:** Diseño de arquitectura, decisiones y diagramas aplicables, en las ubicaciones acordadas para el alcance.

**Pregunta principal:** ¿Cómo debe diseñarse la solución sin romper la arquitectura existente?

## Development Agents

### Regla obligatoria de descubrimiento

Antes de generar o modificar código, todos los agentes de desarrollo deben analizar, cuando existan:

```text
/src
/tests
/spec
/docs/architecture
/docs/requirements
/spec/traceability
```

Deben identificar:

- Arquitectura implementada.
- Lenguajes, frameworks y herramientas actuales.
- Patrones y convenciones existentes.
- Dependencias y mecanismos de integración.
- Estrategia de persistencia.
- Estrategia de pruebas y cobertura.
- Decisiones registradas en ADR.

Está prohibido introducir una tecnología, framework o patrón nuevo sin una ADR aprobada.

### Backend-Agent

**Ubicación:** `.github/agents/Backend-Agent.agent.md`

Implementa APIs, controladores, comandos, consultas, handlers, servicios y casos de uso, respetando los patrones encontrados en el repositorio.

### Database-Agent

**Ubicación:** `.github/agents/Database-Agent.agent.md`

Implementa cambios de persistencia, migraciones, configuraciones, scripts y optimizaciones usando el mecanismo vigente, por ejemplo EF Core, Dapper, SQL nativo o procedimientos almacenados.

### DevOps-Agent

**Ubicación:** `.github/agents/DevOps-Agent.agent.md`

Mantiene y evoluciona CI/CD, workflows, contenedores, infraestructura y automatización sin sustituir herramientas existentes sin aprobación.

### Security-Agent

**Ubicación:** `.github/agents/Security-Agent.agent.md`

Implementa y revisa controles de autenticación, autorización, secretos, dependencias y configuración segura, preservando la estrategia vigente.

### Test-Agent

**Ubicación:** `.github/agents/Test-Agent.agent.md`

Diseña, implementa, mantiene y ejecuta pruebas alineadas con los requisitos, criterios de aceptación, arquitectura existente y principios ISTQB.

**Responsabilidades:**

- Pruebas unitarias.
- Pruebas de integración.
- Pruebas de sistema.

- Pruebas de arquitectura (NetArchTest.Rules en .NET, únicamente después de aprobar ADR-001).
- Pruebas de seguridad y rendimiento cuando apliquen.
- Diseño basado en riesgo, particiones de equivalencia, valores límite, tablas de decisión, transiciones de estado y combinaciones relevantes.
- Trazabilidad `Requirement -> Acceptance Criteria -> Test Case -> Evidence`.
- Generación de estrategia e informe de cobertura cuando se solicite.

**Quality Gates mínimos:**

- Cobertura de líneas igual o superior al 80 %.
- Cobertura de ramas igual o superior al 80 %.
- Cobertura de condiciones o combinaciones igual o superior al 80 % cuando la herramienta lo soporte.
- No declarar condition coverage usando branch coverage como sustituto.
- Cero pruebas fallidas para considerar el trabajo terminado.

## Review Agents

### Agente-Auditoria-SW

**Ubicación:** `.github/agents/Agente-Auditoria-SW.agent.md`

Ejecuta la auditoría técnica, arquitectónica y de seguridad basada en evidencia.

**Prompt especializado:** `.github/prompts/auditoria-sw.prompt.md`

**Artefacto principal:** `Auditoria de SW.md`

**Salidas mínimas esperadas en modo manual:**

- Hallazgos con evidencia verificable.
- Tabla de patrones detectados (patrón, archivo de entrada, funcionalidad).
- Diagramas Mermaid BDD, SDD, SEQ, ACT y STD (cuando aplique).

### Verification-Agent

**Ubicación:** `.github/agents/Verification-Agent.agent.md`

Verifica que la implementación satisfaga requisitos, criterios de aceptación y objetivos funcionales mediante evidencia objetiva.

**Artefactos:** Informe y matriz de verificación, cuando apliquen.

**Estados finales:**

- `VERIFIED`
- `PARTIALLY_VERIFIED`
- `NOT_VERIFIED`

### Compliance-Agent

**Ubicación:** `.github/agents/Compliance-Agent.agent.md`

Valida trazabilidad, evidencia, gobernanza, calidad documental y cumplimiento del ciclo SDD.

**Artefacto principal:** Informe de cumplimiento.

**Estados finales:**

- `COMPLIANT`
- `PARTIALLY_COMPLIANT`
- `NON_COMPLIANT`

## Release Agents

### Release-Agent

**Ubicación:** `.github/agents/Release-Agent.agent.md`

Valida que la versión cumpla todos los Quality Gates antes de autorizar la liberación.

**Responsabilidades:**

- Validar build, pruebas, cobertura, seguridad, trazabilidad, verificación y cumplimiento.
- Validar que no existan hallazgos críticos abiertos.
- Preparar documentación de liberación.
- Determinar la disposición final de la versión.

**Artefactos:** Notas de versión, checklist de despliegue, plan de rollback y resumen de liberación, cuando se soliciten.

**Estados finales:**

- `APPROVED`
- `APPROVED_WITH_RISK`
- `REJECTED`

El estado `APPROVED_WITH_RISK` requiere riesgos documentados y aceptación humana explícita.

## Artefactos principales

| Etapa | Agente | Artefacto principal |
|---|---|---|
| Constitution | Constitution-Agent | Reglas de gobierno acordadas |
| Spec | Spec-Agent | Especificación y criterios de aceptación |
| Plan | Plan-Agent | Plan técnico |
| Architecture | Architect-Agent | Diseño y decisiones arquitectónicas |
| Tasks | Tasks-Agent | Tareas ejecutables |
| Functional Use Cases | UseCase-Agent | Casos de uso en la ubicación acordada |
| Current-State Discovery | Legacy-Discovery-Agent | Inventario, trazabilidad, borradores y reporte de cobertura |
| Implement | Development Agents | Código y configuración |
| Test | Test-Agent | Pruebas, estrategia e informe de cobertura |
| Audit | Agente-Auditoria-SW | Reporte de auditoría |
| Verify | Verification-Agent | Reporte de verificación |
| Compliance | Compliance-Agent | Reporte de cumplimiento |
| Release | Release-Agent | Documentación de liberación |

## Skills Library

La carpeta `.github/skills/` contiene conocimiento operativo reutilizable por dominio.

Cada skill define:

- Proposito
- Cuando usar
- Entradas requeridas
- Salidas esperadas
- Flujo recomendado
- Criterios de aceptacion
- Riesgos comunes

## Mapeo Agente -> Skills

| Agente | Skills asociadas |
|---|---|
| Constitution-Agent | `lessons-learned`, `github` |
| Spec-Agent | `clean-architecture`, `cqrs`, `lessons-learned` |
| Plan-Agent | `clean-architecture`, `cqrs`, `testing`, `devops` |
| Tasks-Agent | `dotnet`, `testing`, `security`, `devops` |
| UseCase-Agent | `lessons-learned`, `clean-architecture`, `cqrs`, `auditing`, `explore_db` (condicional) |
| Legacy-Discovery-Agent | `legacy-system-discovery` |
| Architect-Agent | `clean-architecture`, `cqrs`, `security`, `explore_db` (condicional) |
| Backend-Agent | `dotnet`, `clean-architecture`, `cqrs`, `security`, `explore_db` (condicional) |
| Database-Agent | `explore_db`, `dotnet`, `security`, `auditing` |
| DevOps-Agent | `devops`, `github`, `security`, `testing` |
| Security-Agent | `security`, `auditing`, `lessons-learned`, `explore_db` (condicional) |
| Test-Agent | `testing`, `dotnet`, `github`, `explore_db` (condicional) |
| Agente-Auditoria-SW | `auditing`, `security`, `clean-architecture`, `lessons-learned`, `explore_db` (condicional) |
| Verification-Agent | `testing`, `auditing`, `cqrs`, `explore_db` (condicional) |
| Compliance-Agent | `auditing`, `github`, `lessons-learned` |
| Release-Agent | `testing`, `devops`, `github`, `security` |

`explore_db` se activa condicionalmente solo cuando la tarea requiere descubrir una base SQL Server/Azure SQL desconocida.

## Regla de activacion de skills

Antes de ejecutar una tarea, cada agente debe activar las skills aplicables al alcance solicitado.

Orden recomendado:

1. `lessons-learned` (para controles preventivos y reutilizacion de decisiones)
2. Skill de arquitectura (`clean-architecture` o `cqrs`)
3. Skill tecnologica (`dotnet`, `devops`, `github`)
4. Skill de aseguramiento (`testing`, `security`, `auditing`)

Si una skill no aplica, el agente debe registrar la justificacion en su salida.

## Knowledge Harness

Los agentes deben consultar las fuentes disponibles que correspondan al alcance:

```text
.github/copilot-instructions.md
.github/prompts/
.github/skills/
soluciones, proyectos, documentación y pruebas existentes
```

Si falta una fuente necesaria para validar una conclusión, documentar esa limitación y no inventar evidencia.

Los prompts contienen conocimiento reutilizable. Los agentes consumen ese conocimiento para ejecutar una responsabilidad concreta.

```text
Agente-Auditoria-SW
        |
        v
.github/prompts/auditoria-sw.prompt.md
```

## Trazabilidad obligatoria

Toda funcionalidad debe mantener la relación:

```text
Requirement
  -> Use Case
  -> Spec
  -> Plan
  -> Architecture
  -> Task
  -> Implementation
  -> Test
  -> Evidence
  -> Verification
  -> Compliance
  -> Release
```

Cuando un vínculo no exista, debe registrarse como no evidenciado y no debe inventarse.

## Quality Gates

Una funcionalidad solo puede avanzar a liberación cuando:

- La constitución aplicable está disponible.
- La especificación está aprobada.
- El plan está aprobado.
- La arquitectura y las ADR necesarias están aprobadas.
- Las tareas están completas y trazadas.
- El build es exitoso.
- Las pruebas requeridas están ejecutadas y aprobadas.

- Las pruebas de arquitectura pasan cuando se requieren; si faltan, registrar BLOCKED. NetArchTest.Rules requiere ADR-001 aprobada.
- Line coverage >= 80 % y branch coverage >= 80 %; condition coverage >= 80 % cuando exista una métrica independiente. No usar branch coverage como proxy.
- `Verification-Agent` emite `VERIFIED`.
- `Compliance-Agent` emite `COMPLIANT`, o existe aceptación humana explícita para un resultado permitido por la política del proyecto.
- No existen hallazgos críticos abiertos.
- Existe evidencia verificable.
- `Release-Agent` emite la disposición correspondiente.

El software no debe considerarse terminado únicamente porque compile.

## Lecciones aprendidas

Antes de proponer soluciones, los agentes deben buscar lecciones aprendidas aplicables.

- Si existe una lección aplicable, debe referenciarse y reutilizarse.
- Si no existe, debe sugerirse su documentación conforme a `PE-GC-42 Lecciones aprendidas rev. 6`.

## Gobernanza de IA

Todo contenido generado por agentes debe:

- Ser revisado por una persona responsable.
- Mantener trazabilidad y evidencia verificable.
- Respetar la confidencialidad y la clasificación de la información.
- Respetar la arquitectura y las decisiones aprobadas.
- Cumplir la constitución, estándares y Quality Gates del proyecto.
- Ser validado antes de integrarse o liberarse.

La responsabilidad final permanece en el equipo humano.

## Reglas generales

Todo agente debe:

- Analizar antes de modificar.
- Utilizar rutas y evidencia reales.
- Diferenciar hechos, inferencias y elementos no revisados.
- Mantener consistencia con la arquitectura existente.
- Mantener trazabilidad y evidencia.
- Detenerse y reportar cuando falte una entrada obligatoria.

Está prohibido:

- Inventar requisitos, resultados o evidencias.
- Introducir frameworks no aprobados.
- Cambiar la arquitectura sin ADR.
- Exponer secretos o credenciales.
- Eliminar trazabilidad.
- Ignorar la constitución o los Quality Gates.
- Autorizar una liberación sin evidencia suficiente.

## Regla fundamental

Cuando exista conflicto entre crear una nueva arquitectura y extender la arquitectura existente, se debe **extender la arquitectura existente**, salvo que exista una ADR aprobada que indique explícitamente lo contrario.

## Uso en VS Code y GitHub Copilot

- Los agentes aparecen en el selector **Agent** del chat (`.github/agents/*.agent.md`).
- Cada agente ofrece botones de transición (`handoffs`) a la siguiente etapa SDD; todos usan `send: false` para conservar la aprobación humana.
- El Orquestador solo puede invocar como subagentes a Agente-Auditoria-SW, Verification-Agent y Compliance-Agent (`agents`).
- El prompt de auditoría se invoca con `/auditoria-sw`.
- Las reglas de Python viven en `.github/instructions/python.instructions.md` y solo aplican a archivos `*.py` (`applyTo`).
- Las skills se descubren en `.github/skills/` (el `name` coincide con la carpeta).
- No colocar archivos `.md` ajenos a agentes dentro de `.github/agents/`: VS Code los trata como agentes.
