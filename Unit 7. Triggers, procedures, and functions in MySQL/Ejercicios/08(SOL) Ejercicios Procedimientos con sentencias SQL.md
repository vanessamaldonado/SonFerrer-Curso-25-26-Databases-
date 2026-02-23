# 07 Ejercicios: Procedimientos con sentencias SQL

## Ejercicio 1
Escribe un procedimiento que reciba el nombre de un país como parámetro de entrada y realice una consulta sobre la tabla cliente para obtener todos los clientes que existen en la tabla de ese país.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE clientes_por_pais(IN p_pais VARCHAR(50))
BEGIN
    SELECT *
    FROM Clientes
    WHERE Pais = p_pais;
END //

DELIMITER ;

CALL clientes_por_pais('España');
CALL clientes_por_pais('USA');
CALL clientes_por_pais('France');
```

</details>

## Ejercicio 2 
Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc). Y devuelva como salida el pago de máximo valor realizado para esa forma de pago. Deberá hacer uso de la tabla pago de la base de datos jardineria.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE max_pago_por_forma(
    IN p_formaPago VARCHAR(40),
    OUT p_maxCantidad DECIMAL(15,2)
)
BEGIN
    SELECT MAX(Cantidad)
      INTO p_maxCantidad
    FROM Pagos
    WHERE FormaPago = p_formaPago;
END //

DELIMITER ;

CALL max_pago_por_forma('PayPal', @maximo);
SELECT @maximo AS max_pago_paypal;

CALL max_pago_por_forma('Transferencia', @maximo);
SELECT @maximo AS max_pago_transferencia;
```

</details>

## Ejercicio 3
Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc). Y devuelva como salida los siguientes valores teniendo en cuenta la forma de pago seleccionada como parámetro de entrada:

- el pago de máximo valor,
- el pago de mínimo valor,
- el valor medio de los pagos realizados,
- la suma de todos los pagos,
- el número de pagos realizados para esa forma de pago.
Deberá hacer uso de la tabla pago de la base de datos jardineria.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS resumen_pagos_por_forma $$
CREATE PROCEDURE resumen_pagos_por_forma(
    IN  p_formaPago VARCHAR(40),
    OUT o_maximo    DECIMAL(15,2),
    OUT o_minimo    DECIMAL(15,2),
    OUT o_media     DECIMAL(15,2),
    OUT o_suma      DECIMAL(15,2),
    OUT o_numPagos  INT
)
BEGIN
    -- Calculamos agregados para la forma de pago indicada
    SELECT
        MAX(total),
        MIN(total),
        AVG(total),
        SUM(total),
        COUNT(*)
    INTO
        o_maximo,
        o_minimo,
        o_media,
        o_suma,
        o_numPagos
    FROM pago
    WHERE formaPago = p_formaPago;

    -- Si no hay pagos, dejamos la suma en 0 (lo demás quedará NULL) y el contador en 0
    IF o_numPagos = 0 THEN
        SET o_suma = 0;
    END IF;
END $$

DELIMITER ;

CALL resumen_pagos_por_forma('PayPal', @max, @min, @avg, @sum, @count);

SELECT
  @max   AS max_pago,
  @min   AS min_pago,
  @avg   AS media_pago,
  @sum   AS suma_pagos,
  @count AS num_pagos;
```
</details>

## Ejercicio 4
Crea una base de datos llamada `procedimientos` que contenga una tabla llamada `cuadrados`. La tabla cuadrados debe tener dos columnas de tipo INT UNSIGNED, una columna llamada `número` y otra columna llamada `cuadrado`.

Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado `calcular_cuadrados` con las siguientes características:
- El procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y calculará el valor de los cuadrados de los primeros números naturales hasta el valor introducido como parámetro. 
- El valor del números y de sus cuadrados deberán ser almacenados en la tabla cuadrados que hemos creado previamente.

Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de la tabla antes de insertar los nuevos valores de los cuadrados que va a calcular.

Utilice un bucle WHILE para resolver el procedimiento.

<details><summary>Mostrar Solución</summary>

```sql
-- 1) Crear base de datos y usarla
CREATE DATABASE IF NOT EXISTS procedimientos;
USE procedimientos;

-- 2) Crear tabla cuadrados
CREATE TABLE IF NOT EXISTS cuadrados (
  numero   INT UNSIGNED NOT NULL,
  cuadrado INT UNSIGNED NOT NULL,
  PRIMARY KEY (numero)
);

-- 3) Crear procedimiento calcular_cuadrados
DELIMITER //

