-- ============================================================
--  BD: compraventa (según el esquema E/R de la imagen)
--  Motor: InnoDB (FKs)
--  Charset recomendado: utf8mb4
-- ============================================================

DROP DATABASE IF EXISTS compraventa;
CREATE DATABASE compraventa
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE compraventa;

-- Por si ejecutas el script varias veces
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- TABLAS BASE
-- ============================================================

DROP TABLE IF EXISTS detalles_pedidos;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS companias_envios;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS empleados_territorios;
DROP TABLE IF EXISTS territorios;
DROP TABLE IF EXISTS regiones;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS proveedores;
DROP TABLE IF EXISTS categorias;

-- ----------------------------
-- categorias
-- ----------------------------
CREATE TABLE categorias (
  id_categoria       INT(11)      NOT NULL,
  nombre_categoria   VARCHAR(15)  NOT NULL,
  descripcion        TEXT,
  PRIMARY KEY (id_categoria)
) ENGINE=InnoDB;

-- ----------------------------
-- proveedores
-- ----------------------------
CREATE TABLE proveedores (
  id_proveedor       INT(11)      NOT NULL,
  nombre_compania    VARCHAR(50)  NOT NULL,
  nombre_contacto    VARCHAR(50),
  cargo_contacto     VARCHAR(50),
  direccion          VARCHAR(50),
  ciudad             VARCHAR(50),
  estado             VARCHAR(50),
  cod_postal         VARCHAR(20),
  pais               VARCHAR(20),
  telefono           VARCHAR(20),
  fax                VARCHAR(20),
  pagina_principal   VARCHAR(30),
  PRIMARY KEY (id_proveedor)
) ENGINE=InnoDB;

-- ----------------------------
-- regiones
-- ----------------------------
CREATE TABLE regiones (
  id_region          INT(11)      NOT NULL,
  nombre             VARCHAR(30)  NOT NULL,
  PRIMARY KEY (id_region)
) ENGINE=InnoDB;

