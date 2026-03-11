# Práctica 01 de la unidad 7: Procedimientos y funciones

## Ejercicio 1:
Crea la bbd: Empresa y añede las siguientes tablas:

- Trabajador (id PK, nombre, apellidos, oficio, fecha_alta, salario, comision, id_departamento FK)
- Departamentos (id_departamento PK, nombre, ubicacion).

Añade los departamentos:
  - Nombre: Administración, Ubicación: Madrid
  - Nombre: Ventas, Ubicación: Barcelona
  - Nombre: IT, Ubicación: Valencia
  - Nombre: RRHH, Ubicación: Sevilla
  
Añade los trabajadores:
- Nombre:Ana, Apellidos: García López, Oficio: Administrativa, Fecha de Alta: 2023-02-10, Salario:1800.00, Comisión: no, Departamento: Administración
- Nombre:Luis, Apellidos: Martín Pérez, Oficio: Comercial, Fecha de Alta: 2022-06-01, Salario:1500.00, Comisión: 300.00, Departamento: Ventas
- Nombre:Marta, Apellidos: Sánchez Ruiz, Oficio: Desarrolladora, Fecha de Alta: 2021-09-15, Salario:2600.00, Comisión: no, Departamento: IT
- Nombre:Jorge, Apellidos: Navarro Gil, Oficio: Técnico Soporte, Fecha de Alta: 2024-01-20, Salario:1900.00, Comisión: no, Departamento: RRHH
- Nombre:Sara, Apellidos: López Fernández, Oficio: RRHH, Fecha de Alta: 2020-03-05, Salario:2200.00, Comisión: no, Departamento: RRHH
- Nombre:Pablo, Apellidos: Torres Molina, Oficio: Comercial, Fecha de Alta: 2023-11-08, Salario:1400.00, Comisión: 450.00, Departamento: Ventas


<details><summary>Mostrar solución</summary>

```sql
-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS empresa;

USE empresa;

-- Tabla: departamentos
CREATE TABLE IF NOT EXISTS departamentos (
  id_departamento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(100) NOT NULL,
  ubicacion    VARCHAR(100) NOT NULL
);

-- Tabla: trabajador
CREATE TABLE IF NOT EXISTS trabajador (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(60) NOT NULL,
  apellidos VARCHAR(120) NOT NULL,
  oficio VARCHAR(80) NOT NULL,
  fecha_alta DATE NOT NULL,
  salario DECIMAL(10,2),
  comision DECIMAL(10,2),
  id_departamento INT UNSIGNED NOT NULL,
  FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

USE empresa;

-- Datos para DEPARTAMENTOS
INSERT INTO departamentos (nombre, ubicacion) VALUES
  ('Administración', 'Madrid'),
  ('Ventas',         'Barcelona'),
  ('IT',             'Valencia'),
  ('RRHH',           'Sevilla');

-- Datos para TRABAJADOR
-- (Asegúrate de que los IDs de departamento existan: 1..4 según el insert anterior)
INSERT INTO trabajador
  (nombre, apellidos, oficio, fecha_alta, salario, comision, id_departamento)
VALUES
  ('Ana',   'García López',     'Administrativa', '2023-02-10', 1800.00, NULL,   1),
  ('Luis',  'Martín Pérez',     'Comercial',      '2022-06-01', 1500.00, 300.00, 2),
  ('Marta', 'Sánchez Ruiz',     'Desarrolladora', '2021-09-15', 2600.00, NULL,   3),
  ('Jorge', 'Navarro Gil',      'Técnico Soporte','2024-01-20', 1900.00, NULL,   4),
  ('Sara',  'López Fernández',  'RRHH',           '2020-03-05', 2200.00, NULL,   4),
  ('Pablo', 'Torres Molina',    'Comercial',      '2023-11-08', 1400.00, 450.00, 2);
```
</details>

Se pide implementar los siguientes procedimientos almacenados y funciones:

