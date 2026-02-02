-- =======================================================
-- UPDATE
-- =======================================================
USE demo_insert;
SELECT * FROM empleados;
SET SQL_SAFE_UPDATES = 0;


-- =======================================================
-- 1. UPDATE BÁSICO
-- Cambiar el salario de un empleado concreto
-- =======================================================
UPDATE empleados
SET salario = 2600
WHERE nombre = 'Carlos';

SELECT * FROM empleados;

-- =======================================================
-- 2. UPDATE MULTIPLE
-- Subir 10% el salario a todos los empleados
-- con salario mayor de 3000
-- =======================================================
UPDATE empleados
SET salario = salario * 1.10
WHERE salario > 3000;

SELECT * FROM empleados;

-- =======================================================
-- 3. UPDATE DE VARIAS COLUMNAS A LA VEZ
-- Cambiar nombre y salario simultáneamente
-- =======================================================
UPDATE empleados
SET nombre = 'Empleado_Modificado',
    salario = salario + 500
WHERE nombre = 'Marta';

SELECT * FROM empleados;

-- =======================================================
-- 4. UPDATE BASADO EN OTRA TABLA
-- Aumentar salario de empleados cuyo salario
-- esté por debajo del salario medio
-- =======================================================
UPDATE empleados
SET salario = salario + 200
WHERE salario < (SELECT AVG(salario) FROM empleados);
-- MYSQL no lo permite Ya que sería leer y escribir la tabla al mismo tiempo.

UPDATE empleados
SET salario = salario + 200
WHERE salario < (
    SELECT avg_salario
    FROM (SELECT AVG(salario) AS avg_salario FROM empleados) AS t
);
-- creamos tabla temporal

SELECT * FROM empleados;

-- =======================================================
-- 5. UPDATE EN TABLA usuarios
-- Sumar 1 visita a todos los usuarios
-- =======================================================
UPDATE usuarios
SET visitas = visitas + 1;

SELECT * FROM usuarios;

-- =======================================================
-- 6. UPDATE CON CONDICIÓN UNIQUE
-- Cambiar el email (solo funciona si no genera duplicado)
-- =======================================================
UPDATE usuarios
SET email = 'nuevo_correo@gmail.com'
WHERE email = 'test@gmail.com';

SELECT * FROM usuarios;

-- =======================================================
-- 7. UPDATE PARA LIMPIAR REGISTROS
-- Cambiar salario null a 0 (si existiera)
-- =======================================================
UPDATE empleados
SET salario = 0
WHERE salario IS NULL;

SELECT * FROM empleados;
