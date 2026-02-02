/* ============================================
   RESTRICCIONES EN MYSQL
   ============================================ */

DROP DATABASE IF EXISTS bd_restricciones;
CREATE DATABASE bd_restricciones;
USE bd_restricciones;

/* ============================================
   1. RESTRICCIONES DE COLUMNA
   ============================================ */

CREATE TABLE usuarios (
    id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    edad INT DEFAULT 18 CHECK (edad >= 0)
);

/* INSERTS */
INSERT INTO usuarios (id, email) VALUES (1, 'ana@gmail.com');
INSERT INTO usuarios (id, email, edad) VALUES (2, 'luis@gmail.com', 25);


/* ============================================
   2. RESTRICCIONES DE TABLA
   ============================================ */

CREATE TABLE matriculas (
    id INT,
    alumno_id INT,
    asignatura_id INT,
    nota DECIMAL(4,2),

    CONSTRAINT pk_matriculas PRIMARY KEY (id),
    CONSTRAINT uk_alumno_asig UNIQUE (alumno_id, asignatura_id),
    CONSTRAINT chk_nota CHECK (nota BETWEEN 0 AND 10)
);

/* INSERT CORRECTO */
INSERT INTO matriculas VALUES (1, 10, 5, 8.5);

/* ESTE DARÍA ERROR POR EL CHECK */
/*
INSERT INTO matriculas VALUES (2, 11, 5, 15);
*/