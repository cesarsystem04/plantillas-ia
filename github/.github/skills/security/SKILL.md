---
name: security
description: "Guiar evaluaciones y correcciones de seguridad por diseno durante analisis, implementacion y liberacion. Usar cuando: Cambios en autenticacion/autorizacion; Manejo de datos sensibles; Revision de dependencias y configuraciones."
---

# Skill: security

## Proposito

Guiar evaluaciones y correcciones de seguridad por diseno durante analisis, implementacion y liberacion.

## Cuando usar

- Cambios en autenticacion/autorizacion
- Manejo de datos sensibles
- Revision de dependencias y configuraciones

## Entradas requeridas

- Codigo y configuracion relevante
- Politicas internas de seguridad
- Amenazas y riesgos conocidos

## Salidas esperadas

- Lista de hallazgos con severidad
- Acciones de mitigacion priorizadas
- Evidencia de verificaciones realizadas

## Flujo recomendado

1. Identificar superficie de ataque por modulo.
2. Revisar secretos, validacion de entrada y control de acceso.
3. Evaluar dependencias y configuracion insegura.
4. Proponer mitigaciones con impacto y esfuerzo.
5. Confirmar remediacion y evidencias.

## Criterios de aceptacion

- No exponer secretos ni credenciales reales.
- Hallazgos criticos tienen plan de remediacion.
- Recomendaciones son verificables y trazables.

## Riesgos comunes

- Credenciales hardcoded
- Falta de validacion de entrada
- Permisos excesivos por defecto
