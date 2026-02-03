# 02 Ejercicios propuestos de Procedures.
Notas:
- Probar a crear los procedimientos de diferentes formas: directamente en una pestaña SQL o a través del asistente de MysqlWorkBench.
- Después de crear el procedimiento llámalo.
- Crea cada procedimiento con un pequeño comentario de su objetivo.
- En caso de que no se indique ordenación, establecer vosotros mismos un criterio de ordenación.

---

## Ejercicio 1
Crea un procedimiento de nombre `artistas_getList()´ que devuelva el nombre y apellidos de los artistas separados por coma con el formato: 
apellidos,nombre ordenados de forma descendente.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS artistas_getList;

DELIMITER $$

CREATE PROCEDURE artistas_getList()
COMMENT 'Devuelve el nombre completo de todos los artistas ordenado descendentemente'
BEGIN
    SELECT CONCAT(apellidos,',',nombre) as nombreCompleto
    FROM ARTISTAS
    ORDER BY nombreCompleto DESC;

END$$

DELIMITER ;
```

</details>

## Ejercicio 2
Crea un procedimiento de nombre `artistas_getListAnimales()` que devuelva los nombres de los artistas junto con su nif así como el nombre y peso 
de los animales que están atendidos por los artistas, ordenados por nif del artista y nombre del animal.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS artistas_getListAnimales;

DELIMITER $$

CREATE PROCEDURE artistas_getListAnimales()
COMMENT 'Devuelve el nombre, apellidos y nif de los artistas junto con el nombre y peso de los animales que atienden'
BEGIN
    SELECT nif, apellidos, ARTISTAS.nombre as nombreArtista, ANIMALES.nombre as nombreAnimal, peso
    FROM ARTISTAS INNER JOIN ANIMALES_ARTISTAS ON (ANIMALES_ARTISTAS.nif_artista=ARTISTAS.nif)
				  INNER JOIN ANIMALES ON (ANIMALES_ARTISTAS.nombre_animal=ANIMALES.nombre)
    ORDER BY nif, nombreAnimal;

END$$

DELIMITER ;
```

</details>

## Ejercicio 3
Crea un procedimiento de nombre `atracciones_getListConAntiguedad5()` que devuelva los datos de las atracciones que hayan comenzado hace 5 años con 
respecto a la fecha actual. Tendrás que hacer uso de alguna de las funciones Date Time. Intenta averiguar cual.

Fijarse que este procedimiento es un buen candidato para emplear un parámetro en donde indiquemos el número de años. 
Lo veremos después cuando expliquemos el paso de datos por parámetros.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS atracciones_getListConAntiguedad5;
DELIMITER $$

CREATE PROCEDURE atracciones_getListConAntiguedad5()
COMMENT 'Devuelve todos los datos de las atracciones que comenzaran hace 5 años con respecto a la fecha actual'
BEGIN
    SELECT *
    FROM ATRACCIONES
    WHERE fecha_inicio BETWEEN DATE_SUB(curdate(), INTERVAL 5 YEAR) AND  curdate()
    ORDER BY nombre;

END$$

DELIMITER ;
```

</details>

## Ejercicio 4
Crea un procedimiento de nombre `animales_Leo_getPista()` que muestre los datos de la pista donde trabaja el animal de nombre 'Leo'. 
Hacerlo empleando una variable local que guarde el nombre de la pista. Después consultar los datos de la pista empleando dicha variable local.

Fijarse que este procedimiento es un buen candidato para emplear un parámetro en donde indiquemos el nombre del animal. 
Lo veremos después cuando expliquemos el paso de datos por parámetros.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS animales_Leo_getPista;
DELIMITER $$

CREATE PROCEDURE animales_Leo_getPista()
COMMENT 'Devuelve los datos de la pista donde trabaja el animal de nombre Leo'
BEGIN
	DECLARE v_nombrePista varchar(50) default '';	-- El tipo y tamaño debe de coincidir con el declarado en la tabla. Si no podemos nada, el valor por defecto es NULL

    SELECT nombre_pista
    INTO v_nombrePista
    FROM ANIMALES
    WHERE nombre = 'Leo';
    
    
    SELECT *            -- Devuelve una única fila. No hace falta order by
    FROM PISTAS
    WHERE nombre=v_nombrePista;
    

END$$

DELIMITER ;
```
Línea 8: Fijarse que está declarada como varchar(50) que se corresponde al tipo de dato y tamaño de la columna nombre de la tabla PISTAS.
Se le da un valor por defecto. Esto es opcional, pero tenéis que tener en cuenta que si la orden SELECT no encuentra dato, no se realiza la parte INTO y por tanto a la salida de la orden SELECT la variable tendrá el valor por defecto. Cuando veremos la sentencia IF veremos que usaremos el valor por defecto para comprobar si queremos que siga ejecutando el procedimiento o salga del mismo.
</details>

