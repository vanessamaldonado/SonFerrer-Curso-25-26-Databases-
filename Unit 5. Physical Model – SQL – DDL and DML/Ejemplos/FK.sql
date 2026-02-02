/* ============================================
   CLAVE FORANEA EN MYSQL
   ============================================ */

DROP DATABASE IF EXISTS bd_fk;
CREATE DATABASE bd_fk;
USE bd_fk;

/* ============================================
   TABLAS PRINCIPALES
   ============================================ */

CREATE TABLE clientes (
    dni VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE peliculas (
    cod INT PRIMARY KEY,
    titulo VARCHAR(50)
);

/* ============================================
   TABLA CON CLAVES FORANEAS
   ============================================ */

CREATE TABLE alquileres (
    dni VARCHAR(9),
    cod_pelicula INT,

    CONSTRAINT alquileres_pk PRIMARY KEY (dni, cod_pelicula),

    CONSTRAINT alquileres_fk1 FOREIGN KEY (dni)
        REFERENCES clientes(dni)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT alquileres_fk2 FOREIGN KEY (cod_pelicula)
        REFERENCES peliculas(cod)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ;

/* ============================================
   INSERTS CORRECTOS
   ============================================ */

INSERT INTO clientes VALUES ('12345678A', 'Ana');
INSERT INTO peliculas VALUES (10, 'Matrix');

INSERT INTO alquileres VALUES ('12345678A', 10);

/* ============================================
   ESTE INSERT DA ERROR (NO EXISTE CLIENTE)
   ============================================ */
-- INSERT INTO alquileres VALUES ('99999999X', 10);

/* ============================================
   BORRADO EN CASCADA
   ============================================ */

DELETE FROM peliculas WHERE cod = 10;

/* ============================================
   COMPROBACION
   ============================================ */

SELECT * FROM alquileres;
