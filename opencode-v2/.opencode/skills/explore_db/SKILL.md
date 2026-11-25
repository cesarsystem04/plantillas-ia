---
name: explore_db
description: explora y documenta bases de datos sql server o azure sql desconocidas mediante consultas de metadatos, muestreo controlado y análisis iterativo. usar cuando copilot deba descubrir servidor, base activa, esquemas, tablas, columnas, claves, relaciones, restricciones, índices, vistas, procedimientos, funciones, triggers, volúmenes, jerarquías, entidades centrales, reglas de negocio implícitas, riesgos y oportunidades de optimización sin modificar datos.
---

# Explorar una base de datos SQL

## Objetivo

Comprender una base desconocida mediante ciclos cortos de consulta, resultado y análisis. Construir un modelo verificable de su estructura antes de proponer consultas funcionales, cambios, optimizaciones o código de aplicación.

Priorizar SQL Server y Azure SQL. Adaptar las consultas solo cuando el motor sea distinto y el usuario lo confirme.

## Principios obligatorios

1. Trabajar por defecto en modo solo lectura.
2. Ejecutar primero consultas de identidad y metadatos; consultar datos después.
3. No inferir relaciones, reglas o significados solo por nombres. Confirmar con claves, código SQL y muestras.
4. Pedir al usuario que ejecute un bloque pequeño y comparta el resultado antes de generar el siguiente bloque.
5. No solicitar credenciales, contraseñas, tokens ni cadenas con secretos.
6. No exponer datos personales, credenciales, secretos, hashes, tokens ni información sensible encontrada.
7. No ejecutar ni proponer `INSERT`, `UPDATE`, `DELETE`, `MERGE`, `TRUNCATE`, `DROP`, `ALTER`, `CREATE`, `GRANT`, `DENY`, `REVOKE`, `DBCC` o cambios de configuración durante la exploración, salvo solicitud explícita y revisión de impacto.
8. No usar `SELECT *` sobre tablas grandes. Emplear columnas explícitas y `TOP` limitado.
9. No usar `NOLOCK` como valor predeterminado. Explicar sus riesgos si se considera necesario.
10. No consultar valores de columnas sensibles. Para reconocerlas, inspeccionar únicamente metadatos y nombres de columna.
11. Registrar cada hallazgo con evidencia, consulta que lo demuestra y nivel de confianza.
12. Antes de una refactorización u optimización, crear una línea base funcional y de rendimiento.
13. Verificar primero si existe una lección aprendida aplicable. Si no existe, recomendar documentar el hallazgo conforme al procedimiento organizacional vigente de lecciones aprendidas.

## Entradas esperadas

Aceptar una o más de estas entradas:

- Motor y versión, si se conocen.
- Servidor o instancia, sin credenciales.
- Nombre de base, si se conoce.
- Objetivo funcional, error, tabla, reporte o flujo que se quiere comprender.
- Resultados tabulares o mensajes devueltos por consultas anteriores.
- Restricciones de acceso, tiempo o volumen.

Si no se conoce el alcance, iniciar con identidad de conexión y panorama general. No pedir un volcado completo de la base.

## Salida esperada

Mantener y actualizar un resumen con estas secciones:

- Identidad del entorno.
- Inventario de objetos.
- Diccionario preliminar de entidades.
- Relaciones confirmadas.
- Entidades centrales y rutas de navegación.
- Reglas de integridad y reglas de negocio inferidas.
- Objetos programables relevantes.
- Índices y observaciones de rendimiento.
- Seguridad visible por metadatos, sin revelar secretos.
- Preguntas abiertas y siguiente consulta recomendada.
- Riesgos, inconsistencias y lecciones aprendidas.

Clasificar afirmaciones como:

- **Confirmado:** demostrado por metadatos, definición de objeto o resultado reproducible.
- **Probable:** respaldado por nombres y varias señales, pero pendiente de confirmación.
- **Desconocido:** sin evidencia suficiente.

## Flujo de exploración

### Fase 0. Establecer límite y seguridad

Confirmar que las consultas serán de solo lectura y que el usuario tiene autorización para inspeccionar la base. Evitar conectarse a producción cuando exista un entorno de lectura, réplica o desarrollo apropiado.

### Fase 1. Confirmar identidad de conexión

Solicitar ejecutar:

