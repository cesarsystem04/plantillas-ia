---
name: clean-architecture
description: "Guiar decisiones y cambios para mantener separacion de responsabilidades, bajo acoplamiento y alta cohesion. Usar cuando: Diseno de nuevas features; Refactor de modulos existentes; Revision de limites entre capas."
---

# Skill: clean-architecture

## Proposito

Guiar decisiones y cambios para mantener separacion de responsabilidades, bajo acoplamiento y alta cohesion.

## Cuando usar

- Diseno de nuevas features
- Refactor de modulos existentes
- Revision de limites entre capas

## Entradas requeridas

- Codigo fuente en /src
- Documentacion de arquitectura en /docs/architecture cuando exista
- Especificacion de feature en /spec cuando exista

## Salidas esperadas

- Propuesta de estructura por capas
- Lista de dependencias permitidas y prohibidas
- Riesgos de acoplamiento detectados
- Recomendaciones de correccion por prioridad

## Flujo recomendado

1. Detectar capas reales actuales (presentacion, aplicacion, dominio, infraestructura).
2. Comparar primero con la arquitectura y las ADR aprobadas del repositorio; no asumir Clean Architecture por el nombre de esta skill.
3. Verificar direccion de dependencias entre capas.
4. Identificar violaciones (logica de negocio en UI, acceso a datos en capa de aplicacion, etc.).
5. Proponer cambios minimos compatibles con el sistema existente.
6. Asociar cada cambio a evidencia concreta y ruta de archivo.

## Criterios de aceptacion

- Toda recomendacion tiene evidencia verificable.
- No se propone reemplazar arquitectura sin ADR aprobada.
- Se prioriza extension de patrones ya existentes.

## Riesgos comunes

- Cambios grandes sin plan incremental
- Introduccion de frameworks no autorizados
- Mezcla de reglas de negocio con detalles de infraestructura
