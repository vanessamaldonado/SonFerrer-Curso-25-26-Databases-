DROP DATABASE IF EXISTS demo;
CREATE DATABASE demo;
USE demo;

CREATE TABLE IF NOT EXISTS customer (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email  VARCHAR(150) UNIQUE
);

INSERT INTO customer (nombre, email) VALUES
('Ana', 'ana@correo.com'),
('Bruno', 'bruno@correo.com');

/* =========================================================
   1.1 Gestión de usuarios en MySQL Server
   ========================================================= */

/* 1.1.1 Crear un nuevo usuario
   Lo básico es: nombre + host + contraseña
*/
CREATE USER IF NOT EXISTS 'nombre_usuario'@'localhost' IDENTIFIED BY 'contraseña';
-- Solo puede conectarse desde el propio servidor (la misma máquina donde está MySQL).

CREATE USER IF NOT EXISTS 'user_anyhost'@'%' IDENTIFIED BY 'pass_any';
-- Puede conectarse desde cualquier IP / cualquier ordenador

CREATE USER IF NOT EXISTS 'user_ip'@'172.16.0.11' IDENTIFIED BY 'pass_ip';
-- Solo puede conectarse desde esa IP exacta.

CREATE USER IF NOT EXISTS 'user_range'@'172.16.%' IDENTIFIED BY 'pass_range';
-- Puede conectarse desde cualquier IP que empiece por 172.16.

-- IF NOT EXISTS: Evita error si el usuario ya existe.
CREATE USER IF NOT EXISTS 'juan'@'localhost' IDENTIFIED BY '1234';

/*
auth_option (cómo se autentica)
- IDENTIFIED BY 'contraseña' → contraseña normal (lo más común).
- IDENTIFIED WITH auth_plugin → usar un “método” de login distinto (plugin).
- ... BY 'auth_string' → con plugin + contraseña/cadena.
- ... AS 'hash' → darle el hash ya hecho (más avanzado).
- IDENTIFIED BY PASSWORD 'hash' → no es recomendable para prácticas.
*/

/* REQUIRE ... (seguridad TLS/SSL)
   Obliga a que la conexión sea segura (cifrada) o que cumpla ciertos certificados.
*/
CREATE USER IF NOT EXISTS 'ana_ssl'@'%' IDENTIFIED BY 'x' REQUIRE SSL;

/* WITH resource_option (límites de uso)
   Evita saturar el servidor:
   - MAX_QUERIES_PER_HOUR
   - MAX_UPDATES_PER_HOUR
   - MAX_CONNECTIONS_PER_HOUR
   - MAX_USER_CONNECTIONS
*/
CREATE USER IF NOT EXISTS 'limitado'@'%' IDENTIFIED BY 'x'
WITH MAX_USER_CONNECTIONS 1 MAX_QUERIES_PER_HOUR 100;

/* password_option (caducidad de contraseña)
   - PASSWORD EXPIRE
   - PASSWORD EXPIRE NEVER
   - PASSWORD EXPIRE INTERVAL N DAY
   - PASSWORD EXPIRE DEFAULT
*/
CREATE USER IF NOT EXISTS 'empleado'@'%' IDENTIFIED BY 'x'
PASSWORD EXPIRE INTERVAL 90 DAY;

/* lock_option (bloquear/desbloquear cuenta)
   - ACCOUNT LOCK
   - ACCOUNT UNLOCK
*/
CREATE USER IF NOT EXISTS 'sospechoso'@'%' IDENTIFIED BY 'x' ACCOUNT LOCK;


/* 1.1.2 Eliminar un usuario */
DROP USER IF EXISTS 'nombre_usuario'@'localhost';


/* 1.1.3 Obtener el listado de usuarios
   (Necesitas permisos de admin/root para leer mysql.user)
*/
SELECT user, host
FROM mysql.user
ORDER BY user, host;


/* =========================================================
   1.2 Gestión de privilegios o permisos (GRANT / REVOKE / SHOW GRANTS)
   ========================================================= */

CREATE TABLE IF NOT EXISTS clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  saldo DECIMAL(10,2)
);

