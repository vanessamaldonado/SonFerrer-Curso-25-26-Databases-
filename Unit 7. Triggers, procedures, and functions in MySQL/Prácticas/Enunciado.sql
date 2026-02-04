/* ============================================================
   Práctica evaluable: Optimización de consultas y seguridad
   Tema: Vistas, Indices, Usuarios/Roles/Permisos

   Instrucciones:
   - Lee el enunciado y resuelve cada apartado creando los objetos
     necesarios (vistas, indices, roles, usuarios, permisos).
   - Evita soluciones triviales: se evalua el criterio y la justificacion.
   ============================================================ */

-- ------------------------------------------------------------
-- PARTE A — INFORMES Y VISTAS
-- ------------------------------------------------------------

/*
1) Informe mensual de rotacion y coste

Necesidad: cada mes, gerencia pide un informe por producto con:
- cantidad total ENTRADA y SALIDA del mes
- “saldo neto” del mes (entradas − salidas)
- importe total de entradas y salidas (cantidad * precio)
- agrupado por tipo de producto (tabla tipo) y por presentacion (tabla presentacion)
- con filtro por rango de fechas (mes)

Tarea:
- Disenar una o varias vistas que permitan sacar el informe mensual con una consulta simple.
*/


/*
A2) Cuadro diario: stock teorico y alertas

Necesidad: almacen revisa cada manana:
- stock teorico actual por producto: entradas acumuladas − salidas acumuladas
- productos con stock <= X (umbral, por ejemplo 2)
- y productos con vencimiento proximo (fecha_vence dentro de los proximos 30 dias)

Tarea:
- Proponer una vista que permita:
  - obtener stock por producto y cruzarlo con info del producto (nombre, tipo, presentacion)
- Proponer la consulta diaria que usaria almacen para `stock bajo`,
  se considera stock bajo menor a 2.
*/


/*
A3) Vista de auditoria (trazabilidad)

Necesidad: auditoria necesita ver todas las operaciones con trazabilidad:
- fecha, producto, tipo (ENTRADA/SALIDA), cantidad, precio
- ademas: tipo de producto y presentacion
- y un “importe de linea” (cantidad*precio)

Condicion: auditoria no debe ver tablas base directamente, solo una “capa segura” (vistas).

Tarea:
- Disenar una vista “auditable” que sirva como fuente unica.
*/


-- ------------------------------------------------------------
-- PARTE B — RENDIMIENTO E INDICES
-- ------------------------------------------------------------

/*
B1) Consulta lenta diaria

Escenario: cada dia a las 18:00 se ejecuta un proceso que extrae movimientos de los ultimos N dias, filtrando por:
- fecha_ing en rango
- y opcionalmente por cod_producto
- ordenado por fecha_ing

Se quejan de que “a veces tarda mucho” cuando crece el historico.

Tarea:
- Escribir la consulta que crees que ejecuta ese proceso.
- Proponer uno o mas indices que la aceleren.

Justificar por que el indice elegido ayuda (orden de columnas, selectividad, rango, ORDER BY, etc).
*/


/*
B2) Informe mensual y agrupaciones

Escenario: el informe mensual de A1 se usa tambien para “Top 10 productos por importe de salida” del mes.

Tarea:
- Proponer y crear indices pensando en:
  - filtros por fecha
  - joins con producto/tipo/presentacion
  - agrupaciones por producto

Justificar: que consultas se benefician, y que impacto puede tener en inserts.

Basta con indicar 1–2 indices, bien razonados.
*/


-- ------------------------------------------------------------
-- PARTE C — USUARIOS, ROLES Y PERMISOS
-- ------------------------------------------------------------

/*
C1) Roles

La empresa define estos roles:
1) rol_almacen
   - Puede insertar movimientos en kardex (entradas y salidas).
   - Puede consultar stock y alertas solo a traves de vistas (no tablas base).
   - No puede borrar ni actualizar movimientos historicos.

2) rol_gerencia
   - Puede consultar informes (mensual, top productos, stock) a traves de vistas.
   - No puede insertar movimientos.

3) rol_auditoria
   - Acceso solo lectura a la vista de auditoria.
   - Prohibido acceso a tablas base.

Tarea:
- Crear los roles.
- Crear 3 usuarios (uno por rol) y asignarlos.
- Aplicar permisos con minimo privilegio.
- Incluir consultas de prueba que demuestren:
  - lo que si puede hacer cada usuario
  - lo que no puede (y debe fallar)
*/
