# DECLARE … HANDLER

When a condition arises during the execution of a stored procedure, you should handle it properly, such as exiting or continuing the current code block.

To handle a condition, you declare a handler using the `DECLARE ... HANDLER` statement.

Handlers are declared after variables. Here is the basic syntax of the DECLARE...HANDLER statement:

```sql
DECLARE { EXIT | CONTINUE } HANDLER
    FOR condition_value [, condition_value] ...
    statement
```

In this syntax:

- **DECLARE { EXIT | CONTINUE } HANDLER:** This declares a handler, instructing whether it should exit or continue the enclosing stored procedure when a specified condition occurs.
  - `EXIT`: The stored procedure will terminate.
  - `CONTINUE`: The stored procedure will continue execution.
- **FOR condition_value [, condition_value] ...:** This specifies the conditions that activate the handler, and you can specify multiple conditions by separating them with commas.
- **statement:** This statement or block of statements executes when the stored procedure encounters one of the specified conditions.

The condition_value can be one of the following:

- **mysql_error_code** – This is an integer indicating a MySQL error code such as 1051.
- **SQLWARNING** – This is a shorthand for the class of SQLSTATE values that begin with '01'.
- **NOT FOUND** – This is a shorthand for the class of SQLSTATE values that begin with '02'.
- **SQLEXCEPTION** – This is a shorthand for the class of SQLSTATE values that do not begin with '00', '01', or '02'.
- **SQLSTATE [VALUE] sqlstate_value** – This is a string that indicates an SQLSTATE value, such as '42S01' means “Unknown table”.

**SQLSTATE** is a five-character that provides information about the result of an SQL operation. An SQLSTATE consists of two parts:

- Class Code (First two characters): Indicates the general category of the error.
- Subclass Code (Next three characters): Provides more specific information about the error within the general category.

For example, a SQLSTATE code of ’42S02′ indicates a missing table, where ’42’ is the class code for syntax error or access rule violation, and ‘S02’ is the subclass code indicating that the table is not found.

## MySQL DECLARE … HANDLER example

First, create a table called users:

```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(50) NOT NULL
);
```

Second, define a stored procedure that inserts a new user into the users table:

```sql
DELIMITER //

CREATE PROCEDURE insert_user(
	IN p_username VARCHAR(50), 
    IN p_email VARCHAR(50)
)
BEGIN
  -- SQLSTATE for unique constraint violation
  DECLARE EXIT HANDLER FOR SQLSTATE '23000'
  BEGIN
    -- Handler actions when a duplicate username is detected
    SELECT 'Error: Duplicate username. Please choose a different username.' AS Message;
  END;

  -- Attempt to insert the user into the table
  INSERT INTO users (username, email) VALUES (p_username, p_email);

  -- If the insertion was successful, display a success message
  SELECT 'User inserted successfully' AS Message;

END //

DELIMITER ;
```

**How it works.**

The insert_user() stored procedure accepts two parameters username and email.

In the stored procedure, declare an exit handler that is activated when a unique constraint violation occurs, which is indicated by the SQLSTATE ‘23000’:

```sql
DECLARE EXIT HANDLER FOR SQLSTATE '23000'
```

When the error occurs, the stored procedure returns the following message and terminates the execution immediately:

```sql
SELECT 'Error: Duplicate username. Please choose a different username.' AS Message;
```

Insert a new row into the users table, if a unique constraint violation occurs, the code within the BEGIN ... END block of the handler will execute:

```sql
INSERT INTO users (username, email) VALUES (p_username, p_email);
```

If the insert succeeds, the following line of code will execute:

```sql
SELECT 'User inserted successfully' AS Message;
```

Third, insert a new row into the users table by calling the insert_user stored procedure:

```sql
CALL insert_user('jane','jane@example.com');
```

It returns the following message:

```sql
+----------------------------+
| Message                    |
+----------------------------+
| User inserted successfully |
+----------------------------+
1 row in set (0.01 sec)

Query OK, 0 rows affected (0.01 sec)
```

If you execute the statement again, it’ll return the following error:

```sql
+----------------------------------------------------------------+
| Message                                                        |
+----------------------------------------------------------------+
| Error: Duplicate username. Please choose a different username. |
+----------------------------------------------------------------+
1 row in set (0.00 sec)

Query OK, 0 rows affected (0.01 sec)
```

