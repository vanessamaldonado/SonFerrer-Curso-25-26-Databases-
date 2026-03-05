# Ejercicios de Triggers

Usaremos la base de datos `compraventa`. 

## Ejercicio 1: 

Crear una tabla llamada CambioPrecios con los siguientes campos:
- NombreProducto varchar(50)
- PrecioAnterior decimal(14,4)
- PrecioActual decimal(14,4)

Crear un trigger que, cada vez que se modifique el precio de un producto, inserte una fila en `CambioPrecios` con los datos correspondientes al producto modificado.

El trigger no debe hacer nada cuando se modifique cualquier otro campo de la tabla Productos.

<details><summary>Mostrar Solución</summary>

```sql
USE compraventa;

-- 1) Tabla de auditoría
DROP TABLE IF EXISTS cambio_precios;
CREATE TABLE cambio_precios (
  id_cambio        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_producto      INT(11) NOT NULL,
  nombre_producto  VARCHAR(50) NOT NULL,
  precio_anterior  DECIMAL(14,4),
  precio_actual    DECIMAL(14,4),
  fecha_cambio     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_cambio),
  KEY idx_cambio_precios_producto (id_producto),
  CONSTRAINT fk_cambio_precios_producto
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- 2) Trigger: registra SOLO si cambia el precio_unidad
DROP TRIGGER IF EXISTS trg_productos_cambio_precio;

DELIMITER $$

CREATE TRIGGER trg_productos_cambio_precio
BEFORE UPDATE ON productos
FOR EACH ROW
BEGIN
  -- Si el precio antiguo y el nuevo NO son iguales (considerando también NULL), entonces registra el cambio.
  IF NOT (OLD.precio_unidad <=> NEW.precio_unidad) THEN
    INSERT INTO cambio_precios (
      id_producto,
      nombre_producto,
      precio_anterior,
      precio_actual
    )
    VALUES (
      OLD.id_producto,
      OLD.nombre_producto,
      OLD.precio_unidad,
      NEW.precio_unidad
    );
  END IF;
END$$

DELIMITER ;
```
</details>

## Ejercicio 2.
Crea un trigger que cada vez que se de alta un nuevo empleado, almacene en el campo FechaContratación la fecha actual.

<details><summary>Mostrar Solución</summary>

```sql
USE compraventa;

DROP TRIGGER IF EXISTS trg_empleados_set_fecha_contrat;

DELIMITER $$

CREATE TRIGGER trg_empleados_set_fecha_contrat
BEFORE INSERT ON empleados
FOR EACH ROW
BEGIN
  -- Si no mandan fecha, la ponemos automáticamente
  IF NEW.fecha_contrat IS NULL THEN
    SET NEW.fecha_contrat = NOW();
  END IF;
END$$

DELIMITER ;

-- prueba --- 
-- Inserta sin fecha -> el trigger pone NOW()
INSERT INTO empleados (id_empleado, apellido, nombre)
VALUES (9999, 'Prueba', 'Auto');

SELECT id_empleado, apellido, nombre, fecha_contrat
FROM empleados
WHERE id_empleado = 9999;

-- Inserta con fecha -> respeta la que envías
INSERT INTO empleados (id_empleado, apellido, nombre, fecha_contrat)
VALUES (9998, 'Prueba', 'Manual', '2024-01-01 10:00:00');
```
</details>

## Ejercicio 3.
Crear un trigger que, cada vez que se de de alta un nuevo pedido, almacene en los campos correspondientes al destinatario los datos del cliente que efectúa el pedido.

<details><summary>Mostrar Solución</summary>

