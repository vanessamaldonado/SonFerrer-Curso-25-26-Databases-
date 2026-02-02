/* ============================================================
   CASE, IF(), IFNULL(), NULLIF()
   ============================================================ */
CREATE DATABASE IF NOT EXISTS ejemplo_mysql;
USE ejemplo_mysql;

/* Tabla de pruebas */
DROP TABLE IF EXISTS personas;
CREATE TABLE personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    edad INT,
    telefono VARCHAR(20)
);

INSERT INTO personas (nombre, edad, telefono) VALUES
('Ana', 15, NULL),
('Luis', 20, '555-100'),
('Marta', 70, NULL),
('Carlos', 33, '555-200');


/* ============================================================
   1. CASE — múltiples condiciones
   ============================================================ */
/*
CASE permite realizar comparaciones del tipo:
- IF
- ELSE IF
- ELSE

Sintaxis:
CASE
    WHEN condición1 THEN resultado1
    WHEN condición2 THEN resultado2
    ELSE resultado_por_defecto
END
*/

SELECT 
    nombre,
    edad,
    CASE
        WHEN edad < 18 THEN 'Menor'
        WHEN edad BETWEEN 18 AND 64 THEN 'Adulto'
        ELSE 'Mayor'
    END AS categoria
FROM personas;


/* ============================================================
   2. IF() — condición simple IF / ELSE
   ============================================================ */
/*
IF(condición, valor_si_verdadero, valor_si_falso)
*/

SELECT 
    nombre,
    edad,
    IF(edad >= 18, 'Puede votar', 'No puede votar') AS derecho_voto
FROM personas;


/* ============================================================
   3. IFNULL() — reemplazar valores NULL
   ============================================================ */
/*
IFNULL(valor, valor_si_es_null)
Devuelve el valor si NO es NULL, si es NULL devuelve el segundo argumento.
*/

SELECT 
    nombre,
    IFNULL(telefono, 'Sin teléfono registrado') AS telefono_mostrado
FROM personas;


/* ============================================================
   4. NULLIF() — devuelve NULL si ambos argumentos son iguales
   ============================================================ */
/*
NULLIF(valor1, valor2)
Si valor1 = valor2 → devuelve NULL
Si valor1 != valor2 → devuelve valor1
*/

SELECT NULLIF(5, 5) AS resultado1;   -- NULL
SELECT NULLIF(5, 3) AS resultado2;   -- 5

/* Caso práctico: evitar división por cero */
DROP TABLE IF EXISTS ventas;
CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    total DOUBLE,
    cantidad INT
);

INSERT INTO ventas (total, cantidad) VALUES
(100, 5),
(50, 1),
(10, 0);

SELECT 
    total,
    cantidad,
    total / NULLIF(cantidad, 0) AS total_por_unidad
FROM ventas;
