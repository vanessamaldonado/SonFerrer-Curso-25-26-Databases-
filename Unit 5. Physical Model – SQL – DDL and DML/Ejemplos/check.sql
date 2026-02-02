/* ============================================
   RESTRICCIONES CHECK EN MYSQL
   ============================================ */

DROP DATABASE IF EXISTS bd_check;
CREATE DATABASE bd_check;
USE bd_check;

/* ============================================
   1. CHECK SIMPLE
   ============================================ */

CREATE TABLE ingresos (
    cod INT PRIMARY KEY,
    concepto VARCHAR(40) NOT NULL,
    importe DECIMAL(11,2),
    CONSTRAINT ingresos_ck1 CHECK (importe > 0 AND importe < 8000)
);
DESCRIBE ingresos;

/* INSERT CORRECTO */
INSERT INTO ingresos VALUES (1, 'Venta', 300);

/* INSERT QUE DA ERROR */
-- INSERT INTO ingresos VALUES (2, 'Venta ilegal', 9000);

/* ============================================
   2. CHECK ENTRE DOS COLUMNAS
   ============================================ */

CREATE TABLE ingresos2 (
    cod INT PRIMARY KEY,
    importe_max DECIMAL(11,2),
    importe DECIMAL(11,2),

    CONSTRAINT ingresos2_ck1 CHECK (importe < importe_max)
);

INSERT INTO ingresos2 VALUES (1, 1000, 300);

/* ESTE DA ERROR */
-- INSERT INTO ingresos2 VALUES (2, 500, 700);

/* ============================================
   3. AÑADIR CHECK CON ALTER TABLE
   ============================================ */

ALTER TABLE ingresos
ADD CONSTRAINT ingresos_ck2 CHECK (importe >= 10);

/* ============================================
   4. BORRAR CHECK
   ============================================ */

ALTER TABLE ingresos DROP CHECK ingresos_ck2;
