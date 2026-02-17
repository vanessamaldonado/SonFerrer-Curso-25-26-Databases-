# Ejercicios propuestos de parámetros de Salida
Crea los procedimientos indicados utilizando las formas vistas y añadiendo en todos ellos un comentario de cual es su objetivo. Si no está claro, documenta también cada uno de los parámetros. Escribe un ejemplo de llamada a cada uno de los procedimientos creados.

## Ejercicio 1
Crea un procedimiento de nombre `pistas_getAforo` al que se le pase el nombre de una pista y devuelve en forma de parámetro de salida su aforo.

<details><summary>Mostrar Solución</summary>
 
```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS pistas_getAforo;
DELIMITER $$
CREATE PROCEDURE pistas_getAforo(p_nombre varchar(50), OUT p_aforo smallint)
    COMMENT 'Devuelve en p_aforo el aforo de la pista indicada por p_nombre'
BEGIN

    SELECT aforo
    INTO p_aforo
    FROM PISTAS
    WHERE nombre = p_nombre;

END$$
DELIMITER ;
```

Ejemplo de llamadas:
```sql
CALL pistas_getAforo('LATERAL1',@aforo);	
SELECT @aforo;
```
</details>

## Ejercicio 2
Crea un procedimiento de nombre `artistas_getNumAnimalesCuida` al que se le pase el nif de un artista y que devuelva en forma de parámetro de salida a cuantos animales cuida.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS artistas_getNumAnimalesCuida;
DELIMITER $$
CREATE PROCEDURE artistas_getNumAnimalesCuida(p_nif char(9), OUT p_numAnimales tinyint)		
    COMMENT 'Devuelve en p_numAnimales el número de animales que cuida el artista indicado por p_nif'
BEGIN

    SELECT COUNT(*)
    INTO p_numAnimales
    FROM ANIMALES_ARTISTAS
    WHERE nif_artista = p_nif;

END$$
DELIMITER ;
```

Ejemplo de llamadas: 
```sql
CALL artistas_getNumAnimalesCuida('11111111A',@numAnimales);	
SELECT @numAnimales;
```
</details>

## Ejercicio 3
Crea un procedimiento de nombre `animales_getNombreAforo` al que se le pase el nombre de un animal y devuelva, empleando un parámetro de salida y haciendo uso del procedimiento creado en el ejercicio 1, de una cadena con el formato: NombreAnimal:peso:pista:aforo

Pista: Emplea la función CONCAT

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS animales_getNombreAforo;
DELIMITER $$
CREATE PROCEDURE animales_getNombreAforo(p_nombre varchar(50), OUT p_cadena varchar(150))		
    COMMENT 'Devuelve en p_cadena una cadena con el formato: NombreAnimal:peso:pista:aforo en base al nombre del animal p_nombre'
BEGIN
    DECLARE v_peso float;		-- Fijarse en el tipo. Se corresponde con el tipo de la columna en ANIMALES
    DECLARE v_aforo smallint;
    DECLARE v_nombrePista varchar(50);
    
    SELECT nombre_pista,peso
    INTO v_nombrePista,v_peso
    FROM ANIMALES
    WHERE nombre = p_nombre;
    
    CALL pistas_getAforo(v_nombrePista,v_aforo);		-- El método devuelve en v_aforo el aforo de la pista
    
    SET p_cadena = CONCAT(p_nombre,':',v_peso,':',v_nombrePista,':',v_aforo);

END$$
DELIMITER ;
```

Ejemplo de llamada: 
```sql
CALL animales_getNombreAforo('Leo',@datos);	
SELECT @datos;
```
</details>

## Ejercicio 4
Crea un procedimiento de nombre `artistas_getNumAtracAnimal` al que se le pase los apellidos y nombre de un artista y devuelva, empleando un parámetro de salida, el número de atracciones en las que trabaja y el número de animales que cuida (empleando el procedimiento del ejercicio 2) con el formato: nif:NumAtracciones:NumAnimales.

Nota: Suponemos que no hay artistas con el mismo nombre y apellidos.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS artistas_getNumAtracAnimal;
DELIMITER $$
CREATE PROCEDURE artistas_getNumAtracAnimal(p_nombre varchar(45),p_apellidos varchar(100), OUT p_cadena varchar(20))		
    COMMENT 'Devuelve en p_cadena una cadena con el formato: nif:NumAtracciones:NumAnimales en base al nombre y apellidos del artista enviado en p_nombre y p_apellidos'
BEGIN
    DECLARE v_nif char(9);		
    DECLARE v_numAnimales tinyint default 0;		-- Ponemos default para en el caso de que el SELECT no encuentre el artista no apareza null
    DECLARE v_numAtracciones tinyint default 0;		-- Ponemos default para en el caso de que el SELECT no encuentre el artista no apareza null
    
    SELECT nif
    INTO v_nif
    FROM ARTISTAS
    WHERE nombre = p_nombre AND
          apellidos = p_apellidos;
          
    
    CALL artistas_getNumAnimalesCuida(v_nif,v_numAnimales);		-- El método devuelve en v_numAnimales el número de animales que cuida el artista
    SELECT COUNT(*)
    INTO v_numAtracciones
    FROM ATRACCIONES_ARTISTAS
    WHERE fecha_fin IS NULL AND
		  nif_artista = v_nif;
    
    SET p_cadena = CONCAT(v_nif,':',v_numAtracciones,':',v_numAnimales);

END$$
DELIMITER ;
```

Ejemplo de llamadas:

```sql 
CALL artistas_getNumAtracAnimal('Carlos','Perez',@datos);	
SELECT @datos;
```
</details>