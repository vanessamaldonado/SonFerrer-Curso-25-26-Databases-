# Functions

A function is a block of SQL code stored in the database that receives parameters, performs operations, and returns a single value .

Features:
- It always returns a value using RETURN.
- It can receive one or more parameters.
- It can be used directly in consultations SELECT.

## Syntax for creating a function

```sql
DELIMITER $$
CREATE FUNCTION nombre_funcion(parametros)
RETURNS tipo_dato
DETERMINISTIC
BEGIN
  -- lógica de la función
  RETURN valor;
END $$
DELIMITER ;
```

> `DETERMINISTIC` indicates that the function always returns the same result for the same parameters.

---

## Input parameters

In a function, all parameters are inputs; therefore, it will not be necessary to use the reserved word IN before the parameter name.

Example:

The following shows the header of the function contar_productosthat has an input parameter called gama.

```sql
CREATE FUNCTION contar_productos(gama VARCHAR(50))
```

## Output result

A function will always return an output value associated with the function name. In the function header definition, you must define the data type it returns using the `return` keyword, RETURNS and in the function body, you must include the `return` keyword RETURN to return the function's value.

Example:

This example shows an incomplete definition of a function where you can see the use of the reserved words RETURNS and RETURN.

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS contar_productos$$
CREATE FUNCTION contar_productos(gama VARCHAR(50))
  RETURNS INT UNSIGNED
  ...
BEGIN
  ...

  RETURN total;
END
$$
```

## Function characteristics
After defining the data type that the function will return using the reserved word RETURNS, we need to specify the function's characteristics. The available options are as follows:

- **DETERMINISTIC:** Indicates that the function always returns the same result when the same input parameters are used.
- **NOT DETERMINISTIC:** This indicates that the function does not always return the same result, even when using the same input parameters. This is the default option when a feature is not explicitly specified.
- **CONTAINS SQL:** This indicates that the function contains SQL statements, but no data manipulation statements. Some examples of SQL statements that may appear in this case are operations with variables (e.g., SET @x = 1) or the use of MySQL functions (e.g., SELECT NOW();) among others. However, no data writing or reading statements will appear.
- **NO SQL:** Indicates that the function does not contain SQL statements.
- **READS SQL DATA:** Indicates that the function does not modify the database data and that it contains data reading statements, such as the statement SELECT.
- **MODIFIES SQL DATA:** Indicates that the function does modify the database data and contains statements such as INSERT, UPDATEor DELETE.

To create a function in MySQL, you need to specify at least one of these three characteristics:

- DETERMINISTIC
- NO SQL
- READS SQL DATA

If at least one of these characteristics is not specified, we will get the following error message.

```sql
ERROR 1418 (HY000): This function has none of DETERMINISTIC, NO SQL,
or READS SQL DATA in its declaration and binary logging is enabled
(you *might* want to use the less safe log_bin_trust_function_creators
variable)
```

## View existing functions

```sql
SHOW FUNCTION STATUS WHERE Db = 'nombre_base_datos';
```

## Remove a function

```sql 
DROP FUNCTION IF EXISTS precio_con_iva;
```


--- 

## Basic example 1
Write a function called contar_productosthat takes the name of the range as input and returns the number of products that exist within that range.

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS contar_productos$$
CREATE FUNCTION contar_productos(gama VARCHAR(50))
  RETURNS INT UNSIGNED
  READS SQL DATA
BEGIN
  -- Paso 1. Declaramos una variable local
  DECLARE total INT UNSIGNED;

  -- Paso 2. Contamos los productos
  SET total = (
    SELECT COUNT(*) 
    FROM producto 
    WHERE producto.gama = gama);

  -- Paso 3. Devolvemos el resultado
  RETURN total;
END
$$

DELIMITER ;
SELECT contar_productos('Herramientas');
```

## Basic example 2
Function to calculate the price including VAT (21%).

```sql
DELIMITER $$
CREATE FUNCTION precio_con_iva(p_precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN p_precio * 1.21;
END $$
DELIMITER ;
```

Use:

```sql
SELECT name, precio_con_iva(price) AS precio_final FROM products;
```

## Function with conditional logic

```sql
DELIMITER $$
CREATE FUNCTION es_mayor_de_edad(p_edad INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
  IF p_edad >= 18 THEN
    RETURN 'SI';
  ELSE
    RETURN 'NO';
  END IF;
END $$
DELIMITER ;
```

Use:

```sql
SELECT first_name, es_mayor_de_edad(age) AS mayor FROM customers;
```