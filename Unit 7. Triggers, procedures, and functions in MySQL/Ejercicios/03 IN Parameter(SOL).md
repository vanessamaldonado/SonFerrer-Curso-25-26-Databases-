# Ejercicios IN Parameter

Crea los procedimientos indicados utilizando las formas vistas y añadiendo en todos ellos un comentario de cual es su objetivo. Si no está claro, documenta también cada uno de los parámetros.

## Ejercicio 1: 
Crea un procedimiento de nombre `artistas_getAnimalesPorNif` que devuelva los animales que cuida un artista. Llevará como parámetro el nif de artista.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS artistas_getAnimalesPorNif;
DELIMITER $$

CREATE PROCEDURE artistas_getAnimalesPorNif(p_nif char(9))
COMMENT 'Devuelva los animales que cuida un artista. Llevará como parámetro el nif de artista.'
BEGIN
	SELECT distinct ANIMALES_ARTISTAS.*
    FROM ANIMALES_ARTISTAS
	WHERE ANIMALES_ARTISTAS.nif_artista = p_nif
    ORDER BY nombre_animal;            
END$$
DELIMITER ;
```
Ejemplos de llamadas:
```sql
CALL artistas_getAnimalesPorNif('11111111A');
CALL artistas_getAnimalesPorNif('22222222B');

SET @nifBuscar='44444444D';
CALL artistas_getAnimalesPorNif(@nifBuscar);
```
</details>

## Ejercicio 2: 
Crea un procedimiento de nombre `artistas_getAnimalesPorNombreApel` que devuelva los animales que cuida un artista. Llevará como parámetro el nombre y apellidos del artista. Suponemos que el nombre y apellidos conforman una clave alternativa.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS artistas_getAnimalesPorNombreApel;
DELIMITER $$

CREATE PROCEDURE artistas_getAnimalesPorNombreApel(p_nombre varchar(45),p_apellidos varchar(100))	-- Fijarse en el tipo de dato y tamaño que coincide con el definido en la tabla
COMMENT 'Devuelva los animales que cuida un artista. Llevará como parámetro el nombre y apellidos del artista'
BEGIN
	DECLARE v_nifArtista char(9);		-- Si no ponemos valor por defecto vale null
    
    SELECT nif 
    INTO v_nifArtista
    FROM ARTISTAS 
    WHERE apellidos = p_apellidos AND
          nombre = p_nombre;
	-- LIMIT 1;		Tendríamos que poner LIMIT 1 para poder emplear INTO en el caso de que hubiera varias personas con el mismo nombre y apellidos
          
	SELECT distinct ANIMALES.*   -- Se podría emplear IN sobre animales_artistas
    FROM ANIMALES INNER JOIN ANIMALES_ARTISTAS
					ON (ANIMALES.nombre = ANIMALES_ARTISTAS.nombre_animal)
	WHERE ANIMALES_ARTISTAS.nif_artista = v_nifArtista
    ORDER BY nombre;            
END$$
DELIMITER ;
```
Ejemplo de llamada:
```sql
CALL artistas_getAnimalesPorNombreApel('Luis','Sanchez');
```
</details>

## Ejercicio 3: 
Crea un procedimiento de nombre `atracciones_getListConAntiguedad` que devuelva los datos de las atracciones que hayan comenzado hace un número de años con respecto a la fecha actual. Tendrás que hacer uso de alguna de las funciones Date Time. Intenta averiguar cual.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS atracciones_getListConAntiguedad;
DELIMITER $$

CREATE PROCEDURE atracciones_getListConAntiguedad(p_antiguedad tinyint)	-- Fijarse en el tipo. No hace falta poner un int.
    COMMENT 'Dvuelva los datos de las atracciones que hayan comenzado hace un número de años con respecto a la fecha actual.'
BEGIN
    SELECT *
    FROM ATRACCIONES
    WHERE fecha_inicio BETWEEN DATE_SUB(curdate(), INTERVAL p_antiguedad YEAR) AND  curdate()
    ORDER BY nombre;

END$$
DELIMITER ;
```

Ejemplo de llamadas:
```sql
CALL atracciones_getListConAntiguedad(4);
CALL atracciones_getListConAntiguedad(20);
```
</details>

## Ejercicio 4: 
Crea un procedimiento de nombre `artistas_getListMasAnimalesCuida` que devuelva los datos del/os artista/s que cuidan a más animales de los indicados (parámetro que se le envía).
Pista: Como la consulta puede devolver más de un artista no podremos hacer uso de INTO....

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS artistas_getListMasAnimalesCuida;
DELIMITER $$

CREATE PROCEDURE artistas_getListMasAnimalesCuida(p_numAnimales tinyint)	-- Fijarse en el tipo. No hace falta poner un int.
    COMMENT 'Devuelve los datos del/os artista/s que cuida a más animales de los indicados. p_numAnimales: indica a cuantos animales tiene que cuidad el artista para salir en el listado'
BEGIN
    SELECT *
    FROM ARTISTAS
    WHERE nif IN (SELECT nif_artista
		  FROM ANIMALES_ARTISTAS
		  GROUP BY nif_artista
		  HAVING COUNT(*) > p_numAnimales)
    ORDER BY nif;

END$$
DELIMITER ;
```

