# Ejercicios de Seguridad
Trabajaremos con la siguiente base de datos:

[Descargar BD SQL](world.sql)


## Enunciado:
1. Crear un usuario llamado `paco@localhost` (sin contraseña) con permisos solo de conexión y comprobar que puede conectarse.

2. Crear un usuario llamado `joan@localhost` (con contraseña joan) con permisos solo de conexión y comprobar que puede conectarse.

3. Conceder al usuario `paco@localhost` permisos de SELECT sobre la tabla world.city y verificar que el usuario paco puede consultar esa tabla.

4. Conceder al usuario `joan@localhost` permisos de SELECT, INSERT y UPDATE sobre las tablas de la base de datos world, con opción GRANT.

5. Iniciar sesión como joan y conceder permisos de SELECT sobre la tabla world.country al usuario paco.

6. Continuando conectado como joan, revocar los permisos de SELECT que paco tiene sobre la tabla world.city.

7. Iniciar sesión como root y eliminar todos los permisos que se hayan concedido a Paco y Joan.

8. Conceder a joan permisos de SELECT únicamente sobre las columnas CountryCode y Language de la tabla countrylanguage de la base de datos world.

9. Iniciar sesión como joan y ejecutar la consulta
SELECT * FROM world.countrylanguage.
¿Qué está ocurriendo?

10. Eliminar el usuario `paco@localhost`.



--- 

<details><summary>Mostrar Solución Enunciado </summary>

```sql
DROP USER IF EXISTS 'paco'@'localhost';
CREATE USER 'paco'@'localhost' IDENTIFIED BY '';
GRANT USAGE ON *.* TO 'paco'@'localhost';

-- Verificación (como root):
SHOW GRANTS FOR 'paco'@'localhost'

DROP USER IF EXISTS 'joan'@'localhost';
CREATE USER 'joan'@'localhost' IDENTIFIED BY 'joan';
GRANT USAGE ON *.* TO 'joan'@'localhost';

-- Verificación (como root):
SHOW GRANTS FOR 'joan'@'localhost';

GRANT SELECT ON world.city TO 'paco'@'localhost';
SHOW GRANTS FOR 'paco'@'localhost';

GRANT SELECT, INSERT, UPDATE ON world.* TO 'joan'@'localhost' WITH GRANT OPTION;
SHOW GRANTS FOR 'joan'@'localhost';

GRANT SELECT ON world.country TO 'paco'@'localhost';
SHOW GRANTS FOR 'paco'@'localhost';

REVOKE SELECT ON world.city FROM 'paco'@'localhost';
SHOW GRANTS FOR 'paco'@'localhost';

REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'paco'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'joan'@'localhost';

GRANT SELECT (CountryCode, Language)
ON world.countrylanguage
TO 'joan'@'localhost';

SHOW GRANTS FOR 'joan'@'localhost';

-- Si lo ejecutas como joan:
-- SELECT * FROM world.countrylanguage;
-- -> Fallará por permisos, porque joan NO tiene SELECT sobre IsOfficial y Percentage.
--
-- Esto SÍ debería funcionar como joan:
-- SELECT CountryCode, Language FROM world.countrylanguage LIMIT 10;

DROP USER IF EXISTS 'paco'@'localhost';

-- Verificación final
SELECT user, host FROM mysql.user WHERE user IN ('paco','joan');
 ```
</details>



