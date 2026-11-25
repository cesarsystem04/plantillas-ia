---
name: cqrs
description: "Ayudar a implementar o revisar separacion de responsabilidades entre comandos (cambios de estado) y consultas (lectura). Usar cuando: Nuevos casos de uso de negocio; APIs con lectura y escritura diferenciada; Reduccion de acoplamiento en handlers o servicios."
---

# Skill: cqrs

## Proposito

Ayudar a implementar o revisar separacion de responsabilidades entre comandos (cambios de estado) y consultas (lectura).

## Cuando usar

- Nuevos casos de uso de negocio
- APIs con lectura y escritura diferenciada
- Reduccion de acoplamiento en handlers o servicios

## Entradas requeridas

- Caso de uso y criterios de aceptacion
- Modelos de dominio y contratos
- Evidencia de patron actual (MediatR, services, handlers)

## Salidas esperadas

- Mapa de Commands y Queries por caso de uso
- Reglas de validacion por comando
- Estrategia de consultas optimizadas
- Checklist de trazabilidad a pruebas

## Flujo recomendado

1. Confirmar que CQRS ya existe o que una ADR aprobada autoriza su uso; si no, no introducir el patrón.
2. Clasificar cada operacion como comando o consulta.
3. Definir contratos de entrada y salida.
4. Aplicar validaciones antes de cambiar estado.
5. Mantener consultas libres de efectos colaterales.
6. Cubrir cada command/query con pruebas.

## Criterios de aceptacion

- No existen side-effects en consultas.
- Comandos tienen validaciones de negocio explicitas.
- Se mantiene consistencia con la arquitectura ya implementada.

## Riesgos comunes

- Reutilizar la misma ruta para leer y escribir sin necesidad
- Filtrar reglas de negocio en controladores
- Mezclar acceso a datos en handlers sin abstracciones claras
