-- =======================================================
-- DELETE 
-- =======================================================
USE demo_insert;
SELECT * FROM empleados;

-- =======================================================
-- 1. DELETE BÁSICO
-- Borrar un empleado concreto
-- =======================================================
DELETE FROM empleados
WHERE nombre = 'Luis';

SELECT * FROM empleados;

-- =======================================================
-- 2. DELETE MULTIPLE
-- Borrar empleados que cobren más de 4000€
-- =======================================================
DELETE FROM empleados
WHERE salario > 4000;

SELECT * FROM empleados;

-- =======================================================
-- 3. DELETE CON SUBCONSULTA
-- Borrar empleados cuyo salario sea inferior a la media
-- =======================================================
DELETE FROM empleados
WHERE salario < (SELECT AVG(salario) FROM (SELECT salario FROM empleados) AS t);

SELECT * FROM empleados;

-- =======================================================
-- 4. DELETE EN TABLA usuarios
-- Borrar usuarios con visitas = 1
-- =======================================================
DELETE FROM usuarios
WHERE visitas = 1;

SELECT * FROM usuarios;

-- =======================================================
-- 6. DELETE CON LIMIT 
-- Eliminar solo 1 usuario independientemente del filtro
-- =======================================================
DELETE FROM usuarios
ORDER BY id ASC
LIMIT 1;

SELECT * FROM usuarios;