-- Creamos usuarios de ejemplo (y los reiniciamos)
DROP USER IF EXISTS 'ana'@'localhost';
DROP USER IF EXISTS 'luis'@'%';

CREATE USER 'ana'@'localhost' IDENTIFIED BY 'ana123';
CREATE USER 'luis'@'%' IDENTIFIED BY 'luis123';


/* Permisos a nivel servidor: *.* */
GRANT SELECT ON *.* TO 'luis'@'%';
-- Luis puede hacer SELECT en cualquier base de datos y cualquier tabla.

/* Permisos a nivel base de datos: demo.* */
GRANT SELECT, INSERT, UPDATE, DELETE ON demo.* TO 'ana'@'localhost';
-- Ana puede leer y modificar cualquier tabla dentro de demo.

/* Permisos a nivel tabla: demo.clientes */
GRANT SELECT ON demo.clientes TO 'luis'@'%';
-- Luis puede leer esa tabla concreta.

/* Permisos a nivel columna: UPDATE(saldo) */
GRANT UPDATE (saldo) ON demo.clientes TO 'ana'@'localhost';
-- Ana puede cambiar saldo, pero no otras columnas (en UPDATE).

/* Consultar permisos */
SHOW GRANTS FOR 'ana'@'localhost';
SHOW GRANTS FOR 'luis'@'%';

/* Quitar permisos (REVOKE) */
REVOKE UPDATE (saldo) ON demo.clientes FROM 'ana'@'localhost';
REVOKE SELECT ON *.* FROM 'luis'@'%';

/*
FLUSH PRIVILEGES:
- Normalmente NO es necesario si usas GRANT/REVOKE/CREATE USER en MySQL 8.0.
- Se usa sobre todo si modificas tablas del sistema “a mano” (no recomendado).
*/
-- FLUSH PRIVILEGES;


/* =========================================================
   1.3 Gestión de roles
   ========================================================= */

DROP ROLE IF EXISTS 'rol_lectura_escritura', 'rol_lectura', 'rol_escritura';
CREATE ROLE 'rol_lectura_escritura', 'rol_lectura', 'rol_escritura';

/* Asignar privilegios a roles */
GRANT ALL ON demo.* TO 'rol_lectura_escritura';
GRANT SELECT ON demo.* TO 'rol_lectura';
GRANT INSERT, UPDATE, DELETE ON demo.* TO 'rol_escritura';

/* Asignar un rol a un usuario */
GRANT 'rol_lectura' TO 'ana'@'localhost';

/*
IMPORTANTE:
SET ROLE se ejecuta en la sesión del usuario que va a usar el rol.
Si estás conectado como root, te dará error si root no tiene ese rol.
*/

-- (Opcional) hacer que el rol se active por defecto al conectar:
SET DEFAULT ROLE 'rol_lectura' TO 'ana'@'localhost';
-- o:
-- SET DEFAULT ROLE ALL TO 'ana'@'localhost';

-- Cuando te conectes como 'ana'@'localhost', puedes activar roles así:
-- SET ROLE 'rol_lectura';
-- o
-- SET ROLE ALL;


/* Quitar un rol a un usuario (corrijo el usuario inexistente) */
REVOKE 'rol_lectura' FROM 'ana'@'localhost';

/* Borrar un rol */
DROP ROLE IF EXISTS 'rol_escritura';


/* Ver todos los roles existentes
   En MySQL, los roles son “cuentas” especiales almacenadas en mysql.user
*/
SELECT user
FROM mysql.user
WHERE account_locked = 'Y'
  AND password_expired = 'Y'
  AND authentication_string = '';

/* Ver qué roles tiene un usuario */
SHOW GRANTS FOR 'ana'@'localhost';

/* Ver qué permisos tiene un rol */
SHOW GRANTS FOR 'rol_lectura';

/* Ver qué roles están activos en la sesión actual */
SELECT CURRENT_ROLE();

/* Ver roles por defecto de un usuario */
SELECT *
FROM mysql.default_roles
WHERE user = 'ana' AND host = 'localhost';

/* Fijar todos los roles como predeterminados (si los tiene concedidos) */
SET DEFAULT ROLE ALL TO 'ana'@'localhost';