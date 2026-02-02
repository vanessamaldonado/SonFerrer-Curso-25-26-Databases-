/* ============================================================
   TRANSACCIONES EN MYSQL
============================================================ */
USE demo_insert;  

/* ============================================================
   1. ¿Qué es una transacción?
   ------------------------------------------------------------
   Una transacción es un conjunto de instrucciones DML
   (INSERT, UPDATE, DELETE) que se ejecutan como un bloque.
   Todas deben realizarse correctamente o no se hace ninguna.

   Las transacciones garantizan:
   - Consistencia de los datos
   - Integridad
   - Posibilidad de deshacer los cambios (ROLLBACK)
   - Confirmación manual de cambios (COMMIT)
============================================================ */


/* ============================================================
   2. CONFIGURACIÓN PREVIA (evitar autocommit)
   ------------------------------------------------------------
   MySQL por defecto confirma automáticamente cada instrucción.
   Para ver el comportamiento real de las transacciones, desactivamos
   el autocommit.
============================================================ */

SET autocommit = 0;

/* ============================================================
   3. CREAR UNA TABLA DE PRUEBA PARA DEMOSTRAR TRANSACCIONES
============================================================ */

CREATE TABLE IF NOT EXISTS cuentas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titular VARCHAR(50),
    saldo DECIMAL(10,2)
);

-- Insertamos datos iniciales
INSERT INTO cuentas (titular, saldo) VALUES
('Ana', 1000),
('Luis', 500);
COMMIT; -- Guardamos estado inicial

/* ============================================================
   4. EJEMPLO PRÁCTICO 1: TRANSACCIÓN CORRECTA + COMMIT
   ------------------------------------------------------------
   Queremos transferir 200€ de Ana a Luis. Ambas instrucciones
   deben ejecutarse juntas o no ejecutarse.
============================================================ */

START TRANSACTION;

UPDATE cuentas SET saldo = saldo - 200 WHERE titular = 'Ana';
UPDATE cuentas SET salario = salario + 200 WHERE titular = 'Luis';

-- Ver resultado provisional
SELECT * FROM cuentas;

-- Confirmamos cambios
COMMIT;

SELECT * FROM cuentas;


/* ============================================================
   5. EJEMPLO PRÁCTICO 2: TRANSACCIÓN CON ERROR + ROLLBACK
   ------------------------------------------------------------
   Intentamos transferir 2000€ desde Luis (solo tiene 500€).
   Queremos cancelar todo.
============================================================ */

START TRANSACTION;

UPDATE cuentas SET saldo = saldo - 2000 WHERE titular = 'Luis';
UPDATE cuentas SET saldo = saldo + 2000 WHERE titular = 'Ana';

SELECT * FROM cuentas;

-- Cancelamos los cambios
ROLLBACK;

SELECT * FROM cuentas;


/* ============================================================
   6. ¿CUÁNDO TERMINA UNA TRANSACCIÓN AUTOMÁTICAMENTE?
   ------------------------------------------------------------
   Una transacción se cierra automáticamente cuando sucede:
============================================================ */

-- 6.1 Instrucción COMMIT → acepta la transacción
-- 6.2 Instrucción ROLLBACK → cancela la transacción

-- 6.3 Una instrucción DDL provoca COMMIT automático
--     (CREATE TABLE, ALTER TABLE...)
START TRANSACTION;

UPDATE cuentas SET saldo = saldo + 100 WHERE titular = 'Ana';

-- Esto provoca COMMIT automático:
CREATE TABLE tabla_nueva (
    id INT PRIMARY KEY
);

SELECT * FROM cuentas;

-- 6.4 Una instrucción DCL (GRANT, REVOKE) también hace COMMIT automático
-- 6.5 Cerrar sesión → transacción cancelada si no se hace COMMIT
-- 6.6 Cierre incorrecto de Workbench → ROLLBACK implícito
-- 6.7 Caída del sistema → ROLLBACK automático




/* ============================================================
   7. SAVEPOINT EN MYSQL
   ------------------------------------------------------------
   ¿Qué es un SAVEPOINT?

   SAVEPOINT permite crear un "punto de control" dentro de una
   transacción. Es decir, un marcador al que podemos volver
   sin perder toda la transacción, únicamente deshacemos lo
   que ocurrió después del SAVEPOINT.

   Permite:
   - ROLLBACK parcial
   - Mantener parte del trabajo de una transacción
   - Probar operaciones sin arriesgar todo el bloque

   Comandos:
       SAVEPOINT nombre;
       ROLLBACK TO nombre;
       RELEASE SAVEPOINT nombre;
============================================================ */


/* ============================================================
   8. EJEMPLO DE SAVEPOINT — ROLLBACK PARCIAL
   ------------------------------------------------------------
   Queremos:
   1) Quitar 100€ a Ana (operación válida)
   2) Crear SAVEPOINT paso1
   3) Quitar 5000€ a Luis (operación inválida)
   4) Deshacer solo la operación con error
   5) Conservar la operación válida
============================================================ */

START TRANSACTION;

-- Operación válida
UPDATE cuentas SET saldo = saldo - 100 WHERE titular = 'Ana';

-- Guardamos punto de control
SAVEPOINT paso1;

-- Operación incorrecta
UPDATE cuentas SET saldo = saldo - 5000 WHERE titular = 'Luis';

-- Estado provisional
SELECT 'Antes de ROLLBACK TO paso1' AS Info;
SELECT * FROM cuentas;

-- Deshacer solo lo que pasó después del SAVEPOINT
ROLLBACK TO paso1;

SELECT 'Después de ROLLBACK TO paso1' AS Info;
SELECT * FROM cuentas;

-- Confirmamos lo válido
COMMIT;

SELECT 'Estado final tras COMMIT' AS Info;
SELECT * FROM cuentas;


/* ============================================================
   9. EJEMPLO AVANZADO DE MULTIPLE SAVEPOINTS
   ------------------------------------------------------------
   1) Añadir 50€ a Ana
   2) SAVEPOINT A
   3) Añadir 100€ a Luis
   4) SAVEPOINT B
   5) Quitar 200€ a Ana
   6) ROLLBACK TO B (solo deshacer la última)
============================================================ */

START TRANSACTION;

UPDATE cuentas SET saldo = saldo + 50 WHERE titular = 'Ana';
SAVEPOINT A;

UPDATE cuentas SET saldo = saldo + 100 WHERE titular = 'Luis';
SAVEPOINT B;

UPDATE cuentas SET saldo = saldo - 200 WHERE titular = 'Ana';

SELECT 'Antes de ROLLBACK TO B' AS Info;
SELECT * FROM cuentas;

ROLLBACK TO B;

SELECT 'Después de ROLLBACK TO B' AS Info;
SELECT * FROM cuentas;

COMMIT;

