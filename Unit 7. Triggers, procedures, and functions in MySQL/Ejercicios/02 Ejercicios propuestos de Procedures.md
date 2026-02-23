# 01 Ejercicios propuestos de Procedures.

Ejercicios resueltos de MySQL para crear procedimientos. 
> Crear la base de datos de SQL y luego los procedimientos necesarios según pide el ejercicio:

**Base de Datos a utilizar:**

```sql
CREATE DATABASE proced;
USE proced;

CREATE TABLE alumno (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    fecha_nacimiento DATE,
    edad INT
);

INSERT INTO alumno VALUES (NULL,'Guillem','Homet','1992/12/20',NULL);
INSERT INTO alumno VALUES (NULL,'Marta','Ros','1993/01/21',NULL);
INSERT INTO alumno VALUES (NULL,'Miquel','Rodríguez','1990/10/11',NULL);

CREATE TABLE profesor (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    fecha_nacimiento DATE,
    edad INT
);

INSERT INTO profesor VALUES (NULL,'Núria','Ribas','1985/10/06',NULL);
INSERT INTO profesor VALUES (NULL,'Carles','Pujol','1978/06/14',NULL);
```

---

## Ejercicio 1: 
Crea un procedimiento llamado buscar_alumnos que busque todos los alumnos cuyo apellido contenga la cadena indicada.
Ejemplo: CALL buscar_alumnos('R%')

<details><summary>Mostrar Solución</summary>
  
```sql  
DELIMITER //
CREATE PROCEDURE buscar_alumnos(IN patron VARCHAR(20))
BEGIN
    SELECT * FROM alumno WHERE apellido LIKE patron;
END //
DELIMITER ;

CALL buscar_alumnos('R%');
```
</details> 

## Ejercicio 2:
Crea un procedimiento que busque profesores por nombre y apellido. Si uno de los dos parámetros es NULL, buscará solo por el otro.
Ejemplo: CALL buscar_profesores(NULL,'Ribas')

<details><summary>Mostrar Solución</summary>
  
```sql  
DELIMITER //
CREATE PROCEDURE buscar_profesores(
    IN p_nombre VARCHAR(20),
    IN p_apellido VARCHAR(20)
)
BEGIN
    IF p_nombre IS NULL THEN
        SELECT * FROM profesor WHERE apellido LIKE p_apellido;
    ELSEIF p_apellido IS NULL THEN
        SELECT * FROM profesor WHERE nombre LIKE p_nombre;
    ELSE
        SELECT * FROM profesor
        WHERE nombre LIKE p_nombre AND apellido LIKE p_apellido;
    END IF;
END //
DELIMITER ;

CALL buscar_profesores(NULL,'R%');
```
</details>

## Ejercicio 3:
Crea un procedimiento que incremente el valor del código en el valor que se indique.
Ejemplo: CALL actualizar_codigo(20)

<details><summary>Mostrar Solución</summary>

```sql  
DELIMITER //
CREATE PROCEDURE actualizar_codigo(IN incremento INT)
BEGIN
    UPDATE alumno SET codigo = codigo + incremento;
    UPDATE profesor SET codigo = codigo + incremento;
END //
DELIMITER ;

CALL actualizar_codigo(5);
```
</details>

## Ejercicio 4:
Crea un procedimiento que, dado un nombre, apellido, fecha de nacimiento y si es profesor o alumno, lo inserte en la tabla correspondiente.
Ejemplo: CALL insertar_persona('Xavier','Vilá','1975/02/03','profesor')

<details><summary>Mostrar Solución</summary>
  
```sql  
DELIMITER //
CREATE PROCEDURE insertar_persona(
    IN p_nombre VARCHAR(20),
    IN p_apellido VARCHAR(20),
    IN p_fecha DATE,
    IN p_tipo VARCHAR(20)
)
BEGIN
    CASE p_tipo
        WHEN 'profesor' THEN
            INSERT INTO profesor VALUES (NULL,p_nombre,p_apellido,p_fecha,NULL);
        WHEN 'alumno' THEN
            INSERT INTO alumno VALUES (NULL,p_nombre,p_apellido,p_fecha,NULL);
    END CASE;
END //
DELIMITER ;

CALL insertar_persona('Pepe','Motos','1975/02/03','alumno');
```
</details>

## Ejercicio 5:
Crea un procedimiento que asigne o corrija la fecha de nacimiento de un alumno dado su código.
Ejemplo: CALL actualizar_fecha_nacimiento(21,'1995/03/19')

<details><summary>Mostrar Solución</summary>
  
```sql  
DELIMITER //
CREATE PROCEDURE actualizar_fecha_nacimiento(
    IN p_codigo INT,
    IN p_fecha DATE
)
BEGIN
    UPDATE alumno
    SET fecha_nacimiento = p_fecha
    WHERE codigo = p_codigo
    LIMIT 1;
END //
DELIMITER ;

CALL actualizar_fecha_nacimiento(6,'1999/03/19');
```
</details>

## Ejercicio 6:
Crea un procedimiento que calcule la edad de una persona a partir de su fecha de nacimiento.
Ejemplo: CALL calcular_edad('profesor',20)

<details><summary>Mostrar Solución</summary>
  
```sql  
DELIMITER //
CREATE PROCEDURE calcular_edad(
    IN p_tabla VARCHAR(20),
    IN p_codigo INT
)
BEGIN
    IF p_tabla = 'profesor' THEN
        SELECT YEAR(NOW()) - YEAR(fecha_nacimiento)
        FROM profesor WHERE codigo = p_codigo;
    ELSEIF p_tabla = 'alumno' THEN
        SELECT YEAR(NOW()) - YEAR(fecha_nacimiento)
        FROM alumno WHERE codigo = p_codigo;
    END IF;
END //
DELIMITER ;

CALL calcular_edad('profesor',6);
```
</details>

## Ejercicio 7:
Crea un procedimiento que elimine los alumnos cuyo código esté entre los dos valores indicados (incluidos).
Ejemplo: CALL eliminar_alumnos(20,22)

<details><summary>Mostrar Solución</summary>
  
```sql  
DELIMITER //
CREATE PROCEDURE eliminar_alumnos(
    IN cod_inicio INT,
    IN cod_fin INT
)
BEGIN
    DECLARE codigo_actual INT DEFAULT cod_inicio;
    WHILE codigo_actual <= cod_fin DO
        DELETE FROM alumno WHERE codigo = codigo_actual LIMIT 1;
        SET codigo_actual = codigo_actual + 1;
    END WHILE;
END //
DELIMITER ;

CALL eliminar_alumnos(6,8);
```
</details>