## Ejercicio
Crea una base de datos llamada test que contenga una tabla llamada alumno. La tabla debe tener cuatro columnas:
  - id: entero sin signo (clave primaria).
  - nombre: cadena de 50 caracteres.
  - apellido1: cadena de 50 caracteres.
  - apellido2: cadena de 50 caracteres.

Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado insertar_alumno con las siguientes características. El procedimiento recibe cuatro parámetros de entrada (id, nombre, apellido1, apellido2) y los insertará en la tabla alumno. El procedimiento devolverá como salida un parámetro llamado error que tendrá un valor igual a 0 si la operación se ha podido realizar con éxito y un valor igual a 1 en caso contrario.

Deberá manejar los errores que puedan ocurrir cuando se intenta insertar una fila que contiene una clave primaria repetida.

<details><summary>Mostrar Solución</summary>

```sql
-- 1) Crear base de datos y usarla
CREATE DATABASE IF NOT EXISTS test;

USE test;

-- 2) Crear tabla alumno
DROP TABLE IF EXISTS alumno;
CREATE TABLE alumno (
  id        INT UNSIGNED NOT NULL,
  nombre    VARCHAR(50)  NOT NULL,
  apellido1 VARCHAR(50)  NOT NULL,
  apellido2 VARCHAR(50)  NOT NULL,
  PRIMARY KEY (id)
);

-- 3) Crear procedimiento con control de error por PK duplicada
DROP PROCEDURE IF EXISTS insertar_alumno;
DELIMITER $$

CREATE PROCEDURE insertar_alumno(
  IN  p_id        INT UNSIGNED,
  IN  p_nombre    VARCHAR(50),
  IN  p_apellido1 VARCHAR(50),
  IN  p_apellido2 VARCHAR(50),
  OUT p_error     TINYINT
)
BEGIN
  -- Valor por defecto: OK
  SET p_error = 0;

  -- Si hay clave primaria duplicada (MySQL error 1062), marcamos error=1
  DECLARE CONTINUE HANDLER FOR 1062
  BEGIN
    SET p_error = 1;
  END;

  INSERT INTO alumno (id, nombre, apellido1, apellido2)
  VALUES (p_id, p_nombre, p_apellido1, p_apellido2);
END$$

DELIMITER ;

-- 4) Pruebas rápidas
SET @err = NULL;

CALL insertar_alumno(1, 'Ana', 'García', 'López', @err);
SELECT @err AS error_primera_insercion;  -- debería ser 0

CALL insertar_alumno(1, 'Ana', 'García', 'López', @err);
SELECT @err AS error_segunda_insercion;  -- debería ser 1 (id repetido)

SELECT * FROM alumno;
```
</details>

--- 

## Declaring exceptions. DECLARE CONDITION
In MySQL, DECLARE CONDITION it is used with in stored procedures to define a custom condition that can then be handled DECLARE ... HANDLER with.

```sql
DECLARE nombre_condicion CONDITION FOR valor_condicion;
```

- nombre_condicion→ Name you assign to the condition.
- valor_condicion→ Can be:
    - A SQLSTATE (e.g. '23000')
    - A MySQL error code (e.g. 1062)

> Can only be used within a BEGIN ... END procedure, function, or trigger.

**Example with exception handling** 
Suppose we want to capture the duplicate key error (error 1062).

```sql
DELIMITER //

CREATE PROCEDURE insertar_usuario(
    IN p_id INT,
    IN p_nombre VARCHAR(50)
)
BEGIN
    -- Declarar condición
    DECLARE duplicado CONDITION FOR 1062;

    -- Declarar handler para esa condición
    DECLARE CONTINUE HANDLER FOR duplicado
      SELECT 'Error: ID duplicado' AS mensaje;

    -- Intentar inserción
    INSERT INTO usuarios(id, nombre)
    VALUES(p_id, p_nombre);

END //

DELIMITER ;
```
**What's happening here?**

DECLARE duplicado CONDITION FOR 1062;

	→ Associate the name duplicadowith error 1062 (Duplicate entry) .

DECLARE CONTINUE HANDLER FOR duplicado

	→ If that error occurs, execute the SELECTand the procedure continues.
---

## SIGNAL ruling

The SIGNAL statement is used to transmit an error or warning condition. It results in an error or warning being returned by specifying the SQLSTATE, along with the optional message text.

**Syntax**

```sql
SIGNAL SQLSTATE 'valor_sqlstate'
    SET condition_information_item = value,
        condition_information_item = value, ...;
```

- SQLSTATE 'valor'→ Error code (5-character string).
- SET→ Allows you to define error details such as:
  - MESSAGE_TEXT→ Personalized message.
  - MYSQL_ERRNO→ Numerical error code.
  - CONSTRAINT_NAME, TABLE_NAME, etc.

## Basic Example:

```sql
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Error personalizado';
```
> `45000`is a generic code for user-defined errors.
