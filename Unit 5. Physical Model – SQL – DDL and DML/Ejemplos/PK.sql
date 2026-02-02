/* ============================================
   CLAVE PRIMARIA EN MYSQL
   ============================================ */

DROP DATABASE IF EXISTS bd_pk;
CREATE DATABASE bd_pk;
USE bd_pk;

/* ============================================
   1. CLAVE PRIMARIA DE UN SOLO CAMPO
   ============================================ */

CREATE TABLE clientes (
    dni VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(50)
);

/* INSERT CORRECTO */
INSERT INTO clientes VALUES ('12345678A', 'Ana');

/* ESTO DARÍA ERROR POR REPETIR PK */
/*
INSERT INTO clientes VALUES ('12345678A', 'Luis');
*/

/* ESTO DARÍA ERROR POR NULL */
/*
INSERT INTO clientes VALUES (NULL, 'Marta');
*/


/* ============================================
   2. CLAVE PRIMARIA COMPUESTA
   ============================================ */

CREATE TABLE alquileres (
    dni VARCHAR(9),
    cod_pelicula INT,

    CONSTRAINT alquileres_pk PRIMARY KEY (dni, cod_pelicula)
);

/* INSERT CORRECTO */
INSERT INTO alquileres VALUES ('12345678A', 10);
INSERT INTO alquileres VALUES ('12345678A', 20);
INSERT INTO alquileres VALUES ('87654321B', 10);

/* ESTE DARÍA ERROR (MISMA COMBINACIÓN DE PK) */
/*
INSERT INTO alquileres VALUES ('12345678A', 10);
*/

SELECT * FROM clientes;
SELECT * FROM alquileres;
