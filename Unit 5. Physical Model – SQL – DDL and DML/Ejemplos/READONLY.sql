/* ============================================
   EJEMPLO READ ONLY EN MYSQL 8+
   ============================================ */

DROP DATABASE IF EXISTS bd_readonly;
CREATE DATABASE bd_readonly;
USE bd_readonly;

/* ============================================
   1. CREAR TABLA
   ============================================ */

CREATE TABLE productos (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);

/* ============================================
   2. INSERTAR DATOS
   ============================================ */

INSERT INTO productos VALUES
(1, 'Teclado', 25.00),
(2, 'Ratón', 15.00);

/* ============================================
   3. PONER LA TABLA EN MODO SOLO LECTURA (ORACLE)
   ============================================ */
-- ALTER TABLE productos READ ONLY;

/* ===============================
   MODO SOLO LECTURA (MYSQL)
   =============================== */
LOCK TABLES productos READ;
SELECT * FROM productos;

/* ============================================
   5. OPERACIONES BLOQUEADAS (DARÁN ERROR)
   ============================================ */
-- INSERT INTO productos VALUES (3, 'Pantalla', 120.00);
-- UPDATE productos SET precio = 40 WHERE id = 1;
-- DELETE FROM productos WHERE id = 2;
-- TRUNCATE TABLE productos;

/* ============================================
   6. DEVOLVER A MODO NORMAL (ORACLE)
   ============================================ */
-- ALTER TABLE productos READ WRITE;

/* ===============================
   QUITAR MODO SOLO LECTURA
   =============================== */
UNLOCK TABLES;

/* ============================================
   7. INSERT AHORA SÍ FUNCIONA
   ============================================ */

INSERT INTO productos VALUES (3, 'Pantalla', 120.00);

SELECT * FROM productos;