a) Crear un procedimiento que reciba como parámetro el id_departamento y muestre todos los trabajadores pertenecientes a dicho departamento.

Si el departamento no existe, deberá lanzar una excepción con: SQLSTATE '45000' y el mensaje: 'El departamento no existe'.

<details><summary>Mostrar solución</summary>

```sql
USE empresa;

DROP PROCEDURE IF EXISTS p_trabajadores_por_departamento;
DELIMITER $$

CREATE PROCEDURE p_trabajadores_por_departamento(IN p_id_departamento INT)
BEGIN
  IF (SELECT COUNT(*) FROM departamentos WHERE id_departamento = p_id_departamento) = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El departamento no existe';
  END IF;

  SELECT id, nombre, apellidos, oficio, fecha_alta, salario, comision, id_departamento
  FROM trabajador
  WHERE id_departamento = p_id_departamento
  ORDER BY apellidos, nombre;
END$$

DELIMITER ;

-- prueba:
CALL p_trabajadores_por_departamento(2); -- Luis y Pablo
```
</details>

b) Crear un procedimiento que inserte un nuevo trabajador en la tabla Trabajador.

Parámetros:
  - id
  - nombre
  - apellidos
  - oficio
  - fecha_alta
  - salario
  - comision
  - id_departamento

Si el departamento no existe, lanzar excepción: SQLSTATE '45000' y el mensaje: 'El departamento no existe'.

Si el salario o la comisión son negativos, lanzar excepción: SQLSTATE '45000'y el mensaje: 'El salario o la comisión no pueden ser negativos'.

> Si el id del trabajador ya existe, `lanzará automáticamente` el error de clave primaria duplicada (1062).

<details><summary>Mostrar solución</summary>

```sql
DROP PROCEDURE IF EXISTS p_trabajador_alta;
DELIMITER $$

CREATE PROCEDURE p_trabajador_alta(
  IN p_id INT,
  IN p_nombre VARCHAR(50),
  IN p_apellidos VARCHAR(80),
  IN p_oficio VARCHAR(50),
  IN p_fecha_alta DATE,
  IN p_salario DECIMAL(10,2),
  IN p_comision DECIMAL(10,2),
  IN p_id_departamento INT
)
BEGIN
  IF p_salario < 0 OR (p_comision IS NOT NULL AND p_comision < 0) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El salario o la comision no pueden ser negativos';
  END IF;

  IF (SELECT COUNT(*) FROM departamentos WHERE id_departamento = p_id_departamento) = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El departamento no existe';
  END IF;

  INSERT INTO trabajador (id, nombre, apellidos, oficio, fecha_alta, salario, comision, id_departamento)
  VALUES (p_id, p_nombre, p_apellidos, p_oficio, p_fecha_alta, p_salario, p_comision, p_id_departamento);
END$$

DELIMITER ;
-- alta válida
CALL p_trabajador_alta(10, 'Nuria', 'Cano Díaz', 'Comercial', '2025-01-10', 1600.00, 200.00, 2);
SELECT *  FROM trabajador WHERE id = 10;
-- Error: departamento no existe
CALL p_trabajador_alta(11, 'Pepe', 'Sin Departamento', 'Administrativo', '2025-01-10', 1400.00, NULL, 99);
-- Error: salario negativo
CALL p_trabajador_alta(12, 'Laura', 'Salario Negativo', 'Administrativa', '2025-01-10', -100.00, NULL, 1);
-- Error: comisión negativa
CALL p_trabajador_alta(13,'Mario','Comision Negativa','Comercial','2025-01-10',1400.00,-50.00,2);
-- probar el error 1062
CALL p_trabajador_alta(10, 'Pepe', 'López', 'Admin', '2025-02-01', 1200.00, NULL, 1);
```
</details>

c) Crear un procedimiento que elimine un trabajador a partir de su id.

