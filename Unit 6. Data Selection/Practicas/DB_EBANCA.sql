/* ================================
   BASE DE DATOS: EBANCA (MySQL)
   ================================ */

-- (Opcional) borrar y crear de cero
DROP DATABASE IF EXISTS ebanca;
CREATE DATABASE ebanca
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_spanish_ci;

USE ebanca;

-- =========================
-- Tabla: CLIENTES
-- =========================
CREATE TABLE clientes (
  codigo_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
  dni            VARCHAR(12)  NOT NULL,
  nombre         VARCHAR(50)  NOT NULL,
  apellido1      VARCHAR(50)  NOT NULL,
  apellido2      VARCHAR(50)  NULL,
  direccion      VARCHAR(120) NULL,
  PRIMARY KEY (codigo_cliente),
  UNIQUE KEY uq_clientes_dni (dni)
) ;

INSERT INTO clientes (dni, nombre, apellido1, apellido2, direccion) VALUES
('12345678A','Lucia','Martinez','Gomez','C/ Gran Via 12, Madrid'),
('23456789B','Carlos','Ruiz','Santos','Av. Diagonal 210, Barcelona'),
('34567890C','Marta','Lopez','Diaz','C/ Colon 5, Valencia'),
('45678901D','Javier','Fernandez','Prieto','C/ Larios 18, Malaga'),
('56789012E','Sofia','Hernandez','Vega','C/ San Fernando 44, Sevilla'),
('67890123F','Pablo','Garcia','Molina','C/ Mayor 7, Zaragoza'),
('78901234G','Laura','Sanchez','Nunez','C/ Uria 30, Oviedo'),
('89012345H','Diego','Navarro','Iglesias','C/ Alameda 2, Bilbao'),
('90123456J','Elena','Torres','Castro','C/ Serrano 99, Madrid'),
('01234567K','Adrian','Romero','Ortega','C/ Reina 13, Murcia');

-- =========================
-- Tabla: CUENTAS
-- =========================
CREATE TABLE cuentas (
  cod_cuenta      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  saldo           DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  fecha_creacion  DATE NOT NULL,
  tipo            ENUM('ahorro','corriente','inversion') NOT NULL,
  PRIMARY KEY (cod_cuenta)
) ;

INSERT INTO cuentas (saldo, fecha_creacion, tipo) VALUES
(1500.00,'2024-01-10','corriente'),
(25000.50,'2023-11-03','inversion'),
(320.75,'2024-05-21','ahorro'),
(9800.00,'2022-09-15','corriente'),
(120.00,'2024-02-28','ahorro'),
(54000.00,'2021-06-01','inversion'),
(760.40,'2024-07-12','ahorro'),
(4300.10,'2023-03-19','corriente'),
(150.00,'2024-08-05','ahorro'),
(21000.00,'2022-12-30','inversion');


-- =========================
-- Tabla: MOVIMIENTOS
-- =========================
CREATE TABLE movimientos (
  id_movimiento INT UNSIGNED NOT NULL AUTO_INCREMENT,
  fecha         DATETIME NOT NULL,
  cantidad      DECIMAL(15,2) NOT NULL,
  dni           VARCHAR(12) NOT NULL,
  PRIMARY KEY (id_movimiento),
  KEY idx_movimientos_dni (dni),
  CONSTRAINT fk_movimientos_clientes_dni
    FOREIGN KEY (dni) REFERENCES clientes(dni)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
INSERT INTO movimientos (fecha, cantidad, dni) VALUES
('2024-09-01 10:15:00',  200.00,'12345678A'),
('2024-09-02 12:40:00',  -50.25,'12345678A'),
('2024-09-03 09:05:00', 1500.00,'23456789B'),
('2024-09-03 18:22:00', -120.00,'34567890C'),
('2024-09-04 08:10:00',  300.00,'45678901D'),
('2024-09-04 16:55:00', -999.99,'23456789B'),
('2024-09-05 11:30:00',   75.50,'56789012E'),
('2024-09-06 14:00:00',  -20.00,'67890123F'),
('2024-09-07 20:12:00',  500.00,'78901234G'),
('2024-09-08 07:45:00', -150.00,'90123456J');

-- =========================
-- Tabla: TIENE (relación N:M entre clientes y cuentas)
-- =========================
CREATE TABLE tiene (
  dni       VARCHAR(12) NOT NULL,
  cod_cuenta INT UNSIGNED NOT NULL,
  PRIMARY KEY (dni, cod_cuenta),
  KEY idx_tiene_cod_cuenta (cod_cuenta),
  CONSTRAINT fk_tiene_clientes_dni
    FOREIGN KEY (dni) REFERENCES clientes(dni)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_tiene_cuentas_cod_cuenta
    FOREIGN KEY (cod_cuenta) REFERENCES cuentas(cod_cuenta)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ;

INSERT INTO tiene (dni, cod_cuenta) VALUES
('12345678A',1),
('12345678A',3),
('23456789B',2),
('23456789B',4),
('34567890C',5),
('45678901D',6),
('56789012E',7),
('67890123F',8),
('78901234G',9),
-- cuenta compartida (dos titulares)
('90123456J',1);