```sql
USE compraventa;

DROP TRIGGER IF EXISTS trg_pedidos_copiar_datos_cliente;

DELIMITER $$

CREATE TRIGGER trg_pedidos_copiar_datos_cliente
BEFORE INSERT ON pedidos
FOR EACH ROW
BEGIN
  DECLARE v_nombre_compania VARCHAR(40);
  DECLARE v_direccion       VARCHAR(60);
  DECLARE v_ciudad          VARCHAR(15);
  DECLARE v_region          VARCHAR(15);
  DECLARE v_cod_postal      VARCHAR(10);
  DECLARE v_pais            VARCHAR(15);

  -- Tomamos los datos del cliente que hace el pedido
  SELECT
    nombre_compania,
    direccion,
    ciudad,
    region,
    cod_postal,
    pais
  INTO
    v_nombre_compania,
    v_direccion,
    v_ciudad,
    v_region,
    v_cod_postal,
    v_pais
  FROM clientes
  WHERE id_cliente = NEW.id_cliente;

  -- Rellenar campos del destinatario SOLO si vienen vacíos / NULL
  IF NEW.destinatario IS NULL OR NEW.destinatario = '' THEN
    SET NEW.destinatario = v_nombre_compania;
  END IF;

  IF NEW.direccion_destinatario IS NULL OR NEW.direccion_destinatario = '' THEN
    SET NEW.direccion_destinatario = v_direccion;
  END IF;

  IF NEW.ciudad_destinatario IS NULL OR NEW.ciudad_destinatario = '' THEN
    SET NEW.ciudad_destinatario = v_ciudad;
  END IF;

  IF NEW.region_destinatario IS NULL OR NEW.region_destinatario = '' THEN
    SET NEW.region_destinatario = v_region;
  END IF;

  IF NEW.cod_postal_destinatario IS NULL OR NEW.cod_postal_destinatario = '' THEN
    SET NEW.cod_postal_destinatario = v_cod_postal;
  END IF;

  IF NEW.pais_destinatario IS NULL OR NEW.pais_destinatario = '' THEN
    SET NEW.pais_destinatario = v_pais;
  END IF;
END$$

DELIMITER ;
```
</details>

## Ejercicio 4:
Crear un trigger asociado a la tabla PRODUCTOS para evitar que haya dos productos con el  mismo nombre.
Para ello, si al dar de alta un producto su nombre coincide con otro ya existente deberá poner ese campo a null.

<details><summary>Mostrar Solución</summary>

```sql
USE compraventa;

-- 1) Permitir NULL en nombre_producto (si está NOT NULL)
ALTER TABLE productos
  MODIFY nombre_producto VARCHAR(50) NULL;

-- 2) Trigger: si el nombre ya existe, lo pone a NULL
DROP TRIGGER IF EXISTS trg_productos_evitar_nombre_duplicado;

DELIMITER $$

CREATE TRIGGER trg_productos_evitar_nombre_duplicado
BEFORE INSERT ON productos
FOR EACH ROW
BEGIN
  IF NEW.nombre_producto IS NOT NULL AND NEW.nombre_producto <> '' THEN
    IF EXISTS (
      SELECT 1
      FROM productos
      WHERE nombre_producto = NEW.nombre_producto
      LIMIT 1
    ) THEN
      SET NEW.nombre_producto = NULL;
    END IF;
  END IF;
END$$

DELIMITER ;

-- prueba
-- Suponiendo que ya existe un producto llamado 'Café'
INSERT INTO productos (id_producto, nombre_producto, id_proveedor, id_categoria)
VALUES (5001, 'Café', 1, 1);

-- Intento insertar otro 'Café' -> trigger lo pone NULL
INSERT INTO productos (id_producto, nombre_producto, id_proveedor, id_categoria)
VALUES (5002, 'Café', 1, 1);

SELECT id_producto, nombre_producto
FROM productos
WHERE id_producto IN (5001, 5002);
```
</details>

## Ejercicio 5:
Crear un trigger que impida que se pueda dar de alta a un empleado sin asignarle como jefe a alguno de los empleados que ya son jefes.

Hay que tener en cuenta que en MySQL no es posible deshacer una acción desde un trigger, por lo que habrá que buscar algún "truco".

<details><summary>Mostrar Solución</summary>

```sql
DROP TRIGGER IF EXISTS trg_empleado_debe_tener_jefe_jefe;

DELIMITER $$

CREATE TRIGGER trg_empleado_debe_tener_jefe_jefe
BEFORE INSERT ON empleados
FOR EACH ROW
BEGIN
  DECLARE v_es_jefe INT;

  -- 1) Obligatorio indicar jefe (no vale NULL)
  IF NEW.jefe IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Debes asignar un jefe (no puede ser NULL).';
  END IF;

  -- 2) El jefe indicado debe ser "jefe de alguien" ya en la tabla
  SELECT COUNT(*)
    INTO v_es_jefe
  FROM empleados
  WHERE id_empleado = NEW.jefe
    AND id_empleado IN (SELECT DISTINCT jefe FROM empleados WHERE jefe IS NOT NULL);

  IF v_es_jefe = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El jefe asignado no es un jefe válido (no dirige a nadie).';
  END IF;

END$$

DELIMITER ;

SELECT DISTINCT jefe
FROM empleados
WHERE jefe IS NOT NULL;

INSERT INTO empleados (id_empleado, apellido, nombre, jefe)
VALUES (10, 'Prueba', 'SinJefe', NULL);

INSERT INTO empleados (id_empleado, apellido, nombre, jefe)
VALUES (11, 'Prueba', 'JefeNoJefe', 2);

INSERT INTO empleados (id_empleado, apellido, nombre, jefe)
VALUES (12, 'Prueba', 'Correcto', 1);
```
</details>

