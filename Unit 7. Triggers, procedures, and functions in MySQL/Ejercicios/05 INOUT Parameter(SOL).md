# Ejercicios propuestos de parámetros de Entrada/Salida

Crea los procedimientos indicados utilizando las formas vistas y añadiendo en todos ellos un comentario de cual es su objetivo. Si no está claro, documenta también cada uno de los parámetros. Escribe un ejemplo de llamada a cada uno de los procedimientos creados.

## Ejercicio 1
Crea un procedimiento de nombre `pistas_addAforo` al que se le envíe como parámetros el nombre de la pista y una cantidad que representa el incremento del aforo.

El procedimiento debe devolver en el mismo parámetro el nuevo aforo de la pista.
Nota: Aún no vimos el uso de IF pero en este método habría que tener en cuenta si el aforo es superior al rango de un smallint...

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS pistas_addAforo;
DELIMITER $$
CREATE PROCEDURE pistas_addAforo(p_nombre varchar(50),INOUT p_incAforo smallint)		-- El parámetro tiene que ser smallint ya que lo usamos para guardar el aforo
    COMMENT 'Devuelve en p_incAforo el nuevo aforo incrementado en la pista p_nombre'
BEGIN
	UPDATE PISTAS
    SET aforo = aforo + p_incAforo
    WHERE nombre = p_nombre;
    
    SELECT aforo
    INTO p_incAforo
    FROM PISTAS
    WHERE nombre = p_nombre;

END$$
DELIMITER ;
```

Ejemplo de uso:
```sql
SET @dato = 50;	-- Incremento de aforo
CALL pistas_addAforo('LATERAL1',@dato);	
SELECT @dato;
```
</details>

## Ejercicio 2
Crea un procedimiento de nombre `artistas_getNombreCompleto` al que se le pase como parámetro el nif y devuelva en el mismo parámetro el nombre completo con el formato: apellidos, nombre

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS artistas_getNombreCompleto;
DELIMITER $$
CREATE PROCEDURE artistas_getNombreCompleto(INOUT p_dato varchar(147))		-- varchar(145) porque es el tamaño de nombre+apellidos mas la coma y el espacio en blanco
    COMMENT 'Devuelve el nombre y apellidos con el formato apellidos, nombre. p_dato tiene el nif del artista y se modifica con el nombre y apellidos'
BEGIN
    
    SELECT CONCAT(apellidos,', ',nombre)
    INTO p_dato
    FROM ARTISTAS
    WHERE nif = p_dato;

END$$
DELIMITER ;
```

Ejemplo de uso: 
```sql
SET @dato = '11111111A';	
CALL artistas_getNombreCompleto(@dato);	
SELECT @dato;
```
</details>

## Ejercicio 3
Crea un procedimiento de nombre `animales_addAforo` al que se le envíe como parámetros el nombre del animal y el incremento del aforo en la pista en la que trabaja el animal. Debe de hacer uso del procedimiento creado en el ejercicio 1 y debe de devolver empleando los dos parámetros anteriores, el nombre de la pista y su nuevo aforo.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS animales_addAforo;
DELIMITER $$
CREATE PROCEDURE animales_addAforo(INOUT p_nombre varchar(50),INOUT p_aforo SMALLINT)		
    COMMENT 'Devuelve el nombre de la pista y el nuevo aforo en el que trabaja el animal. p_nombre indica el nombre del animal p_aforo indica el incremento del aforo'
BEGIN
    
    SELECT nombre_pista
    INTO p_nombre
    FROM ANIMALES
    WHERE nombre = p_nombre;
    
    CALL pistas_addAforo(p_nombre, p_aforo);
END$$
DELIMITER ;
```

Ejemplo de uso:
```sql 
SET @nombre = 'Princesa1';
SET @aforo = 10;

CALL animales_addAforo(@nombre,@aforo);	
SELECT @nombre,@aforo;
```

</details>