Ejemplos de llamadas:
```sql
CALL artistas_getListMasAnimalesCuida(2);
```
</details>

## Ejercicio 5: 
Crea un procedimiento de nombre `atracciones_getListPorFecha` que devuelva los datos de las atracciones que han comenzado a partir de la fecha indicada.
Pista: Recordar que las fechas son tratadas como cadenas...y tener en cuenta el formato.
Añade una nueva atracción con la fecha de inicio actual.
Llama al procedimiento empleando la fecha actual menos 3 días (haz uso de la función DATE_SUB y curdate)

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS atracciones_getListPorFecha;
DELIMITER $$

CREATE PROCEDURE atracciones_getListPorFecha(p_fecha char(10))	-- Fijarse en el tipo. aaaa-mm-dd
    COMMENT 'Devuelve los datos de las atracciones que han comenzado a partir de la fecha indicada. p_fecha: Formato aaaa-mm-dd'
BEGIN
	SELECT *
    FROM ATRACCIONES
    WHERE fecha_inicio > p_fecha
	ORDER BY nombre;

END$$
DELIMITER ;
```

Ejemplo de llamadas:
```sql
CALL atracciones_getListPorFecha('2001-01-01');
CALL atracciones_getListPorFecha(DATE_SUB(curdate(), INTERVAL 3 DAY));
```
</details>

## Ejercicio 6: 
Crea un procedimiento de nombre `pistas_add` y que añada una nueva pista.
Nota: Aún no vimos la validación de datos que tendría que darse en el paso de parámetros. En este caso podríamos tener condiciones if en el que se comprueba sin el aforo es mayor que cero....
Se puede hacer uso de la función `ROW_COUNT()` para saber cuantas filas fueron añadidas, borradas o modificadas.
Importante: Los parámetros deben de tener el mismo tipo de dato y tamaño que el que está definido a nivel de columnas en la tabla PISTAS.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS pistas_add;
DELIMITER $$

CREATE PROCEDURE pistas_add(p_nombre varchar(50),p_aforo smallint)	-- Fijarse en el tipo de dato. Se corresponde con las columnas de la tabla PISTAS
    COMMENT 'Añade una nueva pista'
BEGIN
    INSERT INTO PISTAS (nombre, aforo)		-- Mejor poner las columnas, ya que si modificamos la estructura de la tabla, la orden sigue funcionando
    VALUES (p_nombre,p_aforo);
    
    SELECT ROW_COUNT();

END$$
DELIMITER ;
```
Ejemplo de llamada: 
```sql
CALL pistas_add('El gran misil',134);
```
</details>

## Ejercicio 7: 
Crea un procedimiento de nombre `atracciones_update` que permita modificar los datos de una atracción (no se permite actualizar su clave primaria).
Modifica la fecha de inicio de la atracción 'El gran felino' y ponla un día después de la que tiene ahora mismo.
Pista: Tendrás que guardar las ganancias y la fecha de inicio que tiene para poder enviar ese dato al procedimiento.
Comprueba como al llamar al método con una atracción que no existe, row_count va a devolver 0.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS atracciones_update;
DELIMITER $$

CREATE PROCEDURE atracciones_update(p_nombre varchar(50),p_fecha date, p_ganancias decimal(8,2))	-- Fijarse en el tipo de dato. Se corresponde con las columnas de la tabla ATRACCIONES
    COMMENT 'Modifica una atracción'
BEGIN

	UPDATE ATRACCIONES
    SET fecha_inicio = p_fecha,
        ganancias = p_ganancias
	WHERE nombre = p_nombre;
    
    SELECT ROW_COUNT();

END$$
DELIMITER ;
```

Ejemplo de llamadas:
```sql
SELECT ganancias,fecha_inicio
INTO @ganancias,@fecha_inicio
FROM ATRACCIONES
WHERE nombre = 'El gran felino';
CALL atracciones_update('El gran felino',DATE_ADD(@fecha_inicio,INTERVAL 1 DAY),@ganancias);


CALL atracciones_update('El gran felino_no_existe','1890-01-03',1000.34);
```
</details>

## Ejercicio 8: 
Crea un procedimiento de nombre `pistas_delete` que borre una pista por su nombre. Haz que borre en base al patrón nombre% (empleando el Like).
Borra la atracción que hayas añadido en el ejercicio 6 mandando las primeras letras (ten cuidado de que no haya otra atracción con esas letras al comienzo).
Pista: Emplea la función CONCAT para el LIKE

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS pistas_delete;
DELIMITER $$

CREATE PROCEDURE pistas_delete(p_nombre varchar(50))	-- Fijarse en el tipo de dato. Se corresponde con las columnas de la tabla PISTAS
    COMMENT 'Borra una pista'
BEGIN

    DELETE FROM PISTAS
    WHERE nombre LIKE CONCAT(p_nombre,'%');
    
    SELECT ROW_COUNT();

END$$
DELIMITER ;
```

Ejemplos de Llamadas:
```sql
CALL pistas_delete('El gran m');		-- Yo había añadido una de nombre El gran misil
```

</details>