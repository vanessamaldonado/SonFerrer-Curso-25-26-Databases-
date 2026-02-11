/***************************************************************
**********************BLOQUE SEGURIDAD**************************
****************************************************************/
/*1. Crea usuarios y permisos para la base de datos ebanca conforme a la siguiente descripción:
     a) Usuario eb_admin, todos los permisos*/

/*   b) Usuario operador nivel 1: 
	    - acceso de lectura en todas las tablas, 
        - puede hacer modificaciones en todas las tablas, excepto el campo saldo de cuenta, y en la tabla movimiento, donde sólo puede consultar. 
        - No puede modificar la estructura de ninguna tabla.*/

/*	 c) Usuario operador nivel 2: 
         - puede consultar todas las tablas 
         - modificar la tabla cliente y cuenta, menos los campos cod_cuenta, fecha_creación y saldo.*/
         

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
--   b) Justifica el orden de las columnas en el índice.

-- 2. Ejecuta:
		EXPLAIN
		SELECT *
		FROM movimientos
		WHERE dni='12345678A'
		  AND fecha BETWEEN '2024-09-01' AND '2024-09-30'
		ORDER BY fecha DESC;

--   a) Crea el índice más eficiente.
--   b) Comprueba con EXPLAIN que el índice se usa.
--   c) Explica por qué el índice debe ser compuesto y el orden de sus columnas.

-- 3. Ejecuta:
		EXPLAIN
		SELECT c.*
		FROM cuentas c
		JOIN tiene t ON t.cod_cuenta = c.cod_cuenta
		WHERE t.dni='12345678A';

--   a) Identifica qué índices ya existen y cuáles faltan (si faltan).
--   b) Crea el/los índices necesarios (si procede) y demuestra la mejora con EXPLAIN.

-- 4. Tenemos esta consulta lenta:
		SELECT *
		FROM movimientos
		WHERE fecha >= '2024-09-01' AND fecha < '2024-10-01'
		  AND dni='12345678A';

--   a) Propón dos índices posibles:
		-- a) (dni, fecha)
		-- b) (fecha, dni)
--   b)Explica cuál sería mejor para este patrón de filtro y por qué.
--   c) Demuestra con EXPLAIN cuál usa el optimizador.

/***************************************************************
**********************BLOQUE VISTAS*****************************
****************************************************************/

/* 1. Crea una vista v_resumen_clientes que muestre dni de cliente, nombre de cliente, apellidos de cliente, número de cuentas total que tiene.
      Mostrar los clientes que no tienen ninguna cuenta.
      Haz una select de tu vista.*/

/* 2. Hacer una vista que saque la información de las cuentas con titulares: 
      Mostrar: código de cuenta, tipo, fecha de creación, saldo, y de los titulares, el dni, nombre y apellidos.
      Haz una select de tu vista.*/

/* 3. Crea una vista que devuelva el número de titulares por cuenta. Haz una select de tu vista.*/

/* 4. Crea una vista que muestre  saldo total por cliente, mostrando el dni, nombre y apellido y la suma total de su saldo.
      Mostrar todos los clientes. Haz una select que pruebe tu vista. */


/* 5. Crea una vista que muestre el dni, nombre y apellidos del cliente y el total movido por cliente (suma de movimientos).*/