Si el trabajador no existe, lanzar excepción: SQLSTATE '45000' y el mensaje Mensaje: 'El trabajador no existe'.

<details><summary>Mostrar solución (opcion A)</summary>

```sql
DROP PROCEDURE IF EXISTS p_trabajador_baja;
DELIMITER $$

CREATE PROCEDURE p_trabajador_baja(IN p_id INT)
BEGIN
  DELETE FROM trabajador
  WHERE id = p_id;

  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El trabajador no existe';
  END IF;
END$$

DELIMITER ;

-- pruebas
CALL p_trabajador_baja(2);
CALL p_trabajador_baja(99);
```
</details>

<details><summary>Mostrar solución (opción B)</summary>

```sql
DROP PROCEDURE IF EXISTS p_trabajador_baja;
DELIMITER $$

CREATE PROCEDURE p_trabajador_baja(IN p_id INT)
BEGIN
  IF (SELECT COUNT(*) FROM trabajador WHERE id = p_id) = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El trabajador no existe';
  ELSE
    DELETE FROM trabajador
    WHERE id = p_id;
  END IF;
END$$

DELIMITER ;

-- pruebas
CALL p_trabajador_baja(2);
CALL p_trabajador_baja(99);
```
</details>

d) Crear un procedimiento que incremente el salario de todos los trabajadores de un departamento determinado.

El incremento podrá realizarse:
  - Porcentaje (por ejemplo, +10%)
  - Cantidad fija (por ejemplo, +200€)

Si el departamento no existe, lanzar excepción: SQLSTATE '45000' y el mensaje 'El departamento no existe'.

Si el porcentaje o la cantidad es negativa, lanzar excepción: SQLSTATE '45000' y el mensaje: 'El incremento no puede ser negativo'.

<details><summary>Mostrar solución (por porcentaje)</summary>

```sql
DROP PROCEDURE IF EXISTS p_subir_salario_departamento_pct;
DELIMITER $$

CREATE PROCEDURE p_subir_salario_departamento_pct(
  IN p_id_departamento INT,
  IN p_porcentaje DECIMAL(6,2)  -- ej: 10.00 = +10%
)
BEGIN
  IF p_porcentaje < 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El incremento no puede ser negativo';
  END IF;

  IF (SELECT COUNT(*) FROM departamentos WHERE id_departamento = p_id_departamento) = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El departamento no existe';
  END IF;

  UPDATE trabajador
  SET salario = salario * (1 + p_porcentaje / 100)
  WHERE id_departamento = p_id_departamento;
END$$

DELIMITER ;

-- prueba en Ventas (id_departamento = 2) subir un 10%:
SELECT id, nombre, apellidos, salario
FROM trabajador
WHERE id_departamento = 2;

CALL p_subir_salario_departamento_pct(2, 10.00);

-- Probar error por incremento negativo
CALL p_subir_salario_departamento_pct(2, -5.00);
```
</details>

<details><summary>Mostrar solución (fijo)</summary>

```sql
DROP PROCEDURE IF EXISTS p_subir_salario_departamento_fijo;
DELIMITER $$

CREATE PROCEDURE p_subir_salario_departamento_fijo(
  IN p_id_departamento INT UNSIGNED,
  IN p_cantidad DECIMAL(10,2)   -- ej: 200.00 = +200€
)
BEGIN
  IF p_cantidad < 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El incremento no puede ser negativo';
  END IF;

  IF (SELECT COUNT(*) FROM departamentos WHERE id_departamento = p_id_departamento) = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El departamento no existe';
  END IF;

  UPDATE trabajador
  SET salario = ROUND(salario + p_cantidad, 2)
  WHERE id_departamento = p_id_departamento;
END$$

DELIMITER ;

-- prueba en IT (id_departamento = 3) subir 200 euros:
SELECT id, nombre, apellidos, salario
FROM trabajador
WHERE id_departamento = 3;

CALL p_subir_salario_departamento_fijo(3, 200.00);

-- Probar error por incremento negativo
CALL p_subir_salario_departamento_fijo(3, -100.00);
```
</details>

