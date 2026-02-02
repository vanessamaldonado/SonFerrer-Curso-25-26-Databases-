
-- =========================================================
-- DDL: Creación, modificación y eliminación de objetos
-- =========================================================

-- 1. CREAR BASE DE DATOS
CREATE DATABASE IF NOT EXISTS Demo_DDL;
USE Demo_DDL;

-- =========================================================
-- 2. CREAR TABLAS
-- =========================================================

CREATE TABLE proveedores (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    ciudad VARCHAR(50)
);

-- Tabla con valores por defecto (DEFAULT)
CREATE TABLE productos (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2) DEFAULT 0.00,
    fecha_creacion DATETIME DEFAULT NOW(),
    fecha DATE default (CURDATE())
    
);

-- =========================================================
-- 3. TIPOS DE DATOS 
-- =========================================================

CREATE TABLE tipos_datos (
    id INT,
    texto VARCHAR(100),
    numero DECIMAL(8,2),
    fecha DATE,
    fecha_hora DATETIME,
    activo BOOLEAN
);

-- =========================================================
-- 4. INSERTAR DATOS DE PRUEBA
-- =========================================================

INSERT INTO proveedores VALUES (1, 'Proveedor Uno', 'Madrid');
INSERT INTO proveedores VALUES (2, 'Proveedor Dos', 'Valencia');

INSERT INTO productos (id, nombre) VALUES (1, 'Teclado');
INSERT INTO productos (id, nombre, precio) VALUES (2, 'Ratón', 15.50);

SELECT * FROM proveedores;
SELECT * FROM productos;

-- =========================================================
-- 5. BORRAR UNA TABLA (DROP TABLE)
-- =========================================================

DROP TABLE IF EXISTS tipos_datos;

-- =========================================================
-- 6. BORRAR SOLO LOS DATOS DE UNA TABLA (TRUNCATE)
-- =========================================================
SELECT * FROM proveedores;
TRUNCATE TABLE proveedores;
SELECT * FROM proveedores;

-- =========================================================
-- 7. RENOMBRAR UNA TABLA
-- =========================================================

RENAME TABLE productos TO productos_nuevos;

-- =========================================================
-- 8. AÑADIR UNA COLUMNA
-- =========================================================

ALTER TABLE productos_nuevos
ADD categoria VARCHAR(30);

-- =========================================================
-- 9. ELIMINAR UNA COLUMNA
-- =========================================================

ALTER TABLE productos_nuevos
DROP COLUMN categoria;

-- =========================================================
-- 10. MODIFICAR UNA COLUMNA
-- =========================================================

ALTER TABLE productos_nuevos
MODIFY precio DECIMAL(12,2) DEFAULT 10.00;

-- =========================================================
-- 11. RENOMBRAR UNA COLUMNA
-- =========================================================

ALTER TABLE productos_nuevos
CHANGE nombre descripcion VARCHAR(50);

-- =========================================================
-- 12. EJEMPLO COMPLETO
-- =========================================================

CREATE TABLE empleados (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    departamento VARCHAR(50) DEFAULT 'Administración',
    sueldo DECIMAL(10,2)
);

INSERT INTO empleados (id, nombre, sueldo)
VALUES (1, 'Laura', 1500);

SELECT * FROM empleados;

ALTER TABLE empleados
ADD fecha_alta DATE DEFAULT (CURRENT_DATE);

ALTER TABLE empleados
CHANGE sueldo salario DECIMAL(12,2);

ALTER TABLE empleados
DROP COLUMN fecha_alta;

TRUNCATE TABLE empleados;

DROP TABLE empleados;