## Ejercicio 6:
Crear un trigger que, al dar de alta un detalle de pedido haga lo siguiente:

- a) Disminuya las unidades en existencia del producto en la cantidad pedida.

Si la cantidad pedida es mayor que las existencias deberá cambiar el valor de la cantidad por las existencias y dejar éstas a 0.

ej, Si las existencias de un producto son 20 y la cantidad pedida 30, deberá dejar las existencias a 0 y almacenar un 20 en la cantidad pedida. 

- b) Almacene el precio unitario del producto en el precio unitario de la fila insertada.

- c) Si Preciounidad * Cantidad es mayor o igual a 500,  almacene el valor 0.10 en Descuento; si es menor que 500 pero mayor o igual a 100, el 0.05 y si es menor que 100 el 0.

<details><summary>Mostrar Solución</summary>

```sql
DROP TRIGGER IF EXISTS trg_detalle_stock_precio_descuento;

DELIMITER $$

CREATE TRIGGER trg_detalle_stock_precio_descuento
BEFORE INSERT ON detalles_pedidos
FOR EACH ROW
BEGIN
  DECLARE v_stock INT;
  DECLARE v_precio DECIMAL(14,4);
  DECLARE v_total DECIMAL(18,2);

  -- 1) Leer existencias y precio del producto
  SELECT unidades_en_existencia, precio_unidad
    INTO v_stock, v_precio
  FROM productos
  WHERE id_producto = NEW.id_producto;

  -- 2) (b) Poner el precio del producto en el detalle
  SET NEW.precio_unidad = v_precio;

  -- 3) (a) Ajustar cantidad si pide más que el stock
  IF NEW.cantidad > v_stock THEN
    SET NEW.cantidad = v_stock;     -- se queda con lo que hay
    SET v_stock = 0;                -- y el stock pasa a 0
  ELSE
    SET v_stock = v_stock - NEW.cantidad;
  END IF;

  -- Guardar el stock actualizado
  UPDATE productos
  SET unidades_en_existencia = v_stock
  WHERE id_producto = NEW.id_producto;

  -- 4) (c) Calcular total y poner descuento
  SET v_total = NEW.precio_unidad * NEW.cantidad;

  IF v_total >= 500 THEN
    SET NEW.descuento = 0.10;
  ELSEIF v_total >= 100 THEN
    SET NEW.descuento = 0.05;
  ELSE
    SET NEW.descuento = 0.00;
  END IF;

END$$

DELIMITER ;

SELECT id_producto, unidades_en_existencia, precio_unidad
FROM productos
WHERE id_producto = 1;

INSERT INTO detalles_pedidos (id_pedido, id_producto, precio_unidad, cantidad, descuento)
VALUES (1002, 1, 0, 999, 0);

-- El detalle debe guardar cantidad = existencias antiguas y precio del producto
SELECT * FROM detalles_pedidos WHERE id_pedido = 1002 AND id_producto = 1;

-- El stock debe quedar en 0
SELECT id_producto, unidades_en_existencia FROM productos WHERE id_producto = 1;

INSERT INTO detalles_pedidos (id_pedido, id_producto, precio_unidad, cantidad, descuento)
VALUES (1001, 3, 0, 10, 0);

SELECT * FROM detalles_pedidos WHERE id_pedido = 1001 AND id_producto = 3;
```
</details>

## Ejercicio 7:
Crear una tabla VentasEmpleados con los siguientes campos:
- IdEmpleado (Clave Primaria)
- TotalVentas

Crear un trigger de manera que, cada vez que se de de alta un nuevo pedido, con uno o más detalles de pedidos, si el empleado que consiguió el pedido no existía de VentasEmpleados, deberá insertar una nueva fila con el identificador del empleado y el valor del pedido (con descuentos) en el campo TotalVentas.

Si el empleado ya existía en VentasEmpleados deberá sumar a TotalVentas el valor del pedido (con descuentos). 

<details><summary>Mostrar Solución</summary>

