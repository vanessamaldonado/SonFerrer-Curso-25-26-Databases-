# Procedure (Stored Procedure)

**Qué es:** un “paquete” de SQL con nombre. Lo llamas y ejecuta todo lo de dentro.

**Cuándo usarlo:** cuando quieres hacer varios pasos (INSERT/UPDATE/SELECT) con una sola llamada.

## Sintaxis mínima:

```sql
DELIMITER $$
CREATE PROCEDURE nombre()
BEGIN
  -- instrucciones SQL
END$$
DELIMITER ;
```

## Ejemplo: sumar dos números

```sql
DROP PROCEDURE IF EXISTS pa_sumar;
DELIMITER $$

CREATE PROCEDURE pa_sumar(IN v1 INT, IN v2 INT)
BEGIN
  DECLARE s INT;
  SET s = v1 + v2;
  SELECT s AS suma;
END$$

DELIMITER ;

CALL pa_sumar(4,5);
```

> Procedure puede devolver “cosas” con SELECT o con parámetros OUT.

---

# Function (Función)

**Qué es:** parecida a una procedure, pero siempre devuelve 1 valor con RETURN.

**Cuándo usar:** cuando quieres usarlo dentro de un SELECT como una función normal.

## Sintaxis mínima:

```sql
DELIMITER $$
CREATE FUNCTION nombre(parametros)
RETURNS tipo
DETERMINISTIC
BEGIN
  RETURN valor;
END$$
DELIMITER ;
```

## Ejemplo: precio con IVA

```sql
DROP FUNCTION IF EXISTS precio_con_iva;
DELIMITER $$

CREATE FUNCTION precio_con_iva(p DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN p * 1.21;
END$$

DELIMITER ;

SELECT precio_con_iva(100) AS con_iva;   -- 121.00
```

> Function = “una calculadora” que puedes meter en SELECT.

---

# Trigger (Disparador)

**Qué es:** código que se ejecuta automáticamente cuando pasa algo en una tabla: INSERT, UPDATE, DELETE.

**Cuándo usar:** para “reglas automáticas”: validar datos, ajustar stock, calcular campos, registrar cambios…

## Sintaxis mínima

```sql
DELIMITER $$
CREATE TRIGGER nombre
BEFORE INSERT ON tabla
FOR EACH ROW
BEGIN
  -- instrucciones
END$$
DELIMITER ;
```

> NEW y OLD (lo que más confunde)
>
>    - En INSERT: existe NEW.campo
>    - En UPDATE: existen OLD.campo y NEW.campo
>    - En DELETE: existe OLD.campo

## Ejemplo: nota entre 0 y 10

```sql
DROP TRIGGER IF EXISTS trg_nota;
DELIMITER $$

CREATE TRIGGER trg_nota
BEFORE INSERT ON alumnos
FOR EACH ROW
BEGIN
  IF NEW.nota < 0 THEN
    SET NEW.nota = 0;
  ELSEIF NEW.nota > 10 THEN
    SET NEW.nota = 10;
  END IF;
END$$

DELIMITER ;
```

> Trigger se ejecuta “solo”, tú no lo llamas con CALL.

--- 

# SIGNAL (truco para “prohibir” algo)

**Qué es:** “lanzar un error” a propósito. Sirve para parar un INSERT/UPDATE/DELETE.

**Cuándo usar:** cuando quieres impedir una acción desde un trigger/procedure.

## Sintaxis mínima

```sql
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Tu mensaje';
```

## Ejemplo: no permitir nota NULL

```sql
IF NEW.nota IS NULL THEN
  SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'La nota no puede ser NULL';
END IF;
```
---

# HANDLER (manejar errores dentro de un procedure)

**Qué es:** “si ocurre un error, haz esto” (en vez de que el procedimiento reviente sin control).

**Cuándo usar:** por ejemplo, si insertas y puede haber duplicados (error 1062).

## Sintaxis mínima

```sql
DECLARE CONTINUE HANDLER FOR 1062
BEGIN
  -- qué hacer si pasa ese error
END;
```

- CONTINUE: sigue ejecutando después del error
- EXIT: se sale del procedimiento

## Ejemplo: insertar y marcar error si id repetido

```sql
DROP PROCEDURE IF EXISTS insertar_alumno;
DELIMITER $$

CREATE PROCEDURE insertar_alumno(
  IN  p_id INT,
  IN  p_nombre VARCHAR(50),
  OUT p_error TINYINT
)
BEGIN
  SET p_error = 0;

  DECLARE CONTINUE HANDLER FOR 1062
  BEGIN
    SET p_error = 1;
  END;

  INSERT INTO alumno(id, nombre) VALUES (p_id, p_nombre);
END$$

DELIMITER ;

SET @err = NULL;
CALL insertar_alumno(1,'Ana',@err);
SELECT @err;

CALL insertar_alumno(1,'Ana',@err); -- repetido
SELECT @err;
```

> HANDLER se usa sobre todo en procedures, para controlar errores “esperables”.