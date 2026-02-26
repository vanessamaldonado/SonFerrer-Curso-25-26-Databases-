# Triggers

A trigger is a database object that is associated with a table and is activated when an event occurs on the table.

The events that can occur on the table are:

- INSERT: The trigger is activated when a new row is inserted into the associated table.
- UPDATE: The trigger is activated when a row is updated on the associated table.
- DELETE: The trigger is activated when a row is deleted from the associated table.

The uses we can give to a trigger are:
- Monitor and record operations on the tables (we can save information about who made a modification and when).
- Verify that the data is correct before adding it or using it for a modification.
- A mechanism to implement calculated columns (for example, the ATTRACTIONS table has a 'earnings' column and we have the ATTRACTION_DAY table, where we store the earnings per day. The earnings column of the ATTRACTIONS table, for each attraction, should be the sum of the earnings of all the days on which that attraction was held).
- Back up your data before it is modified or deleted.

## Create Triggers

The SQL command that creates a trigger is CREATE TRIGGER:

```sql
CREATE TRIGGER trigger_name -- Defines the name of the trigger and starts its creation.
    trigger_time: { BEFORE | AFTER } -- Indicates when the trigger runs.
    trigger_event: { INSERT | UPDATE | DELETE } -- Specifies the event that activates the trigger.
    ON tbl_name -- Specifies the event that activates the trigger.
    FOR EACH ROW  --Indicates that the trigger executes once for every affected row.
```

**Ejemplo:**

```sql
DELIMITER $$

CREATE TRIGGER log_delete
AFTER DELETE ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO usuarios_eliminados(id, nombre)
    VALUES (OLD.id, OLD.nombre);
END$$

DELIMITER ;
```
You must use the DELIMITER command just as with stored procedures, if you create them from a query execution window.

## View triggers
The SQL command to view the triggers associated with a database or table is SHOW TRIGGERS.

```sql 
SHOW TRIGGERS FROM db_name;
```

## Modify triggers
Modifying triggers is **NOT possible:** you need to delete and recreate the trigger.

## Delete triggers
The SQL command to delete a trigger is DROP TRIGGER.

```sql
DROP TRIGGER IF EXISTS nombre_trigger;
```

--- 

## Exemple:

Create a database called testthat contains a table called alumnos with the following columns:

Board alumnos:
- id(unsigned integer)
- nombre(string of characters)
- apellido1(string of characters)
- apellido2(string of characters)
- nota(real number)

<details><summary>Click me to see the solution</summary>

```sql
DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
USE test;

CREATE TABLE alumnos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50), 
    nota FLOAT
);
```
</details>

Once the table is created, write two triggers with the following characteristics:

- Trigger 1:`trigger_check_nota_before_insert`
  - It is executed on the table alumnos.
  - It is executed before an insertion operation .
  - If the new value of the note to be inserted is negative, it is saved as 0.
  - If the new value of the grade to be inserted is greater than 10, it is saved as 10.

- Trigger 2: `trigger_check_nota_before_update`
  - It is executed on the table alumnos.
  - It is executed before an update operation .
  - If the new value of the grade to be updated is negative, it is saved as 0.
  - If the new value of the grade to be updated is greater than 10, it is saved as 10.
  
<details><summary>Click me to see the solution</summary>

```sql
USE test;


DROP TRIGGER IF EXISTS trigger_check_nota_before_insert;

DELIMITER $$
CREATE TRIGGER trigger_check_nota_before_insert
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

DROP TRIGGER IF EXISTS trigger_check_nota_before_update;

DELIMITER $$
CREATE TRIGGER trigger_check_nota_before_update
BEFORE UPDATE ON alumnos
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
</details>

> Within a trigger BEFORE INSERT,BEFORE UPDATE it `NEW` is an alias that represents the row to be inserted or updated.

Once the triggers are created, write several insert and update statements on the table alumnos and verify that the triggers are executing correctly.

<details><summary>Click me to see the solution</summary>

```sql
DELIMITER ;
INSERT INTO alumnos VALUES (1, 'Pepe', 'López', 'López', -1);
INSERT INTO alumnos VALUES (2, 'María', 'Sánchez', 'Sánchez', 11);
INSERT INTO alumnos VALUES (3, 'Juan', 'Pérez', 'Pérez', 8.5);

SELECT * FROM alumnos;

UPDATE alumnos SET nota = -4 WHERE id = 3;
UPDATE alumnos SET nota = 14 WHERE id = 3;
UPDATE alumnos SET nota = 9.5 WHERE id = 3;

SELECT * FROM alumnos;
```

</details>
