/* ============================================
  UNUSED EN MYSQL
   ============================================ */

DROP DATABASE IF EXISTS bd_unused;
CREATE DATABASE bd_unused;
USE bd_unused;

/* ============================================
   1. CREAR TABLA
   ============================================ */

CREATE TABLE personas (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    n_seguridad_social VARCHAR(20)
);

/* ============================================
   2. INSERTAR DATOS
   ============================================ */

INSERT INTO personas VALUES
(1, 'Ana', '12345678A'),
(2, 'Luis', '87654321B');

/* ============================================
   3. "MARCAR COMO UNUSED" (SIMULACION)
   RENOMBRAMOS LA COLUMNA
   ============================================ */

ALTER TABLE personas 
CHANGE n_seguridad_social n_seguridad_social_UNUSED VARCHAR(20);

/* ============================================
   4. CONSULTAR ESTRUCTURA
   ============================================ */

DESCRIBE personas;

/* ============================================
   5. ELIMINAR DEFINITIVAMENTE LA COLUMNA
   ============================================ */

ALTER TABLE personas 
DROP COLUMN n_seguridad_social_UNUSED;

/* ============================================
   6. COMPROBAR RESULTADO FINAL
   ============================================ */

DESCRIBE personas;
SELECT * FROM personas;