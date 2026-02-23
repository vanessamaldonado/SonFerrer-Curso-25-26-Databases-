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