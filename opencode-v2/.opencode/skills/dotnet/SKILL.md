---
name: dotnet
description: "Estandarizar cambios en soluciones .NET respetando convenciones existentes, compatibilidad y mantenibilidad. Usar cuando: Nuevos endpoints o servicios backend; Refactor de proyectos .NET existentes; Ajustes de configuracion y dependencias."
---

# Skill: dotnet

## Proposito

Estandarizar cambios en soluciones .NET respetando convenciones existentes, compatibilidad y mantenibilidad.

## Cuando usar

- Nuevos endpoints o servicios backend
- Refactor de proyectos .NET existentes
- Ajustes de configuracion y dependencias

## Entradas requeridas

- Archivos de solucion y proyectos (.sln, .csproj, .vbproj)
- Configuracion de entorno y build
- Especificacion y tareas aprobadas

## Salidas esperadas

- Cambios de codigo consistentes con patrones actuales
- Configuracion ajustada sin romper compatibilidad
- Pruebas ejecutadas o plan de verificacion documentado

## Flujo recomendado

1. Detectar version de .NET y stack actual.
2. Revisar convenciones de capas, namespaces y DI.
3. Implementar cambios minimos y trazables.
4. Validar compilacion y pruebas aplicables. Usar NetArchTest.Rules solo cuando esté aprobado por ADR y exista un proyecto de pruebas de arquitectura configurado.
5. Registrar riesgos y deuda tecnica remanente.

## Criterios de aceptacion

- Sin introduccion de dependencias no aprobadas.
- Sin ruptura de arquitectura existente.
- Cambios con evidencia de validacion.

- Reglas de arquitectura verificadas con la herramienta aprobada para el repositorio; NetArchTest.Rules no se incorpora sin ADR aprobada.

## Riesgos comunes

- Cambios en paquete o version sin analisis de impacto
- Logica de negocio en controladores o UI
- Omision de manejo de errores
