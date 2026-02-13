use ebanca;
/***************************************************************
**********************BLOQUE SEGURIDAD**************************
****************************************************************/

/*1. Crea usuarios y permisos para la base de datos ebanca conforme a la siguiente descripción:
     a) Usuario eb_admin, todos los permisos*/

		CREATE USER 'eb_admin'@'%' IDENTIFIED BY 'EbAdmin#2026!';
		GRANT ALL PRIVILEGES ON ebanca.* TO 'eb_admin'@'%';

/*    b) Usuario operador nivel 1: 
	    - acceso de lectura en todas las tablas, 
        - puede hacer modificaciones en todas las tablas, excepto el campo saldo de cuenta, 
		y en la tabla movimiento, donde sólo puede consultar. 
        - No puede modificar la estructura de ninguna tabla.*/

				-- 1) Crear usuario
				CREATE USER IF NOT EXISTS 'operador1'@'localhost'
				IDENTIFIED BY 'Operador1_Pass_2026!';

				-- 2) Lectura en todas las tablas
				GRANT SELECT ON ebanca.* TO 'operador1'@'localhost';

				-- 3) Modificaciones en todas las tablas EXCEPTO movimientos (solo consulta)
				--    Tablas: clientes, cuentas, tiene  (movimientos queda fuera)
				GRANT INSERT, UPDATE, DELETE ON ebanca.clientes TO 'operador1'@'localhost';
				GRANT INSERT, UPDATE, DELETE  ON ebanca.tiene    TO 'operador1'@'localhost';

				-- 4) En cuentas: permitir UPDATE solo de columnas NO saldo
				REVOKE INSERT, UPDATE, DELETE ON ebanca.cuentas FROM 'operador1'@'localhost';
				GRANT INSERT, UPDATE, DELETE (fecha_creacion, tipo) ON ebanca.cuentas TO 'operador1'@'localhost';
				-- 5) En movimientos: solo SELECT (ya lo tiene por el GRANT SELECT ON ebanca.*)
				--    Aseguramos que no tenga modificación
				REVOKE INSERT, UPDATE, DELETE ON ebanca.movimientos FROM 'operador1'@'localhost';

/*	   c) Usuario operador nivel 2: 
         - puede consultar todas las tablas 
         - modificar la tabla cliente y cuenta, menos los campos cod_cuenta, fecha_creación y saldo.*/

				-- 1) Crear usuario
				CREATE USER IF NOT EXISTS 'operador2'@'localhost'
				IDENTIFIED BY 'Operador2_Pass_2026!';

				-- 2) Consultar todas las tablas
				GRANT SELECT ON ebanca.* TO 'operador2'@'localhost';
				-- 3) Modificar CLIENTES (sin restricciones por campo)
				GRANT INSERT, UPDATE, DELETE ON ebanca.clientes TO 'operador2'@'localhost';

				-- 4) Modificar CUENTAS pero sin tocar cod_cuenta, fecha_creacion, saldo
				REVOKE INSERT, UPDATE, DELETE ON ebanca.cuentas FROM 'operador2'@'localhost';
				GRANT INSERT, UPDATE, DELETE (tipo) ON ebanca.cuentas TO 'operador2'@'localhost';
	

/***************************************************************
**********************BLOQUE ÍNDICES****************************
****************************************************************/

-- 1. Analiza la siguiente query:
		EXPLAIN
		SELECT dni, apellido1, apellido2, nombre
		FROM clientes
		ORDER BY apellido1, apellido2, nombre
		LIMIT 50;
--   a) Propón y crea un índice que mejore la consulta.
		CREATE INDEX idx_clientes_orden
		ON clientes (apellido1, apellido2, nombre);
--   b) Justifica el orden de las columnas en el índice.
        -- tenemos ORDER BY apellido1, apellido2, nombre LIMIT 50;
		-- lo óptimo es un índice que empiece exactamente por esas columnas y en ese orden.

-- 2. Ejecuta:
		EXPLAIN
		SELECT *
		FROM movimientos
		WHERE dni='12345678A'
		  AND fecha BETWEEN '2024-09-01' AND '2024-09-30'
		ORDER BY fecha DESC;

--   a) Crea el índice más eficiente.
		CREATE INDEX idx_mov_dni_fecha
		ON movimientos (dni, fecha);
		-- (dni, fecha) es el índice “más eficiente” para el patrón (igualdad + rango + orden por fecha). 
--   b) Comprueba con EXPLAIN que el índice se usa.
		EXPLAIN
		SELECT *
		FROM movimientos
		WHERE dni='12345678A'
		  AND fecha BETWEEN '2024-09-01' AND '2024-09-30'
		ORDER BY fecha DESC;
        -- segun el EXPLAIN :
		--	key: idx_mov_dni_fecha (o sea, el índice creado)
		--	type: range (lo correcto con BETWEEN)
		--	NO vemos Using filesort (esta bien ya que usa indice)

--   c) Explica por qué el índice debe ser compuesto y el orden de sus columnas.
        -- Compuesto porque filtra por dos columnas (dni y fecha)
		-- el orden (dni, fecha) Primero columnas con igualdad y después columnas con rango