CREATE PROCEDURE calcular_cuadrados(IN tope INT UNSIGNED)
BEGIN
    DECLARE i INT UNSIGNED DEFAULT 1;

    -- Vaciar la tabla antes de insertar los nuevos datos
    TRUNCATE TABLE cuadrados;

    -- Si tope es 0, no insertamos nada (queda vacía)
    WHILE i <= tope DO
        INSERT INTO cuadrados (numero, cuadrado)
        VALUES (i, i * i);

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL calcular_cuadrados(10);
SELECT * FROM cuadrados;
```
</details>

## Ejercicio 5 
Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.

<details><summary>Mostrar Solución</summary>

```sql
USE procedimientos;

DELIMITER //

CREATE PROCEDURE calcular_cuadrados_repeat(IN tope INT UNSIGNED)
BEGIN
    DECLARE i INT UNSIGNED DEFAULT 1;

    -- Vaciar la tabla antes de insertar nuevos valores
    TRUNCATE TABLE cuadrados;

    -- Solo ejecutar si el tope es mayor que 0
    IF tope > 0 THEN
        
        REPEAT
            INSERT INTO cuadrados (numero, cuadrado)
            VALUES (i, i * i);

            SET i = i + 1;

        UNTIL i > tope
        END REPEAT;

    END IF;

END //

DELIMITER ;

CALL calcular_cuadrados_repeat(5);
SELECT * FROM cuadrados;
```

</details>

## Ejercicio 6 
Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.

<details><summary>Mostrar Solución</summary>

```sql
USE procedimientos;

DELIMITER //

CREATE PROCEDURE calcular_cuadrados_loop(IN tope INT UNSIGNED)
BEGIN
    DECLARE i INT UNSIGNED DEFAULT 1;

    -- Vaciar la tabla antes de insertar nuevos valores
    TRUNCATE TABLE cuadrados;

    bucle: LOOP
        -- Condición de salida
        IF i > tope OR tope = 0 THEN
            LEAVE bucle;
        END IF;

        INSERT INTO cuadrados (numero, cuadrado)
        VALUES (i, i * i);

        SET i = i + 1;
    END LOOP bucle;

END //

DELIMITER ;

CALL calcular_cuadrados_loop(10);
SELECT * FROM cuadrados;
```
</details>

## Ejercicio 7 
Crea una base de datos llamada `procedimientos` que contenga una tabla llamada `ejercicio`. La tabla debe tener una única columna llamada `número` y el tipo de dato de esta columna debe ser INT UNSIGNED.

Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado `calcular_números` con las siguientes características:
- El procedimiento recibe un parámetro de entrada llamado `valor_inicial` de tipo INT UNSIGNED y deberá almacenar en la tabla ejercicio toda la secuencia de números desde el valor inicial pasado como entrada hasta el 1.

Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los nuevos valores.

Utilice un bucle WHILE para resolver el procedimiento.

<details><summary>Mostrar Solución</summary>

```sql
-- 1) Crear base de datos y usarla
CREATE DATABASE IF NOT EXISTS procedimientos;
USE procedimientos;

-- 2) Crear tabla ejercicio
CREATE TABLE IF NOT EXISTS ejercicio (
  numero INT UNSIGNED NOT NULL
);

-- 3) Crear procedimiento
DELIMITER //

CREATE PROCEDURE calcular_numeros(IN valor_inicial INT UNSIGNED)
BEGIN
    DECLARE i INT UNSIGNED;

    -- Vaciar la tabla antes de insertar nuevos valores
    TRUNCATE TABLE ejercicio;

    SET i = valor_inicial;

    -- Insertar desde valor_inicial hasta 1
    WHILE i >= 1 DO
        INSERT INTO ejercicio (numero) VALUES (i);
        SET i = i - 1;
    END WHILE;
END //

DELIMITER ;

CALL calcular_numeros(10);
SELECT * FROM ejercicio;
```
</details>


## Ejercicio 8 
Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.

<details><summary>Mostrar Solución</summary>

```sql
USE procedimientos;

DELIMITER //

CREATE PROCEDURE calcular_numeros (IN valor_inicial INT UNSIGNED)
BEGIN
    DECLARE i INT UNSIGNED;

    -- Vaciar la tabla antes de insertar nuevos valores
    TRUNCATE TABLE ejercicio;

    -- Si el valor inicial es 0, no insertamos nada
    IF valor_inicial > 0 THEN
        SET i = valor_inicial;

        REPEAT
            INSERT INTO ejercicio (numero) VALUES (i);
            SET i = i - 1;
        UNTIL i = 0
        END REPEAT;
    END IF;

END //

DELIMITER ;

