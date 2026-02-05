# Práctica evaluable: Optimización de consultas y seguridad

La empresa Kardex S.A. gestiona entradas y salidas de productos. Hay 3 perfiles internos (almacén, compras/gerencia y auditoría) y varias consultas se ejecutan de forma repetitiva cada día/mes.
Tu tarea es proponer e implementar:

- Vistas para simplificar informes recurrentes.
- Índices para acelerar consultas reales (y justificar por qué).
- Usuarios, roles y permisos aplicando el principio de mínimo privilegio.

> Importante: no se aceptan soluciones “por intuición”. Debes incluir una breve justificación técnica por cada vista/índice/permiso.


## Parte A — Informes y vistas

**1) Informe mensual de rotación y coste**

Necesidad: cada mes, gerencia pide un informe por producto con:
- cantidad total ENTRADA y SALIDA del mes
- “saldo neto” del mes (entradas − salidas)
- importe total de entradas y salidas (cantidad * precio)
- agrupado por tipo de producto (tabla tipo) y por presentación (tabla presentacion)
- con filtro por rango de fechas (mes)

Tarea:
- Diseñar una o varias vistas que permitan sacar el informe mensual con una consulta simple.

```sql
CREATE OR REPLACE VIEW vw_movimientos_detalle AS
SELECT
  k.codigo,
  k.fecha_ing,
  k.fecha_vence,
  k.tipo AS tipo_mov,         -- ENTRADA / SALIDA
  k.cantidad,
  k.precio,
  (k.cantidad * k.precio) AS importe_linea,
  p.cod_producto,
  p.nombre_producto,
  t.cod_tipo,
  t.nombre_tipo,
  pr.cod_presentacion,
  pr.nombre_presentacion
FROM kardex k
JOIN producto p         ON p.cod_producto = k.cod_producto
JOIN tipo t             ON t.cod_tipo = p.cod_tipo
JOIN presentacion pr    ON pr.cod_presentacion = p.cod_presentacion;
```

**A2) Cuadro diario: stock teórico y alertas**

Necesidad: almacén revisa cada mañana:
- stock teórico actual por producto: entradas acumuladas − salidas acumuladas
- productos con stock <= X (umbral, por ejemplo 2)
- y productos con vencimiento próximo (fecha_vence dentro de los próximos 30 días)

Tarea:
- Proponer una vista que permita:
  - obtener stock por producto y cruzarlo con info del producto (nombre, tipo, presentación)
- Proponer la consulta diaria que usaría almacén para `stock bajo`, se considera stock bajo menor a 2.

```sql
CREATE OR REPLACE VIEW vw_stock_teorico AS
SELECT
  p.cod_producto,
  p.nombre_producto,
  t.nombre_tipo,
  pr.nombre_presentacion,
  (
    (SELECT SUM(k1.cantidad)
     FROM kardex k1
     WHERE k1.cod_producto = p.cod_producto
       AND k1.tipo = 'ENTRADA')
    -
    (SELECT SUM(k2.cantidad)
     FROM kardex k2
     WHERE k2.cod_producto = p.cod_producto
       AND k2.tipo = 'SALIDA')
  ) AS stock_teorico
FROM producto p
JOIN tipo t          ON t.cod_tipo = p.cod_tipo
JOIN presentacion pr ON pr.cod_presentacion = p.cod_presentacion;

-- otra opcion
CREATE OR REPLACE VIEW vw_stock_teorico AS
SELECT
  p.cod_producto,
  p.nombre_producto,
  t.nombre_tipo,
  pr.nombre_presentacion,
  SUM(CASE WHEN k.tipo = 'ENTRADA' THEN k.cantidad ELSE -k.cantidad END) AS stock_teorico
FROM kardex k
JOIN producto p         ON p.cod_producto = k.cod_producto
JOIN tipo t             ON t.cod_tipo = p.cod_tipo
JOIN presentacion pr    ON pr.cod_presentacion = p.cod_presentacion
GROUP BY
  p.cod_producto, p.nombre_producto, t.nombre_tipo, pr.nombre_presentacion;


-- consulta stock bajo
SELECT *
FROM vw_stock_teorico
WHERE stock_teorico <= 2
ORDER BY stock_teorico ASC, nombre_producto;

```

**A3) Vista de auditoría (trazabilidad)**

Necesidad: auditoría necesita ver todas las operaciones con trazabilidad:
- fecha, producto, tipo (ENTRADA/SALIDA), cantidad, precio
- además: tipo de producto y presentación
- y un “importe de línea” (cantidad*precio)

Condición: auditoría no debe ver tablas base directamente, solo una “capa segura” (vistas).

Tarea:
- Diseñar una vista “auditable” que sirva como fuente única.

