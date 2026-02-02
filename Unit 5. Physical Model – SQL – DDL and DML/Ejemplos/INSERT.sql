-- =======================================================
-- 1. CREAR BASE DE DATOS Y USARLA
-- =======================================================
DROP DATABASE IF EXISTS demo_insert;
CREATE DATABASE demo_insert;
USE demo_insert;

-- =======================================================
-- 2. CREATE TABLA EMPLEADOS
-- =======================================================
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) DEFAULT 0
);

-- =======================================================
-- 3. INSERT SIMPLE
-- =======================================================
INSERT INTO empleados (nombre, salario)
VALUES ('Carlos', 2500.00);

SELECT * FROM empleados;

-- =======================================================
-- 4. INSERT MÚLTIPLE
-- =======================================================
INSERT INTO empleados (nombre, salario)
VALUES 
    ('Ana', 3000.00),
    ('Luis', 2800.00),
    ('Marta', 3200.00);

SELECT * FROM empleados;

-- =======================================================
-- 5. INSERT USANDO TODOS LOS CAMPOS (incluyendo el id)
-- Si pones NULL en el id, MySQL genera el AUTO_INCREMENT
-- =======================================================
INSERT INTO empleados
VALUES (NULL, 'Jorge', 2700.00);

SELECT * FROM empleados;

-- =======================================================
-- 6. INSERT OMITIENDO COLUMNAS CON DEFAULT
-- =======================================================
INSERT INTO empleados (nombre)
VALUES ('EmpleadoSinSalario');

-- salario tomará el default=0
SELECT * FROM empleados;

-- =======================================================
-- 7. TABLA CON UNA COLUMNA ÚNICA PARA PROBAR INSERT IGNORE
-- Una columna única (UNIQUE) es una columna donde no se pueden repetir valores.
-- =======================================================
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) UNIQUE, -- ESTA COLUMNA ES ÚNICA
    visitas INT DEFAULT 1
);

-- Insert normal (fallará si ya existe)
INSERT INTO usuarios (email) VALUES ('test@gmail.com');

-- Probar INSERT IGNORE (NO se inserta, pero tampoco da error)
INSERT IGNORE INTO usuarios (email) VALUES ('test@gmail.com');

SELECT * FROM usuarios;

-- =======================================================
-- 8. INSERT ON DUPLICATE KEY UPDATE (UPSERT)
-- Sirve para hacer dos cosas en un solo comando:
-- INSERTAR un registro si no existe.
-- ACTUALIZAR ese registro si ya existe.
-- =======================================================
INSERT INTO usuarios (email, visitas)
VALUES ('test@gmail.com', 1)
ON DUPLICATE KEY UPDATE visitas = visitas + 1;

SELECT * FROM usuarios;

-- =======================================================
-- 9. TABLAS PARA INSERT CON SELECT
-- =======================================================
CREATE TABLE empleados_backup (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    salario DECIMAL(10,2)
);

-- Copiar empleados con salario > 3000
INSERT INTO empleados_backup (nombre, salario)
SELECT nombre, salario
FROM empleados
WHERE salario > 3000;

SELECT * FROM empleados_backup;