CALL calcular_numeros(5);
SELECT * FROM ejercicio;
```

</details>

## Ejercicio 9
Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.

<details><summary>Mostrar Solución</summary>

```sql
USE procedimientos;

DELIMITER //

CREATE PROCEDURE calcular_numeros_loop (IN valor_inicial INT UNSIGNED)
BEGIN
    DECLARE i INT UNSIGNED;

    TRUNCATE TABLE ejercicio;
    SET i = valor_inicial;

    bucle: LOOP
        IF i < 1 THEN
            LEAVE bucle;
        END IF;

        INSERT INTO ejercicio (numero) VALUES (i);
        SET i = i - 1;
    END LOOP bucle;

END //

DELIMITER ;

CALL calcular_numeros_loop(5);
SELECT * FROM ejercicio;
```
</details>

## Ejercicio 10
Crea una base de datos llamada `procedimientos` que contenga una tabla llamada `pares` y otra tabla llamada `impares`. Las dos tablas deben tener única columna llamada `número` y el tipo de dato de esta columna debe ser INT UNSIGNED.

Una vez creada la base de datos y las tablas deberá crear un procedimiento llamado `calcular_pares_impares` con las siguientes características:
- El procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y deberá almacenar en la tabla pares aquellos números pares que existan entre el número 1 el valor introducido como parámetro. 
- Habrá que realizar la misma operación para almacenar los números impares en la tabla impares.

Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los nuevos valores.

Utilice un bucle WHILE para resolver el procedimiento.

<details><summary>Mostrar Solución</summary>

```sql
-- 1) Crear base de datos y usarla
CREATE DATABASE IF NOT EXISTS procedimientos;
USE procedimientos;

-- 2) Crear tablas
CREATE TABLE IF NOT EXISTS pares (
  numero INT UNSIGNED NOT NULL,
  PRIMARY KEY (numero)
);

CREATE TABLE IF NOT EXISTS impares (
  numero INT UNSIGNED NOT NULL,
  PRIMARY KEY (numero)
);

-- 3) Procedimiento
DELIMITER //

CREATE PROCEDURE calcular_pares_impares(IN tope INT UNSIGNED)
BEGIN
    DECLARE i INT UNSIGNED DEFAULT 1;

    -- Vaciar tablas antes de insertar
    TRUNCATE TABLE pares;
    TRUNCATE TABLE impares;

    -- Recorremos del 1 al tope
    WHILE i <= tope DO
        IF (i MOD 2) = 0 THEN
            INSERT INTO pares (numero) VALUES (i);
        ELSE
            INSERT INTO impares (numero) VALUES (i);
        END IF;

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL calcular_pares_impares(10);

SELECT * FROM pares;
SELECT * FROM impares;
```
</details>

## Ejercicio 11
Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.

<details><summary>Mostrar Solución</summary>

```sql
USE procedimientos;

DELIMITER //

CREATE PROCEDURE calcular_pares_impares_repeat(IN tope INT UNSIGNED)
BEGIN
    DECLARE i INT UNSIGNED DEFAULT 1;

    -- Vaciar tablas antes de insertar
    TRUNCATE TABLE pares;
    TRUNCATE TABLE impares;

    -- Si tope es 0, no insertamos nada
    IF tope > 0 THEN

        REPEAT
            IF (i MOD 2) = 0 THEN
                INSERT INTO pares (numero) VALUES (i);
            ELSE
                INSERT INTO impares (numero) VALUES (i);
            END IF;

            SET i = i + 1;

        UNTIL i > tope
        END REPEAT;

    END IF;
END //

DELIMITER ;

CALL calcular_pares_impares_repeat(10);

SELECT * FROM pares;
SELECT * FROM impares;
```

</details>

## Ejercicio 12
Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.

<details><summary>Mostrar Solución</summary>

```sql
USE procedimientos;

DELIMITER //

CREATE PROCEDURE calcular_pares_impares_loop(IN tope INT UNSIGNED)
BEGIN
    DECLARE i INT UNSIGNED DEFAULT 1;

    -- Vaciar tablas antes de insertar
    TRUNCATE TABLE pares;
    TRUNCATE TABLE impares;

    bucle: LOOP
        -- condición de salida
        IF i > tope OR tope = 0 THEN
            LEAVE bucle;
        END IF;

        -- insertar en la tabla correspondiente
        IF (i MOD 2) = 0 THEN
            INSERT INTO pares (numero) VALUES (i);
        ELSE
            INSERT INTO impares (numero) VALUES (i);
        END IF;

        SET i = i + 1;
    END LOOP bucle;

END //

DELIMITER ;

CALL calcular_pares_impares_repeat(10);

SELECT * FROM pares;
SELECT * FROM impares;
```
</details>