```sql
CREATE OR REPLACE VIEW vw_auditoria_kardex AS
SELECT
  fecha_ing,
  nombre_producto,
  nombre_tipo,
  nombre_presentacion,
  tipo_mov,
  cantidad,
  precio,
  importe_linea,
  fecha_vence
FROM vw_movimientos_detalle;
```

## Parte B — Rendimiento e índices

**B1) Consulta lenta diaria**

Escenario: cada día a las 18:00 se ejecuta un proceso que extrae movimientos de los últimos N días, filtrando por:
- fecha_ing en rango
- y opcionalmente por cod_producto
- ordenado por fecha_ing

Se quejan de que “a veces tarda mucho” cuando crece el histórico.

Tarea:
- Escribir la consulta que crees que ejecuta ese proceso.
- Proponer uno o más índices que la aceleren.

Justificar por qué el índice elegido ayuda (orden de columnas, selectividad, rango, ORDER BY, etc).

**B2) Informe mensual y agrupaciones**

Escenario: el informe mensual de A1 se usa también para “Top 10 productos por importe de salida” del mes.

Tarea:
- Proponer y crear índices pensando en:
  - filtros por fecha
  - joins con producto/tipo/presentación
  - agrupaciones por producto

Justificar: qué consultas se benefician, y qué impacto puede tener en inserts.

Basta con indicar 1–2 indices, bien razonados.

```sql
-- Índice clave para consultas por rango de fechas + producto + orden
-- Acelera: “movimientos últimos N días”, “informe mensual”, “top 10 por importe”, etc.
CREATE INDEX ix_kardex_fecha_prod_tipo
ON kardex (fecha_ing, cod_producto, tipo);

-- Índice para búsquedas por producto y fecha (si muchas consultas van por producto)
CREATE INDEX ix_kardex_prod_fecha
ON kardex (cod_producto, fecha_ing);

-- (Opcional, para vencimientos)
CREATE INDEX ix_kardex_vence
ON kardex (fecha_vence);

-- consulta
EXPLAIN
SELECT
  k.fecha_ing, k.cod_producto, k.tipo, k.cantidad, k.precio
FROM kardex k
WHERE k.fecha_ing >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
ORDER BY k.fecha_ing;
```

## Parte C — Usuarios, roles y permisos

**C1) Roles**

La empresa define estos roles:
1) rol_almacen
   - Puede insertar movimientos en kardex (entradas y salidas).
   - Puede consultar stock y alertas solo a través de vistas (no tablas base).
   - No puede borrar ni actualizar movimientos históricos.

2) rol_gerencia
   - Puede consultar informes (mensual, top productos, stock) a través de vistas.
   - No puede insertar movimientos.

3) rol_auditoria
   - Acceso solo lectura a la vista de auditoría.
   - Prohibido acceso a tablas base.

Tarea:
- Crear los roles.
- Crear 3 usuarios (uno por rol) y asignarlos.
- Aplicar permisos con mínimo privilegio.
- Incluir consultas de prueba que demuestren:
- lo que sí puede hacer cada usuario
- lo que no puede (y debe fallar)

```sql
-- creación roles
CREATE ROLE IF NOT EXISTS rol_almacen;
CREATE ROLE IF NOT EXISTS rol_gerencia;
CREATE ROLE IF NOT EXISTS rol_auditoria;

-- creación usuarios
CREATE USER IF NOT EXISTS 'u_almacen'@'%' IDENTIFIED BY 'Almacen#2026!';
CREATE USER IF NOT EXISTS 'u_gerencia'@'%' IDENTIFIED BY 'Gerencia#2026!';
CREATE USER IF NOT EXISTS 'u_auditor'@'%' IDENTIFIED BY 'Auditoria#2026!';

-- Permisos por rol: Almacen
GRANT INSERT ON kardex.kardex TO rol_almacen;
GRANT SELECT ON kardex.vw_stock_teorico TO rol_almacen;
GRANT SELECT ON kardex.vw_movimientos_detalle TO rol_almacen; -- útil para vencimientos/consultas operativas

-- Permisos por rol: Gerencia
GRANT SELECT ON kardex.vw_movimientos_detalle TO rol_gerencia;
GRANT SELECT ON kardex.vw_stock_teorico TO rol_gerencia;

-- Permisos por rol: Auditoria
GRANT SELECT ON kardex.vw_auditoria_kardex TO rol_auditoria;
```


## Entregable

Un archivo SQL con:
- creación de vistas
- índices
- roles, usuarios, grants

Una explicación que puede estar incluida en el sql o en un doc aparte con:
- explicación de cada vista (para qué sirve)
- explicación de cada índice (qué consulta acelera y por qué)
- tabla-resumen de permisos por rol