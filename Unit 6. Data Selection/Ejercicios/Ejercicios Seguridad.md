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





