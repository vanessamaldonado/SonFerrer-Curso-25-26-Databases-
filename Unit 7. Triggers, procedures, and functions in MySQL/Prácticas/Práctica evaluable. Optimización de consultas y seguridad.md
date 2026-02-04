# Práctica evaluable: Optimización de consultas y seguridad

La empresa Kardex S.A. gestiona entradas y salidas de productos. Hay 3 perfiles internos (almacén, compras/gerencia y auditoría) y varias consultas se ejecutan de forma repetitiva cada día/mes.
Tu tarea es proponer e implementar:

- Vistas para simplificar informes recurrentes.
- Índices para acelerar consultas reales (y justificar por qué).
- Usuarios, roles y permisos aplicando el principio de mínimo privilegio.

> Importante: no se aceptan soluciones “por intuición”. Debes incluir una breve justificación técnica por cada vista/índice/permiso.


[Descargar enunciado SQL](Enunciado.sql)

[Descargar la BD Kardex](kardexDB.sql)


## Entregable

Un archivo SQL con:
- creación de vistas
- índices
- roles, usuarios, grants

Una explicación que puede estar incluida en el sql o en un doc aparte con:
- explicación de cada vista (para qué sirve)
- explicación de cada índice (qué consulta acelera y por qué)
- tabla-resumen de permisos por rol