e) Crear una función que reciba el id_departamento y devuelva el salario total (SUM) de todos los trabajadores del departamento.

Si no existen trabajadores en el departamento, deberá devolver 0.

La función debe declararse como:
- DETERMINISTIC
- READS SQL DATA

<details><summary>Mostrar solución</summary>

```sql
DROP FUNCTION IF EXISTS f_salario_total_departamento;
DELIMITER $$

CREATE FUNCTION f_salario_total_departamento(p_id_departamento INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_total DECIMAL(12,2);

  SELECT SUM(salario)
    INTO v_total
  FROM trabajador
  WHERE id_departamento = p_id_departamento;

   IF v_total IS NULL THEN
    SET v_total = 0;
  END IF;

  RETURN v_total;
END$$

DELIMITER ;

-- un departamento con trabajadores
SELECT f_salario_total_departamento(2);

-- un departamento sin trabajadores
SELECT f_salario_total_departamento(99);
```
</details>

f) Crear una función que reciba el id_departamento y devuelva el número total de trabajadores del departamento.

Si no existen trabajadores en el departamento, deberá devolver 0.

La función debe declararse como:
- DETERMINISTIC
- READS SQL DATA

<details><summary>Mostrar solución</summary>

```sql
DROP FUNCTION IF EXISTS f_num_empleados_departamento;
DELIMITER $$

CREATE FUNCTION f_num_empleados_departamento(p_id_departamento INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_num INT;

  SELECT COUNT(*)
    INTO v_num
  FROM trabajador
  WHERE id_departamento = p_id_departamento;

IF v_num IS NULL THEN
    SET v_num = 0;
  END IF;

  RETURN v_num;
END$$

DELIMITER ;

-- un departamento con trabajadores
SELECT f_num_empleados_departamento(2);

-- un departamento sin trabajadores
SELECT f_num_empleados_departamento(99);
```
</details>


---

## Ejercicio 2:

Añade a la tabla `trabajador` la columna:
- anios_experiencia INT

Asigna los siguientes años de experiencia a los trabajadores:

| id | nombre | años experiencia |
| -- | ------ | ---------------- |
| 1  | Ana    | 4                |
| 2  | Luis   | 6                |
| 3  | Marta  | 3                |
| 4  | Jorge  | 2                |
| 5  | Sara   | 7                |
| 6  | Pablo  | 1                |


<details><summary>Mostrar solución</summary>

```sql
ALTER TABLE trabajador
ADD COLUMN anios_experiencia INT;

UPDATE trabajador SET anios_experiencia = 4 WHERE id = 1;
UPDATE trabajador SET anios_experiencia = 6 WHERE id = 2;
UPDATE trabajador SET anios_experiencia = 3 WHERE id = 3;
UPDATE trabajador SET anios_experiencia = 2 WHERE id = 4;
UPDATE trabajador SET anios_experiencia = 7 WHERE id = 5;
UPDATE trabajador SET anios_experiencia = 1 WHERE id = 6;
```
</details>

a) Crea un procedimiento llamado `ajustar_salario` que reciba el identificador de un trabajador y ajuste su salario según el departamento al que pertenece.

- Si el departamento es 'Ventas', aumenta el salario un 10%.
- Si es 'Administración', aumenta el salario un 5%.
- Si es 'IT', disminuye el salario un 3%.
- En cualquier otro caso, no se realizarán cambios.

Utiliza la estructura CASE.

> El nombre del departamento debe obtenerse a partir de la tabla departamentos usando id_departamento.

<details><summary>Mostrar solución</summary>