```sql
SELECT
    @@SERVERNAME AS ServerName,
    DB_NAME() AS DatabaseName,
    ORIGINAL_LOGIN() AS OriginalLogin,
    SUSER_SNAME() AS CurrentLogin,
    USER_NAME() AS DatabaseUser,
    CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(128)) AS ProductVersion,
    CAST(SERVERPROPERTY('Edition') AS nvarchar(128)) AS Edition;
```

Interpretar cuidadosamente:

- Confirmar servidor e instancia.
- Confirmar base activa.
- Detectar si una aplicación o SSMS están en bases distintas.
- No pedir que se publique el login si contiene información sensible; permitir que el usuario lo oculte.

No avanzar a conclusiones funcionales si servidor o base no coinciden con el objetivo.

### Fase 2. Obtener panorama de esquemas y objetos

Solicitar:

```sql
SELECT
    s.name AS SchemaName,
    o.type_desc AS ObjectType,
    COUNT(*) AS ObjectCount
FROM sys.objects AS o
INNER JOIN sys.schemas AS s
    ON s.schema_id = o.schema_id
WHERE o.is_ms_shipped = 0
GROUP BY s.name, o.type_desc
ORDER BY s.name, o.type_desc;
```

Luego inventariar objetos principales:

```sql
SELECT
    s.name AS SchemaName,
    o.name AS ObjectName,
    o.type_desc AS ObjectType,
    o.create_date AS CreatedAt,
    o.modify_date AS ModifiedAt
FROM sys.objects AS o
INNER JOIN sys.schemas AS s
    ON s.schema_id = o.schema_id
WHERE o.is_ms_shipped = 0
  AND o.type IN ('U', 'V', 'P', 'FN', 'IF', 'TF', 'TR')
ORDER BY o.type_desc, s.name, o.name;
```

Si el resultado es muy grande, pedir filtrarlo por esquema, prefijo, módulo o término funcional. No solicitar miles de filas sin necesidad.

### Fase 3. Priorizar tablas por tamaño y relevancia

Solicitar una vista panorámica:

```sql
SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    SUM(CASE WHEN p.index_id IN (0, 1) THEN p.rows ELSE 0 END) AS ApproxRows,
    COUNT(DISTINCT c.column_id) AS ColumnCount
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
INNER JOIN sys.columns AS c
    ON c.object_id = t.object_id
LEFT JOIN sys.partitions AS p
    ON p.object_id = t.object_id
WHERE t.is_ms_shipped = 0
GROUP BY s.name, t.name
ORDER BY ApproxRows DESC, s.name, t.name;
```

Usar el resultado para identificar:

- Tablas transaccionales grandes.
- Catálogos pequeños.
- Tablas puente potenciales.
- Tablas de auditoría, historial, configuración o seguridad.

No asumir que la tabla más grande es la entidad central.

### Fase 4. Inspeccionar columnas de tablas candidatas

Para varias tablas candidatas usar:

```sql
DECLARE @SchemaName sysname = N'dbo';
DECLARE @TableName sysname = N'ReplaceTableName';
SELECT
    c.column_id AS Ordinal,
    c.name AS ColumnName,
    TYPE_NAME(c.user_type_id) AS DataType,
    c.max_length AS MaxLengthBytes,
    c.precision AS NumericPrecision,
    c.scale AS NumericScale,
    c.is_nullable AS IsNullable,
    c.is_identity AS IsIdentity,
    c.is_computed AS IsComputed,
    dc.definition AS DefaultDefinition,
    cc.definition AS ComputedDefinition
FROM sys.columns AS c
INNER JOIN sys.tables AS t
    ON t.object_id = c.object_id
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
LEFT JOIN sys.default_constraints AS dc
    ON dc.parent_object_id = c.object_id
   AND dc.parent_column_id = c.column_id
LEFT JOIN sys.computed_columns AS cc
    ON cc.object_id = c.object_id
   AND cc.column_id = c.column_id
WHERE s.name = @SchemaName
  AND t.name = @TableName
ORDER BY c.column_id;
```

Resumir para cada tabla:

- Identificador.
- Claves de negocio candidatas.
- Estados y banderas.
- Fechas de creación, actualización o vigencia.
- Importes, cantidades y unidades.
- Campos descriptivos.
- Columnas potencialmente sensibles, sin consultar sus valores.

### Fase 5. Descubrir claves y relaciones

Claves primarias y únicas:

```sql
SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    kc.name AS ConstraintName,
    kc.type_desc AS ConstraintType,
    STRING_AGG(QUOTENAME(c.name), ', ')
        WITHIN GROUP (ORDER BY ic.key_ordinal) AS KeyColumns
FROM sys.key_constraints AS kc
INNER JOIN sys.tables AS t
    ON t.object_id = kc.parent_object_id
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
INNER JOIN sys.index_columns AS ic
    ON ic.object_id = t.object_id
   AND ic.index_id = kc.unique_index_id
INNER JOIN sys.columns AS c
    ON c.object_id = ic.object_id
   AND c.column_id = ic.column_id
GROUP BY s.name, t.name, kc.name, kc.type_desc
ORDER BY s.name, t.name, kc.type_desc;
```

Claves foráneas:

```sql
SELECT
    fk.name AS ForeignKeyName,
    ps.name AS ParentSchema,
    pt.name AS ParentTable,
    pc.name AS ParentColumn,
    rs.name AS ReferencedSchema,
    rt.name AS ReferencedTable,
    rc.name AS ReferencedColumn,
    fk.delete_referential_action_desc AS OnDelete,
    fk.update_referential_action_desc AS OnUpdate,
    fk.is_disabled AS IsDisabled,
    fk.is_not_trusted AS IsNotTrusted
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc
    ON fkc.constraint_object_id = fk.object_id
INNER JOIN sys.tables AS pt
    ON pt.object_id = fk.parent_object_id
INNER JOIN sys.schemas AS ps
    ON ps.schema_id = pt.schema_id
INNER JOIN sys.columns AS pc
    ON pc.object_id = fkc.parent_object_id
   AND pc.column_id = fkc.parent_column_id
INNER JOIN sys.tables AS rt
    ON rt.object_id = fk.referenced_object_id
INNER JOIN sys.schemas AS rs
    ON rs.schema_id = rt.schema_id
INNER JOIN sys.columns AS rc
    ON rc.object_id = fkc.referenced_object_id
   AND rc.column_id = fkc.referenced_column_id
ORDER BY ps.name, pt.name, fk.name, fkc.constraint_column_id;
```

Construir un mapa de relaciones. Distinguir relaciones confirmadas mediante FK de relaciones lógicas sin constraint.

### Fase 6. Descubrir reglas de integridad

Solicitar defaults y checks:

```sql
SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    cc.name AS CheckName,
    cc.definition AS CheckDefinition,
    cc.is_disabled AS IsDisabled,
    cc.is_not_trusted AS IsNotTrusted
FROM sys.check_constraints AS cc
INNER JOIN sys.tables AS t
    ON t.object_id = cc.parent_object_id
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
ORDER BY s.name, t.name, cc.name;
```

Identificar reglas como:

- Rangos válidos.
- No negatividad.
- Estados permitidos.
- Unicidad compuesta.
- Bajas lógicas.
- Valores predeterminados.

No llamar “regla de negocio” a una inferencia hasta confirmarla con constraint, código o comportamiento reproducible.

### Fase 7. Inspeccionar índices

Solicitar:

```sql
SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_unique AS IsUnique,
    i.is_primary_key AS IsPrimaryKey,
    i.is_disabled AS IsDisabled,
    i.has_filter AS HasFilter,
    i.filter_definition AS FilterDefinition,
    STRING_AGG(
        CASE WHEN ic.is_included_column = 0 THEN QUOTENAME(c.name) END,
        ', '
    ) WITHIN GROUP (ORDER BY ic.key_ordinal) AS KeyColumns,
    STRING_AGG(
        CASE WHEN ic.is_included_column = 1 THEN QUOTENAME(c.name) END,
        ', '
    ) WITHIN GROUP (ORDER BY c.column_id) AS IncludedColumns
FROM sys.indexes AS i
INNER JOIN sys.tables AS t
    ON t.object_id = i.object_id
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
LEFT JOIN sys.index_columns AS ic
    ON ic.object_id = i.object_id
   AND ic.index_id = i.index_id
LEFT JOIN sys.columns AS c
    ON c.object_id = ic.object_id
   AND c.column_id = ic.column_id
WHERE t.is_ms_shipped = 0
  AND i.index_id > 0
GROUP BY
    s.name, t.name, i.name, i.type_desc, i.is_unique,
    i.is_primary_key, i.is_disabled, i.has_filter, i.filter_definition
ORDER BY s.name, t.name, i.name;
```

