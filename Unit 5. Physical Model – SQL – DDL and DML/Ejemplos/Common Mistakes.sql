/* ============================================================
   Common Mistakes
   ============================================================ */
CREATE DATABASE IF NOT EXISTS mistakes_mysql;
USE mistakes_mysql;

DROP TABLE IF EXISTS alumno;
CREATE TABLE alumno (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido1 VARCHAR(50),
    edad INT,
    telefono VARCHAR(20),
    fecha_nacimiento DATE
);
ALTER TABLE alumno
ADD nota DECIMAL(4,2);

INSERT INTO alumno (nombre, apellido1, edad, telefono, fecha_nacimiento) VALUES
('Ana', 'Sanchez', 15, NULL, '2009-03-12'),
('Luis', 'Serrano', 20, '555-100', '2004-06-20'),
('Marta', 'Lopez', 70, NULL, '1954-01-05'),
('Carlos', 'Martinez', 33, '555-200', '1991-11-18'),
('Sonia', 'Suarez', 25, '555-300', '1999-07-10');

SET SQL_SAFE_UPDATES = 0;
UPDATE alumno SET nota = 7.5 WHERE nombre = 'Ana';
UPDATE alumno SET nota = 8.0 WHERE nombre = 'Luis';
UPDATE alumno SET nota = 6.0 WHERE nombre = 'Marta';
UPDATE alumno SET nota = 9.0 WHERE nombre = 'Carlos';


DROP TABLE IF EXISTS pedido;

CREATE TABLE pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha_esperada DATE,
    fecha_entrega DATE
);

INSERT INTO pedido (fecha_esperada, fecha_entrega) VALUES
('2024-02-01', '2024-02-05'),
('2024-03-10', '2024-03-08'),
('2024-04-01', '2024-04-15');


/* ============================================================
   1. Error checking if a column is NULL
   Get the list of students who have a value NULL in the column teléfono.
   ============================================================ */

-- Incorrect query Cualquier comparación con = frente a algo desconocido da como resultado UNKNOWN, no TRUE.
SELECT *
FROM alumno
WHERE telefono = NULL;

-- Correct query. IS NULL no compara valores, sino que evalúa si el campo no contiene ningún dato.
SELECT *
FROM alumno
WHERE telefono IS NULL;


/* ============================================================
   2. Error when comparing strings with patterns using the = operator
   Example: Returns a list of students whose last name begins with S.
   ============================================================ */
-- Incorrect query. El operador = exige coincidencia exacta carácter por carácter.
SELECT *
FROM alumno
WHERE apellido1 = 'S%';

-- Correct query. LIKE interpreta % como comodín:
SELECT *
FROM alumno
WHERE apellido1 LIKE 'S%' ;


/* ============================================================
   3. Error when comparing strings with patterns using the != operator
   Example: Returns a list of students whose first surname does not begin with S.
   ============================================================ */

-- Incorrect query. != solo sirve para comparaciones exactas
SELECT *
FROM alumno
WHERE apellido1 != 'S%';

-- Correct query. Es lógica booleana correcta aplicada a patrones.
SELECT *
FROM alumno
WHERE apellido1 NOT LIKE 'S%';


/* ============================================================
   4. Error when comparing a range of values ​​with AND
   When we want to compare whether a value is within a range, 
   we have to use two conditions joined by the logical operation AND
   ============================================================ */

-- Incorrect query. Esta expresión no compara nada en la segunda parte.
SELECT *
FROM alumno
WHERE fecha_nacimiento >= '1999/01/01' AND '1999/12/31';

-- Correct query.
SELECT *
FROM alumno
WHERE fecha_nacimiento >= '1999/01/01' AND fecha_nacimiento <= '1999/12/31';

/* ============================================================
   5. Type conversion errors in expression evaluation
   When using an operator with operands of different data types, 
   MySQL performs automatic type conversion to ensure compatibility. 
   For example, it automatically converts strings to numbers as needed and vice versa.
   ============================================================ */

 SELECT 1 + '1';
-- 2 MySQL convierte '1' a número Porque el operador + exige números.

SELECT CONCAT(1, '1');
-- '11' Aquí convierte 1 a texto Porque CONCAT() trabaja con cadenas.

-- Example: Subtraction between two values ​​of type VARCHAR
SELECT '2021-01-31' - '2021-02-01';
-- 0 restando dos cadenas de texto, no números ni fechas.

-- Example: Subtraction between two values ​​of type DATE
SELECT CAST('2021-01-31' AS DATE) - CAST('2021-02-01' AS DATE);
-- -70 Convierte cada fecha a su representación numérica interna YYYYMMDD 
-- Luego hace una resta aritmética normal de enteros.

-- Example: Subtraction between two values ​​of type INT
SELECT 20210131 - 20210201;
-- -70 MySQL intenta convertir esas fechas a número 2021 - 2021 = 0

-- Example: Subtract between two values ​​of type DATE using the function DATEDIFF
SELECT DATEDIFF('2021-01-31', '2021-02-01');
-- -1 Trabaja con tipo DATE real


/* ============================================================
   6. Error when using addition and subtraction operators between data types 
   DATE, DATETIMEandTIMESTAMP
   To perform addition and subtraction operations on date and time data 
   DATE, DATETIMEit TIMESTAMP's necessary to use the specific date and time 
   functions available in MySQL. 
   ============================================================ */

-- Incorrect query. MySQL hace conversión implícita errónea
-- El resultado puede ser incoherente según formato
SELECT fecha_esperada, fecha_entrega,  fecha_entrega - fecha_esperada
FROM pedido;

-- Correct query. Usa la función oficial de MySQL
SELECT fecha_esperada, fecha_entrega,  DATEDIFF(fecha_entrega, fecha_esperada)
FROM pedido;

/* ============================================================
   7. Not using BETWEEN correctly

   ============================================================ */

-- Incorrect query.  This returns ALL rows.
SELECT * FROM alumno
WHERE edad >= 20 OR edad <= 30;

-- Correct query. 
SELECT * FROM alumno
WHERE edad BETWEEN 20 AND 30;

/* ============================================================
   8. Using COUNT(column) thinking it counts NULL
   ============================================================ */

-- Incorrect query.  This does not count NULL , only non-null values.
SELECT COUNT(telefono) FROM alumno;

-- Correct query. If you want the number of rows:
SELECT COUNT(*) FROM alumno;

/* ============================================================
   9. SUM / AVG without GROUP BY in queries with additional columns
   ============================================================ */

-- Incorrect query.  Error: column not grouped.
SELECT nombre, SUM(nota)
FROM alumno;

-- Correct query.
SELECT nombre, SUM(nota)
FROM alumno
GROUP BY nombre;

/* ============================================================
   10. Use OR without parentheses and alter the filter logic
   ============================================================ */

-- Incorrect query.  MySQL evaluates AND before OR.
SELECT nombre
FROM alumno
WHERE nombre = 'Ana' OR nombre = 'Luis' AND edad >= 20;

-- Correct query.
SELECT nombre
FROM alumno
WHERE (nombre = 'Ana' OR nombre = 'Luis')
  AND edad >= 20;