-- ----------------------------
-- territorios
-- ----------------------------
CREATE TABLE territorios (
  id_territorio      INT(11)      NOT NULL,
  nombre             VARCHAR(50)  NOT NULL,
  id_region          INT(11)      NOT NULL,
  PRIMARY KEY (id_territorio),
  KEY idx_territorios_region (id_region),
  CONSTRAINT fk_territorios_region
    FOREIGN KEY (id_region) REFERENCES regiones(id_region)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ----------------------------
-- empleados
-- ----------------------------
CREATE TABLE empleados (
  id_empleado        INT(11)      NOT NULL,
  apellido           VARCHAR(20)  NOT NULL,
  nombre             VARCHAR(10)  NOT NULL,
  cargo              VARCHAR(30),
  tratamiento        VARCHAR(25),
  fecha_nacim        DATETIME,
  fecha_contrat      DATETIME,
  direccion          VARCHAR(60),
  ciudad             VARCHAR(15),
  region             VARCHAR(15),
  cod_postal         VARCHAR(10),
  pais               VARCHAR(15),
  tel_domicilio      VARCHAR(24),
  extension          VARCHAR(4),
  notas              TEXT,
  jefe               INT(11),
  PRIMARY KEY (id_empleado),
  KEY idx_empleados_jefe (jefe),
  CONSTRAINT fk_empleados_jefe
    FOREIGN KEY (jefe) REFERENCES empleados(id_empleado)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------
-- tabla puente: empleados_territorios (N:M)
-- ----------------------------
CREATE TABLE empleados_territorios (
  id_empleado        INT(11) NOT NULL,
  id_territorio      INT(11) NOT NULL,
  PRIMARY KEY (id_empleado, id_territorio),
  KEY idx_et_territorio (id_territorio),
  CONSTRAINT fk_et_empleado
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_et_territorio
    FOREIGN KEY (id_territorio) REFERENCES territorios(id_territorio)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------
-- clientes
-- ----------------------------
CREATE TABLE clientes (
  id_cliente         VARCHAR(5)   NOT NULL,
  nombre_compania    VARCHAR(40)  NOT NULL,
  nombre_contacto    VARCHAR(30),
  cargo_contacto     VARCHAR(30),
  direccion          VARCHAR(60),
  ciudad             VARCHAR(15),
  region             VARCHAR(15),
  cod_postal         VARCHAR(10),
  pais               VARCHAR(15),
  telefono           VARCHAR(24),
  fax                VARCHAR(24),
  PRIMARY KEY (id_cliente)
) ENGINE=InnoDB;

-- ----------------------------
-- companias_envios
-- ----------------------------
CREATE TABLE companias_envios (
  id_compania_envio  INT(11)      NOT NULL,
  nombre_compania    VARCHAR(40)  NOT NULL,
  telefono           VARCHAR(24),
  PRIMARY KEY (id_compania_envio)
) ENGINE=InnoDB;

-- ----------------------------
-- productos
-- ----------------------------
CREATE TABLE productos (
  id_producto            INT(11)       NOT NULL,
  nombre_producto        VARCHAR(50)   NOT NULL,
  id_proveedor           INT(11)       NOT NULL,
  id_categoria           INT(11)       NOT NULL,
  cantidad_por_unidad    VARCHAR(50),
  precio_unidad          DECIMAL(14,4),
  unidades_en_existencia INT(11),
  unidades_en_pedido     INT(11),
  nivel_nuevo_pedido     INT(11),
  suspendido             INT(11),
  PRIMARY KEY (id_producto),
  KEY idx_productos_proveedor (id_proveedor),
  KEY idx_productos_categoria (id_categoria),
  CONSTRAINT fk_productos_proveedor
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_productos_categoria
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ----------------------------
-- pedidos
-- Nota: en el diagrama id_cliente aparece como varchar(24),
--       pero el PK de clientes es varchar(5). Aquí lo dejo como varchar(5)
--       para que la FK sea válida.
-- ----------------------------
CREATE TABLE pedidos (
  id_pedido               INT(11)       NOT NULL,
  id_cliente              VARCHAR(5)    NOT NULL,
  id_empleado             INT(11)       NOT NULL,
  fecha_pedido            DATETIME,
  fecha_entrega           DATETIME,
  fecha_envio             DATETIME,
  id_compania_envio       INT(11)       NOT NULL,
  portes                  DECIMAL(10,4),
  destinatario            VARCHAR(50),
  direccion_destinatario  VARCHAR(50),
  ciudad_destinatario     VARCHAR(50),
  region_destinatario     VARCHAR(50),
  cod_postal_destinatario VARCHAR(10),
  pais_destinatario       VARCHAR(50),
  PRIMARY KEY (id_pedido),
  KEY idx_pedidos_cliente (id_cliente),
  KEY idx_pedidos_empleado (id_empleado),
  KEY idx_pedidos_compania (id_compania_envio),
  CONSTRAINT fk_pedidos_cliente
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_pedidos_empleado
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_pedidos_compania_envio
    FOREIGN KEY (id_compania_envio) REFERENCES companias_envios(id_compania_envio)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ----------------------------
-- detalles_pedidos (PK compuesta)
-- ----------------------------
CREATE TABLE detalles_pedidos (
  id_pedido       INT(11)      NOT NULL,
  id_producto     INT(11)      NOT NULL,
  precio_unidad   DECIMAL(6,2),
  cantidad        INT(11),
  descuento       DECIMAL(4,2),
  PRIMARY KEY (id_pedido, id_producto),
  KEY idx_dp_producto (id_producto),
  CONSTRAINT fk_dp_pedido
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_dp_producto
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;



USE compraventa;

-- =========================
-- categorias
-- =========================
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES
(1, 'Bebidas', 'Refrescos, zumos, cafés, etc.'),
(2, 'Condimentos', 'Salsas, especias, aderezos'),
(3, 'Lacteos', 'Leche, queso, yogur');

-- =========================
-- proveedores
-- =========================
INSERT INTO proveedores (
  id_proveedor, nombre_compania, nombre_contacto, cargo_contacto, direccion,
  ciudad, estado, cod_postal, pais, telefono, fax, pagina_principal
) VALUES
(1, 'Bebidas del Sur S.A.', 'Ana Ruiz', 'Ventas', 'C/ Sol 10', 'Sevilla', 'Andalucía', '41001', 'España',
 '+34 954 000 111', '+34 954 000 112', 'bebidasdelsur.es'),
(2, 'Sabores Globales', 'Luis Pérez', 'Compras', 'Av. América 22', 'Madrid', 'Madrid', '28002', 'España',
 '+34 910 000 221', NULL, 'saboresglobales.es'),
(3, 'Lácteos Sierra', 'Marta Gómez', 'Comercial', 'C/ Sierra 7', 'Granada', 'Andalucía', '18001', 'España',
 '+34 958 000 331', '+34 958 000 332', 'lacteossierra.es');

-- =========================
-- regiones
-- =========================
INSERT INTO regiones (id_region, nombre) VALUES
(1, 'Norte'),
(2, 'Centro'),
(3, 'Sur');

-- =========================
-- territorios
-- =========================
INSERT INTO territorios (id_territorio, nombre, id_region) VALUES
(101, 'Galicia', 1),
(201, 'Madrid', 2),
(301, 'Andalucía', 3);

-- =========================
-- empleados
-- =========================
INSERT INTO empleados (
  id_empleado, apellido, nombre, cargo, tratamiento, fecha_nacim, fecha_contrat,
  direccion, ciudad, region, cod_postal, pais, tel_domicilio, extension, notas, jefe
) VALUES
(1, 'Sánchez', 'Carmen', 'Directora Comercial', 'Sra.', '1980-05-12 00:00:00', '2015-03-01 00:00:00',
 'C/ Mayor 1', 'Madrid', 'Madrid', '28001', 'España', '+34 600 111 111', '1001', 'Responsable del área comercial.', NULL),
(2, 'López', 'Diego', 'Ejecutivo de Ventas', 'Sr.', '1988-09-20 00:00:00', '2018-06-15 00:00:00',
 'C/ Luna 4', 'Sevilla', 'Andalucía', '41002', 'España', '+34 600 222 222', '1002', 'Cartera Sur.', 1),
(3, 'Martín', 'Elena', 'Ejecutiva de Ventas', 'Sra.', '1990-01-30 00:00:00', '2019-01-10 00:00:00',
 'Av. Norte 8', 'A Coruña', 'Galicia', '15001', 'España', '+34 600 333 333', '1003', 'Cartera Norte.', 1);

-- =========================
-- empleados_territorios (N:M)
-- =========================
INSERT INTO empleados_territorios (id_empleado, id_territorio) VALUES
(1, 201),
(2, 301),
(3, 101);

-- =========================
-- clientes
-- =========================
INSERT INTO clientes (
  id_cliente, nombre_compania, nombre_contacto, cargo_contacto, direccion,
  ciudad, region, cod_postal, pais, telefono, fax
) VALUES
('ALFKI', 'Alfreds Futterkiste', 'María Anders', 'Propietaria', 'Obere Str. 57',
 'Berlin', 'Berlin', '12209', 'Alemania', '+49 30 007 4321', '+49 30 007 4322'),
('ANATR', 'Ana Trujillo Emparedados', 'Ana Trujillo', 'Dueña', 'Avda. Constitución 2222',
 'México D.F.', 'CDMX', '05021', 'México', '+52 55 5555 1111', NULL),
('BERGS', 'Berglunds snabbköp', 'Christina Berglund', 'Administradora', 'Berguvsvägen 8',
 'Luleå', 'Norrbotten', 'S-958 22', 'Suecia', '+46 920 123 456', '+46 920 123 457');

-- =========================
-- companias_envios
-- =========================
INSERT INTO companias_envios (id_compania_envio, nombre_compania, telefono) VALUES
(1, 'Speedy Express', '+34 900 111 222'),
(2, 'United Package', '+34 900 222 333'),
(3, 'Federal Shipping', '+34 900 333 444');

-- =========================
-- productos
-- =========================
INSERT INTO productos (
  id_producto, nombre_producto, id_proveedor, id_categoria, cantidad_por_unidad,
  precio_unidad, unidades_en_existencia, unidades_en_pedido, nivel_nuevo_pedido, suspendido
) VALUES
(1, 'Té Verde 250g', 2, 2, '20 bolsas x caja', 6.5000, 120, 10, 20, 0),
(2, 'Refresco Naranja 330ml', 1, 1, '24 latas x caja', 1.2000, 500, 50, 100, 0),
(3, 'Queso Curado 1kg', 3, 3, '1 pieza', 14.9900, 80, 5, 15, 0);

-- =========================
-- pedidos
-- =========================
INSERT INTO pedidos (
  id_pedido, id_cliente, id_empleado, fecha_pedido, fecha_entrega, fecha_envio,
  id_compania_envio, portes, destinatario, direccion_destinatario, ciudad_destinatario,
  region_destinatario, cod_postal_destinatario, pais_destinatario
) VALUES
(1001, 'ALFKI', 2, '2026-01-10 10:15:00', '2026-01-18 00:00:00', '2026-01-12 16:00:00',
 1, 12.5000, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', 'Berlin', '12209', 'Alemania'),
(1002, 'ANATR', 1, '2026-02-05 09:00:00', '2026-02-12 00:00:00', '2026-02-06 14:30:00',
 2, 20.0000, 'Ana Trujillo', 'Avda. Constitución 2222', 'México D.F.', 'CDMX', '05021', 'México'),
(1003, 'BERGS', 3, '2026-02-15 11:45:00', '2026-02-22 00:00:00', '2026-02-16 10:10:00',
 3, 15.7500, 'Berglunds snabbköp', 'Berguvsvägen 8', 'Luleå', 'Norrbotten', 'S-958 22', 'Suecia');

-- =========================
-- detalles_pedidos
-- =========================
INSERT INTO detalles_pedidos (id_pedido, id_producto, precio_unidad, cantidad, descuento) VALUES
(1001, 2, 1.20, 48, 0.00),
(1001, 1, 6.50, 10, 0.05),
(1002, 3, 14.99, 8, 0.10),
(1003, 2, 1.20, 24, 0.00),
(1003, 3, 14.99, 3, 0.00);
