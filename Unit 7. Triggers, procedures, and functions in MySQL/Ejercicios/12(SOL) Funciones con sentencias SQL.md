# 12 Funciones con sentencias SQL

## Ejercicio 1:
Escribe una función para la base de datos tienda que devuelva el número total de productos que hay en la tabla productos.

<details><summary>Mostrar Solución</summary>
 
 ```sql
 DELIMITER $$

CREATE FUNCTION total_productos()
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE total INT;

  SELECT COUNT(*)
    INTO total
    FROM producto;

  RETURN total;
END$$

DELIMITER ;
```
</details>

## Ejercicio 2:
Escribe una función para la base de datos tienda que devuelva el valor medio del precio de los productos de un determinado fabricante que se recibirá como parámetro de entrada. El parámetro de entrada será el nombre del fabricante.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER $$

CREATE FUNCTION precio_medio_fabricante(p_nombre VARCHAR(100))
RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE media DOUBLE;

  SELECT AVG(p.precio)
    INTO media
    FROM producto p
    JOIN fabricante f ON f.id = p.id_fabricante
   WHERE f.nombre = p_nombre;

  RETURN media;  -- si no existe, devolverá NULL
END$$

DELIMITER ;
```
</details>

## Ejercicio 3:
Escribe una función para la base de datos tienda que devuelva el valor máximo del precio de los productos de un determinado fabricante que se recibirá como parámetro de entrada. El parámetro de entrada será el nombre del fabricante.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER $$

CREATE FUNCTION precio_max_fabricante(p_nombre VARCHAR(100))
RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE maximo DOUBLE;

  SELECT MAX(p.precio)
    INTO maximo
    FROM producto p
    JOIN fabricante f ON f.id = p.id_fabricante
   WHERE f.nombre = p_nombre;

  RETURN maximo; -- si no existe, devolverá NULL
END$$

DELIMITER ;
```
</details>

## Ejercicio 4:
Escribe una función para la base de datos tienda que devuelva el valor mínimo del precio de los productos de un determinado fabricante que se recibirá como parámetro de entrada. El parámetro de entrada será el nombre del fabricante.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER $$

CREATE FUNCTION precio_min_fabricante(p_nombre VARCHAR(100))
RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE minimo DOUBLE;

  SELECT MIN(p.precio)
    INTO minimo
    FROM producto p
    JOIN fabricante f ON f.id = p.id_fabricante
   WHERE f.nombre = p_nombre;

  RETURN minimo; -- si no existe, devolverá NULL
END$$

DELIMITER ;
```
</details>