-- 3. Ejecuta:
		EXPLAIN
		SELECT c.*
		FROM cuentas c
		JOIN tiene t ON t.cod_cuenta = c.cod_cuenta
		WHERE t.dni='12345678A';

--   a) Identifica qué índices ya existen y cuáles faltan (si faltan).
		-- Tabla tiene: PRIMARY KEY (dni, cod_cuenta), KEY idx_tiene_cod_cuenta (cod_cuenta)

--   b) Crea el/los índices necesarios (si procede) y demuestra la mejora con EXPLAIN.
         -- Para esta consulta, no es necesario si ya tienes PRIMARY KEY (dni, cod_cuenta).
         
-- 4. Tenemos esta consulta lenta:
		SELECT *
		FROM movimientos
		WHERE fecha >= '2024-09-01' AND fecha < '2024-10-01'
		  AND dni='12345678A';

--   a) Propón dos índices posibles:
		-- a) (dni, fecha)
		-- b) (fecha, dni)
        --  opción a
		CREATE INDEX idx_mov_dni_fecha2 ON movimientos (dni, fecha);

--   b)Explica cuál sería mejor para este patrón de filtro y por qué.
		-- Mejor (dni, fecha) Por qué dni='12345678A' es una condición de igualdad (reduce mucho el conjunto si hay muchos clientes).

--   c) Demuestra con EXPLAIN cuál usa el optimizador.
       -- con opcion a: EXPLAIN:
		-- key = idx_mov_dni_fecha2
		-- type range (por el rango en fecha) 
		-- rows bajo (comparado con la opcion b)

/***************************************************************
**********************BLOQUE VISTAS*****************************
****************************************************************/

/* 1. Crea una vista v_resumen_clientes que muestre dni de cliente, nombre de cliente, apellidos de cliente, número de cuentas total que tiene.
      Mostrar los clientes que no tienen ninguna cuenta.
      Haz una select de tu vista.*/
CREATE OR REPLACE VIEW v_resumen_clientes AS
SELECT
  cl.dni,
  cl.nombre,
  cl.apellido1,
  cl.apellido2,
  COUNT(t.cod_cuenta) AS num_cuentas
FROM clientes cl
LEFT JOIN tiene t ON t.dni = cl.dni
GROUP BY cl.dni, cl.nombre, cl.apellido1, cl.apellido2;

-- prueba
SELECT * FROM v_resumen_clientes
ORDER BY num_cuentas DESC;

/* 2. Hacer una vista que saque la información de las cuentas con titulares: 
      Mostrar: código de cuenta, tipo, fecha de creación, saldo, y de los titulares, el dni, nombre y apellidos.
      Haz una select de tu vista.*/
CREATE OR REPLACE VIEW v_cuentas_titulares AS
SELECT
  cu.cod_cuenta,
  cu.tipo,
  cu.fecha_creacion,
  cu.saldo,
  cl.dni,
  cl.nombre,
  cl.apellido1,
  cl.apellido2
FROM cuentas cu
JOIN tiene t ON t.cod_cuenta = cu.cod_cuenta
JOIN clientes cl ON cl.dni = t.dni;

-- Prueba
SELECT * FROM v_cuentas_titulares WHERE cod_cuenta=2;

/* 3. Crea una vista que devuelva el número de titulares por cuenta. Haz una select de tu vista.*/
CREATE OR REPLACE VIEW v_num_titulares_por_cuenta AS
SELECT
  cu.cod_cuenta,
  cu.tipo,
  COUNT(t.dni) AS num_titulares
FROM cuentas cu
LEFT JOIN tiene t ON t.cod_cuenta = cu.cod_cuenta
GROUP BY cu.cod_cuenta, cu.tipo;

-- Prueba
SELECT * FROM v_num_titulares_por_cuenta ORDER BY num_titulares DESC;

/* 4. Crea una vista que muestre  saldo total por cliente, mostrando el dni, nombre y apellido y la suma total de su saldo.
      Mostrar todos los clientes. Haz una select que pruebe tu vista. */
CREATE OR REPLACE VIEW v_saldo_total_por_cliente AS
SELECT
  cl.dni,
  cl.nombre,
  cl.apellido1,
  cl.apellido2,
  SUM(cu.saldo) AS saldo_total
FROM clientes cl
LEFT JOIN tiene t ON t.dni = cl.dni
LEFT JOIN cuentas cu ON cu.cod_cuenta = t.cod_cuenta
GROUP BY cl.dni, cl.nombre, cl.apellido1, cl.apellido2;

/* 5. Crea una vista que muestre el dni, nombre y apellidos del cliente y el total movido por cliente (suma de movimientos).*/
CREATE OR REPLACE VIEW v_total_movimientos_por_cliente AS
SELECT
  cl.dni,
  cl.nombre,
  cl.apellido1,
  cl.apellido2,
  SUM(m.cantidad) AS total_movido
FROM clientes cl
LEFT JOIN movimientos m ON m.dni = cl.dni
GROUP BY cl.dni, cl.nombre, cl.apellido1, cl.apellido2;

-- Prueba
SELECT * FROM v_total_movimientos_por_cliente ORDER BY total_movido DESC;