Si la versión del motor no admite `STRING_AGG ... WITHIN GROUP`, adaptar sin alterar el objetivo.

No recomendar índices solo por nombre o por sugerencias del plan. Pedir consulta, filtro, cardinalidad y línea base.

### Fase 8. Inspeccionar vistas y objetos programables

Primero localizar objetos por nombre o términos funcionales:

```sql
DECLARE @Pattern nvarchar(128) = N'%ReplaceTerm%';
SELECT
    s.name AS SchemaName,
    o.name AS ObjectName,
    o.type_desc AS ObjectType
FROM sys.objects AS o
INNER JOIN sys.schemas AS s
    ON s.schema_id = o.schema_id
WHERE o.is_ms_shipped = 0
  AND o.name LIKE @Pattern
ORDER BY o.type_desc, s.name, o.name;
```

Para objetos seleccionados, consultar su definición únicamente si el usuario tiene permiso:

```sql
SELECT OBJECT_DEFINITION(OBJECT_ID(N'dbo.ReplaceObjectName')) AS ObjectDefinition;
```

Analizar:

- Tablas consultadas o modificadas.
- Parámetros.
- Transacciones.
- Manejo de errores.
- SQL dinámico y parametrización.
- Filtros de estado o vigencia.
- Reglas repetidas.
- Salidas usadas por APIs o reportes.

Nunca ejecutar un procedimiento desconocido solo para descubrir qué hace. Inspeccionar definición y dependencias primero.

Dependencias declaradas:

```sql
SELECT
    OBJECT_SCHEMA_NAME(referencing_id) AS ReferencingSchema,
    OBJECT_NAME(referencing_id) AS ReferencingObject,
    referenced_schema_name AS ReferencedSchema,
    referenced_entity_name AS ReferencedEntity,
    referenced_class_desc AS ReferencedClass
FROM sys.sql_expression_dependencies
WHERE referenced_entity_name IS NOT NULL
ORDER BY ReferencingSchema, ReferencingObject, ReferencedSchema, ReferencedEntity;
```

### Fase 9. Inspeccionar triggers

```sql
SELECT
    OBJECT_SCHEMA_NAME(tr.parent_id) AS ParentSchema,
    OBJECT_NAME(tr.parent_id) AS ParentObject,
    tr.name AS TriggerName,
    tr.is_instead_of_trigger AS IsInsteadOf,
    tr.is_disabled AS IsDisabled,
    sm.definition AS TriggerDefinition
FROM sys.triggers AS tr
LEFT JOIN sys.sql_modules AS sm
    ON sm.object_id = tr.object_id
WHERE tr.parent_class_desc = 'OBJECT_OR_COLUMN'
ORDER BY ParentSchema, ParentObject, TriggerName;
```

Buscar auditoría, sincronización, validaciones adicionales y efectos laterales de escritura.

### Fase 10. Muestrear datos de manera controlada

Solo después de entender columnas y sensibilidad, proponer una consulta específica:

```sql
SELECT TOP (20)
    Id,
    ReplaceBusinessColumn,
    ReplaceStatusColumn,
    ReplaceDateColumn
FROM dbo.ReplaceTableName
ORDER BY Id DESC;
```

Reglas:

- Elegir columnas explícitas.
- Excluir secretos y datos personales.
- Usar `TOP` y un orden determinista.
- No exportar datasets completos.
- Usar agregados cuando basten para validar distribución.

Ejemplo de distribución de estado:

```sql
SELECT
    ReplaceStatusColumn AS StatusValue,
    COUNT_BIG(*) AS RowCount
FROM dbo.ReplaceTableName
GROUP BY ReplaceStatusColumn
ORDER BY RowCount DESC;
```

### Fase 11. Detectar jerarquías y tablas puente

Buscar columnas con patrones `ParentId`, `Parent*Id`, `Level`, `Path`, `Hierarchy`, `left/right`, además de FKs autorreferenciadas. Confirmar antes de proponer CTE recursivo.

Para autorrelaciones confirmadas, usar una plantilla segura y limitada:

