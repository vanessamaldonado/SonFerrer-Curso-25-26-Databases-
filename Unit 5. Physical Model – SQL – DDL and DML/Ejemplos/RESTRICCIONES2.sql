/* ============================================
   NOT NULL y UNIQUE EN MYSQL
   ============================================ */

DROP DATABASE IF EXISTS bd_restricciones;
CREATE DATABASE bd_restricciones;
USE bd_restricciones;

/* ============================================
   1. NOT NULL
   ============================================ */

CREATE TABLE cliente (
    dni VARCHAR(9) NOT NULL,
    nombre VARCHAR(50)
);

/* INSERT CORRECTO */
INSERT INTO cliente VALUES ('12345678A', 'Ana');

/* ESTO DARÍA ERROR (dni es NOT NULL) */
/*
INSERT INTO cliente VALUES (NULL, 'Luis');
*/


/* ============================================
   2. UNIQUE EN UNA COLUMNA
   ============================================ */

CREATE TABLE usuarios (
    email VARCHAR(100) UNIQUE,
    nombre VARCHAR(50)
);

INSERT INTO usuarios VALUES ('ana@gmail.com', 'Ana');

/* ESTE DARÍA ERROR POR REPETIR */
-- INSERT INTO usuarios VALUES ('ana@gmail.com', 'Otra Ana');


/* ============================================
   3. UNIQUE COMPUESTO (VARIAS COLUMNAS)
   ============================================ */

CREATE TABLE alquiler (
    dni VARCHAR(9),
    cod_pelicula INT,
    fecha DATE,

    CONSTRAINT alquiler_uk UNIQUE (dni, cod_pelicula)
);

INSERT INTO alquiler VALUES ('12345678A', 10, '2025-01-10');

/* ESTE DARÍA ERROR (MISMO dni + MISMA película) */
-- INSERT INTO alquiler VALUES ('12345678A', 1