```sql
USE compraventa;

-- Tabla
DROP TABLE IF EXISTS VentasEmpleados;
CREATE TABLE VentasEmpleados (
  IdEmpleado  INT(11) NOT NULL,
  TotalVentas DECIMAL(18,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (IdEmpleado)
);

-- Trigger
DROP TRIGGER IF EXISTS trg_ventas_empleados;

DELIMITER $$

CREATE TRIGGER trg_ventas_empleados
AFTER INSERT ON detalles_pedidos
FOR EACH ROW
BEGIN
  DECLARE v_id_empleado INT;
  DECLARE v_total_linea DECIMAL(18,2);
  DECLARE v_existe INT;

  -- 1) Sacar el empleado del pedido
  SELECT id_empleado
    INTO v_id_empleado
  FROM pedidos
  WHERE id_pedido = NEW.id_pedido;

  -- 2) Calcular el valor del detalle con descuento
 SET v_total_linea = NEW.precio_unidad * NEW.cantidad;
 SET v_total_linea = v_total_linea - (v_total_linea * NEW.descuento);

  -- 3) Mirar si el empleado ya existe en VentasEmpleados
  SELECT COUNT(*)
    INTO v_existe
  FROM VentasEmpleados
  WHERE IdEmpleado = v_id_empleado;

  -- 4) Si NO existe -> INSERT, si existe -> UPDATE sumando
  IF v_existe = 0 THEN
    INSERT INTO VentasEmpleados (IdEmpleado, TotalVentas)
    VALUES (v_id_empleado, v_total_linea);
  ELSE
    UPDATE VentasEmpleados
    SET TotalVentas = TotalVentas + v_total_linea
    WHERE IdEmpleado = v_id_empleado;
  END IF;

END$$

DELIMITER ;


SELECT * FROM VentasEmpleados; -- debe estar vacia

-- Insertamos un pedido nuevo. Usamos un pedido nuevo 2000 para no chocar con los que ya existen.
-- aquí todavía NO se dispara el trigger (porque el trigger está en detalles_pedidos).
INSERT INTO pedidos (
  id_pedido, id_cliente, id_empleado, fecha_pedido, fecha_entrega, fecha_envio,
  id_compania_envio, portes, destinatario, direccion_destinatario, ciudad_destinatario,
  region_destinatario, cod_postal_destinatario, pais_destinatario
) VALUES
(2000, 'ALFKI', 2, '2026-03-05 10:00:00', '2026-03-12 00:00:00', '2026-03-06 12:00:00',
 1, 10.0000, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', 'Berlin', '12209', 'Alemania');
 
 -- Insertamos 1 detalle 
 INSERT INTO detalles_pedidos (id_pedido, id_producto, precio_unidad, cantidad, descuento)
VALUES (2000, 2, 1.20, 10, 0.00);

-- Comprobamos que se crea el empleado en VentasEmpleados
SELECT * FROM VentasEmpleados WHERE IdEmpleado = 2;

-- Insertamos otro detalle del mismo pedido 
INSERT INTO detalles_pedidos (id_pedido, id_producto, precio_unidad, cantidad, descuento)
VALUES (2000, 1, 6.50, 2, 0.10);

-- comprobamos que esta vez suma
SELECT * FROM VentasEmpleados WHERE IdEmpleado = 2;
```
</details>

## Ejercicio 8:
Crear un trigger que, si se pretende dar de alta a un producto con un id de proveedor no existente, de previamente de alta a dicho proveedor (con el id indicado y el resto de campos a null).

<details><summary>Mostrar Solución</summary>

```sql
DROP TRIGGER IF EXISTS trg_crear_proveedor_si_no_existe;

DELIMITER $$

CREATE TRIGGER trg_crear_proveedor_si_no_existe
BEFORE INSERT ON productos
FOR EACH ROW
BEGIN
  DECLARE v_existe INT;

  -- ¿Existe el proveedor?
  SELECT COUNT(*)
    INTO v_existe
  FROM proveedores
  WHERE id_proveedor = NEW.id_proveedor;

  -- Si no existe, lo creo “en blanco”
  IF v_existe = 0 THEN
    INSERT INTO proveedores (id_proveedor, nombre_compania)
    VALUES (NEW.id_proveedor, 'PENDIENTE');
  END IF;

END$$

DELIMITER ;

-- Insertamos un producto con un proveedor inventado:
INSERT INTO productos (
  id_producto, nombre_producto, id_proveedor, id_categoria,
  cantidad_por_unidad, precio_unidad, unidades_en_existencia,
  unidades_en_pedido, nivel_nuevo_pedido, suspendido
) VALUES
(999, 'Producto prueba', 99, 1, '1 ud', 2.50, 10, 0, 5, 0);

SELECT * FROM proveedores WHERE id_proveedor = 99;
SELECT * FROM productos   WHERE id_producto = 999;
```
</details>