```sql
;WITH Hierarchy AS
(
    SELECT
        Id,
        ParentId,
        CAST(Name AS nvarchar(max)) AS NodePath,
        0 AS NodeLevel
    FROM dbo.ReplaceTable
    WHERE ParentId IS NULL
    UNION ALL
    SELECT
        c.Id,
        c.ParentId,
        CAST(h.NodePath + N' > ' + c.Name AS nvarchar(max)),
        h.NodeLevel + 1
    FROM dbo.ReplaceTable AS c
    INNER JOIN Hierarchy AS h
        ON h.Id = c.ParentId
)
SELECT TOP (500)
    Id,
    ParentId,
    NodePath,
    NodeLevel
FROM Hierarchy
ORDER BY NodePath
OPTION (MAXRECURSION 100);
```

No usar `MAXRECURSION 0` durante exploración inicial. Primero detectar ciclos o profundidad anómala.

### Fase 12. Analizar rendimiento solo con línea base

Antes de optimizar, comprobar equivalencia funcional con `EXCEPT` en ambas direcciones o con una comparación adecuada al caso. Si existen duplicados relevantes, no usar solo `EXCEPT`; incluir claves y conteos.

Activar medición en una sesión controlada:

```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
-- Ejecutar consulta de línea base.
-- Ejecutar consulta candidata.
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
```

Comparar:

- Resultado funcional.
- Lecturas lógicas.
- CPU.
- Tiempo transcurrido.
- Filas reales frente a estimadas.
- Operadores de plan.

No afirmar que `Index Seek` siempre es mejor que `Scan`. Evaluar volumen, selectividad y costo total.

### Fase 13. Identificar entidades centrales

Asignar prioridad usando señales combinadas, no una única métrica:

- Número de FKs entrantes y salientes.
- Presencia en vistas, procedimientos y funciones.
- Volumen y frecuencia aparente de uso.
- Participación en flujos funcionales.
- Relación con catálogos, transacciones e historial.

Entregar candidatos con evidencia. Evitar afirmar que una entidad es “central” solo por tamaño.

### Fase 14. Cerrar con un modelo aprendido

Al final de cada iteración producir, en Markdown:

- `## Hallazgos confirmados`
- `## Hipótesis pendientes`
- `## Riesgos o inconsistencias`
- `## Objetos prioritarios`
- `## Próxima consulta recomendada`, seguida por un bloque SQL pequeño y de solo lectura.
- `## Diccionario acumulado`, con columnas: Objeto, Tipo, Propósito probable, Evidencia y Confianza.

Mantener el diccionario acumulado durante toda la conversación.

## Manejo de errores comunes

### `Invalid object name`

Verificar en este orden:

1. `@@SERVERNAME` y `DB_NAME()`.
2. Esquema real en `sys.tables` o `sys.views`.
3. Nombre exacto y sensibilidad a mayúsculas según collation.
4. Que el objeto sea tabla, vista o sinónimo.
5. Contexto efectivo de la aplicación, no solo el de SSMS.

### Permiso denegado

No intentar elevar privilegios. Identificar el permiso faltante y pedir al propietario de la base una ruta de acceso de solo lectura.

### Definición cifrada o no visible

Registrar que la definición no está disponible. No inferir su contenido. Usar dependencias, metadatos autorizados y resultados documentados.

### Resultado demasiado grande

Reducir por esquema, objeto, prefijo, fecha, estado o `TOP`. Pedir solo el subconjunto necesario.

### Metadatos contradictorios

Preferir constraints y definiciones ejecutadas sobre convenciones de nombres. Documentar la discrepancia.

## Reglas de comunicación con el usuario

- Explicar qué busca cada bloque antes de entregarlo.
- Entregar una consulta o un grupo pequeño de consultas relacionadas por turno.
- Indicar qué columnas del resultado debe compartir y cuáles puede ocultar.
- Después de recibir resultados, resumir primero lo aprendido y luego proponer el siguiente paso.
- Si el resultado contradice la hipótesis, descartarla explícitamente.
- No repetir consultas ya respondidas salvo que cambien servidor, base o contexto.
- No presentar una inferencia como hecho.

## Criterios de finalización

Considerar la exploración suficiente cuando se pueda responder con evidencia:

- En qué servidor, base y esquema se está trabajando.
- Cuáles son las entidades principales y catálogos.
- Cómo se relacionan las entidades prioritarias.
- Qué restricciones protegen la integridad.
- Qué objetos programables implementan reglas relevantes.
- Qué índices soportan los flujos principales.
- Qué datos y flujos siguen sin comprenderse.
- Qué riesgos deben validarse antes de modificar la base o la aplicación.

No declarar comprensión completa si existen objetos relevantes sin acceso o reglas todavía inferidas.
