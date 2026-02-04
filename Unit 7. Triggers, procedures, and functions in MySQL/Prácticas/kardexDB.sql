CREATE DATABASE IF NOT EXISTS kardex;
USE kardex;

DROP TABLE IF EXISTS kardex;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS presentacion;
DROP TABLE IF EXISTS tipo;

CREATE TABLE tipo(
  cod_tipo BIGINT AUTO_INCREMENT,
  nombre_tipo VARCHAR(20),
  CONSTRAINT tipopk PRIMARY KEY(cod_tipo)
);

INSERT INTO tipo (nombre_tipo) VALUES ('MATERIALES');
INSERT INTO tipo (nombre_tipo) VALUES ('COSMETICOS');
INSERT INTO tipo (nombre_tipo) VALUES ('CONSUMIBLES');
INSERT INTO tipo (nombre_tipo) VALUES ('MEDICAMENTOS');

CREATE TABLE presentacion(
  cod_presentacion BIGINT AUTO_INCREMENT,
  nombre_presentacion VARCHAR(20),
  CONSTRAINT presentacionpk PRIMARY KEY(cod_presentacion)
);

INSERT INTO presentacion (nombre_presentacion) VALUES ('UNIDAD');
INSERT INTO presentacion (nombre_presentacion) VALUES ('CAJA');
INSERT INTO presentacion (nombre_presentacion) VALUES ('DOCENA');
INSERT INTO presentacion (nombre_presentacion) VALUES ('QUINTAL');
INSERT INTO presentacion (nombre_presentacion) VALUES ('TONELADA');

CREATE TABLE producto(
  cod_producto BIGINT AUTO_INCREMENT,
  nombre_producto VARCHAR(50),
  cod_presentacion BIGINT,
  cod_tipo BIGINT,
  CONSTRAINT productopk PRIMARY KEY(cod_producto),
  CONSTRAINT productofk FOREIGN KEY(cod_presentacion)
    REFERENCES presentacion(cod_presentacion)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT productofk2 FOREIGN KEY(cod_tipo)
    REFERENCES tipo(cod_tipo)
    ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO producto (nombre_producto, cod_presentacion, cod_tipo) VALUES ('LAPIZ',1,2);
INSERT INTO producto (nombre_producto, cod_presentacion, cod_tipo) VALUES ('CUADERNO',1,1);
INSERT INTO producto (nombre_producto, cod_presentacion, cod_tipo) VALUES ('AZUCAR',4,1);
INSERT INTO producto (nombre_producto, cod_presentacion, cod_tipo) VALUES ('PASTA DE DIENTE',2,2);
INSERT INTO producto (nombre_producto, cod_presentacion, cod_tipo) VALUES ('MELAZA',5,1);

CREATE TABLE kardex(
  codigo BIGINT AUTO_INCREMENT,
  cod_producto BIGINT,
  tipo VARCHAR(7),
  cantidad INT,
  precio FLOAT,
  fecha_ing DATE,
  fecha_vence DATE,
  CONSTRAINT kardexpk PRIMARY KEY(codigo),
  CONSTRAINT kardexfk FOREIGN KEY(cod_producto)
    REFERENCES producto(cod_producto)
    ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (1,'ENTRADA',2,20,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (2,'ENTRADA',4,30,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (2,'ENTRADA',6,10,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (3,'ENTRADA',10,50,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (3,'ENTRADA',11,56,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (4,'ENTRADA',3,60,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (4,'ENTRADA',4,70,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (5,'ENTRADA',8,80,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (5,'ENTRADA',5,90,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (1,'ENTRADA',5,10,CURRENT_DATE,NULL);

INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (1,'SALIDA',1,20,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (2,'SALIDA',2,30,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (2,'SALIDA',1,10,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (3,'SALIDA',1,50,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (3,'SALIDA',1,56,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (4,'SALIDA',1,60,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (4,'SALIDA',2,70,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (5,'SALIDA',2,80,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (5,'SALIDA',2,90,CURRENT_DATE,NULL);
INSERT INTO kardex (cod_producto, tipo, cantidad, precio, fecha_ing, fecha_vence)
VALUES (1,'SALIDA',2,10,CURRENT_DATE,NULL);