```sql
DROP PROCEDURE IF EXISTS p_ajustar_salario;
DELIMITER $$

CREATE PROCEDURE p_ajustar_salario(IN p_id INT)
BEGIN
   IF (SELECT COUNT(*) FROM trabajador WHERE id = p_id) = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El trabajador no existe';
  ELSE
    UPDATE trabajador t
    JOIN departamentos d
      ON t.id_departamento = d.id_departamento
    SET t.salario = CASE
      WHEN d.nombre = 'Ventas' THEN t.salario * 1.10
      WHEN d.nombre = 'Administración' THEN t.salario * 1.05
      WHEN d.nombre = 'IT' THEN t.salario * 0.97
      ELSE t.salario
    END
    WHERE t.id = p_id;
  END IF;

END$$

DELIMITER ;

-- prueba 
SELECT id, nombre, salario, id_departamento
FROM trabajador
WHERE id = 2;
-- Luis está en Ventas, así que debe subir un 10%
CALL p_ajustar_salario(2);

-- Ana (Administración) → sube 5%
CALL p_ajustar_salario(1);

-- Marta (IT) → baja 3%
CALL p_ajustar_salario(3);
```
</details>


b) Crea un procedimiento llamado `incrementar_salarios` que aumente en 100 euros el salario de todos los trabajadores de la empresa hasta que el salario medio (AVG) supere los 3000 euros.

Debes utilizar la estructura REPEAT ... UNTIL ... END REPEAT.

<details><summary>Mostrar solución</summary>

```sql
SET SQL_SAFE_UPDATES = 0;

DROP PROCEDURE IF EXISTS p_incrementar_salarios;
DELIMITER $$

CREATE PROCEDURE p_incrementar_salarios()
BEGIN
  DECLARE media_salario DECIMAL(10,2);

  REPEAT
    UPDATE trabajador
    SET salario = salario + 100;

    SELECT AVG(salario)
    INTO media_salario
    FROM trabajador;

  UNTIL media_salario > 3000
  END REPEAT;
END$$

DELIMITER ;

-- Ver media antes
SELECT AVG(salario) AS media_antes FROM trabajador;

-- Ejecutar el procedimiento
CALL p_incrementar_salarios();

-- Ver media después
SELECT AVG(salario) AS media_despues FROM trabajador;

-- Ver salarios finales
SELECT id, nombre, apellidos, salario FROM trabajador ORDER BY id;
```
</details>

c) Crea una función llamada `calcular_ahorro` que reciba el id de un trabajador y calcule cuánto dinero habría ahorrado si hubiera guardado el 5% de su salario mensual durante todos los meses de su experiencia laboral.

- Meses trabajados = anios_experiencia * 12
- Ahorro mensual = salario * 0.05

Debes utilizar la estructura WHILE.

<details><summary>Mostrar solución</summary>

```sql
DROP FUNCTION IF EXISTS f_calcular_ahorro;
DELIMITER $$

CREATE FUNCTION f_calcular_ahorro(p_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_salario DECIMAL(10,2);
  DECLARE v_anios INT;
  DECLARE v_meses INT;
  DECLARE v_total DECIMAL(10,2);
  DECLARE i INT;

  -- busca el salario y los anios_experiencia del trabajador
  SELECT salario, anios_experiencia
  INTO v_salario, v_anios
  FROM trabajador
  WHERE id = p_id;

  -- calcula los meses:
  SET v_meses = v_anios * 12;
  SET v_total = 0;
  SET i = 1;

  -- cada vuelta del WHILE suma el 5% del salario
  WHILE i <= v_meses DO
    SET v_total = v_total + (v_salario * 0.05);
    SET i = i + 1;
  END WHILE;

  RETURN v_total;
END$$

DELIMITER ;

-- prueba:
SELECT f_calcular_ahorro(1) AS ahorro;

SELECT f_calcular_ahorro(1) AS ahorro_ana;
SELECT f_calcular_ahorro(2) AS ahorro_luis;
SELECT f_calcular_ahorro(3) AS ahorro_marta;
```
</details>