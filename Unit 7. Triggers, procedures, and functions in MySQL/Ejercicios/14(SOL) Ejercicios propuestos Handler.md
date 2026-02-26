# Ejercicios propuestos de Handlers

Haremos uso de la base de datos `Circo`.

## Ejercicio 1: 
Crea un procedimiento de nombre `animales_Delete` que dado el nombre de un animal, lo borre. Antes tendrá que borrar todas las tablas relacionadas. 

En el caso de que el animal tenga menos de 2 años no estará permitido borrarlo y lanzará una excepción (recordar que el código de error para excepciones definidas por el usuario es el 45000) con el texto: *No es posible dar de baja a animales con menos de dos años*. 

En el caso de que el animal no exista, deberá lanzar una excepción con el texto *'Ese animal no existe'* y un ErrorCode 1643.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS animales_delete;

DELIMITER $$

CREATE PROCEDURE animales_delete(p_nombreAnimal VARCHAR(50))
BEGIN
    DECLARE v_anos TINYINT DEFAULT -1;

    -- Si el SELECT no devuelve filas, dejamos v_anos = -1
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_anos = -1;

    SELECT anhos
      INTO v_anos
      FROM ANIMALES
     WHERE nombre = p_nombreAnimal;

    -- Animal no existe
    IF v_anos = -1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ese animal no existe',
                MYSQL_ERRNO = 1643;
    END IF;

    -- Menos de 2 años (y por seguridad, si fuese NULL también lo bloqueamos)
    IF v_anos IS NULL OR v_anos < 2 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No es posible dar de baja a animales con menos de dos años';
    END IF;

    -- Borrado por FK
    DELETE FROM ANIMALES_ARTISTAS
     WHERE nombre_animal = p_nombreAnimal;

    DELETE FROM ANIMALES
     WHERE nombre = p_nombreAnimal;
END$$

DELIMITER ;

-- Ejemploss de llamadas:
call animales_delete('no_existe');   -- Devuelve el código 1643
call animales_delete('Berni');   -- No cumple que la edad sea superior a 2 años.
call animales_delete('Princesa2');   -- Lo da de baja de todas las tablas
```
</details>

---

## Ejercicio 2:
Crea un procedimiento de nombre `animales_addArtista` al que se le pase el nombre de un animal y el nif de un artista y asigne el cuidador al animal. 

Deberá comprobar que el animal y el artista existen. En caso de que no, deberá lanzar una excepción con el ErrorCode 1643 y texto *'El animal no existe'* o *'El artista no existe'*.

En el caso de que ya exista ese artista con ese animal el propio Mysql lanzará una excepción de clave primaria duplicada.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS animales_addArtista;

DELIMITER $$

CREATE PROCEDURE animales_addArtista(p_nombreAnimal VARCHAR(50), p_nif CHAR(9))
BEGIN
    IF (SELECT COUNT(*) FROM ANIMALES WHERE nombre = p_nombreAnimal) = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El animal no existe',
                MYSQL_ERRNO = 1643;
    END IF;

    IF (SELECT COUNT(*) FROM ARTISTAS WHERE nif = p_nif) = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El artista no existe',
                MYSQL_ERRNO = 1643;
    END IF;

    INSERT INTO ANIMALES_ARTISTAS (nombre_animal, nif_artista)
    VALUES (p_nombreAnimal, p_nif);
END$$

DELIMITER ;

-- Ejemplo de llamadas:

call animales_addArtista('no_existe','11111111A'); 
call animales_addArtista('Princesa1','no_existe'); 
call animales_addArtista('Leo','33333333C'); -- Si lanzamos dos veces esta orden Mysql lanzará una excepción de clave duplicada.
```
</details>

---

### Ejercicio 3
Crea un procedimiento de nombre `animales_add` que añade un nuevo animal. En caso de intentar dar de alta un animal con el mismo nombre, captura la excepción y haz que el procedimiento devuelva (con un select) -1. En caso de que el alta sea correcta, que devuelva 0.

En el caso de que el nombre de la pista o de la atracción no exista, captura la excepción y devuelve el valor -2.

Trabaja con nombres de excepciones en vez de con los números asociados. Crea las siguientes excepciones: *ex_claveDuplicada*, *ex_pista_atracc_no_existe*

Para saber el número de excepción que tienes que capturar, provoca el fallo y anota el número.

Si provocamos los errores podemos comprobar que:
- Error 1062: Clave primaria duplicada
- Error 1452: Error de clave foránea.

Como el procedimiento sólo va a tener una orden INSERT, no hace falta hacer que salga del mismo al producirse la excepción.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS animales_add;

DELIMITER $$

CREATE PROCEDURE animales_add(
    p_nombreAnimal VARCHAR(50),
    p_tipo VARCHAR(9),
    p_anos TINYINT,
    p_peso FLOAT,
    p_estatura FLOAT,
    p_atraccion VARCHAR(50),
    p_pista VARCHAR(50)
)
BEGIN
    DECLARE ex_claveDuplicada CONDITION FOR 1062;
    DECLARE ex_pista_atracc_no_existe CONDITION FOR 1452;

    DECLARE EXIT HANDLER FOR ex_claveDuplicada
    BEGIN
        SELECT -1 AS resultado;
    END;

    DECLARE EXIT HANDLER FOR ex_pista_atracc_no_existe
    BEGIN
        SELECT -2 AS resultado;
    END;

    INSERT INTO ANIMALES (nombre, tipo, anhos, peso, estatura, nombre_atraccion, nombre_pista)
    VALUES (p_nombreAnimal, p_tipo, p_anos, p_peso, p_estatura, p_atraccion, p_pista);

    SELECT 0 AS resultado;
END$$

DELIMITER ;

-- Ejemplo de uso:
call animales_add('Leo','León',3,230,1.34,null,null);   -- Clave duplicada
call animales_add('Leo2','León',3,230,1.34,'NO EXISTE',null);   -- Atraccion que no existe

call animales_add('Leo2','León',3,230,1.34,'El gran felino','SUPER');   -- Todo correcto
```
</details>

---

## Ejercicio 4: 
Crea un procedimiento de nombre `artistas_add` que añade un nuevo artista. Se debe comprobar si el nif exista. Esta comprobación se hará capturando la excepción correspondiente. En caso de error, se mandará en un parámetro de salida el valor -1. Si todo está correcto se mandará el valor 0.

Crea un nombre de excepción: `ex_artista_duplicado.`

Junto a los datos del artista se debe enviar el nombre de un animal (debe estar previamente dado de alta) que va a cuidar el artista.

Se debe llamar al método `animales_addArtista` (creado previamente) y capturar la posible excepción que lance dicho método empleando el SQLSTATE. Si el animal no existe debe de enviar en el parámetro de salida el valor -2.

Crea un nombre de excepción: `ex_animal_no_existe.`
Cualquier excepción que se produzca debe hacer que se salga del procedimiento.

Llama al método y comprueba el valor del parámetro de salida en cada caso.


<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP PROCEDURE IF EXISTS artistas_add;

DELIMITER $$

CREATE PROCEDURE artistas_add(
    p_nif CHAR(9),
    p_apellidos VARCHAR(100),
    p_nombre VARCHAR(50),
    p_nifJefe CHAR(9),
    p_nombreAnimal VARCHAR(50),
    OUT p_resultado TINYINT
)
BEGIN
    DECLARE ex_artista_duplicado CONDITION FOR 1062;
    DECLARE ex_animal_no_existe CONDITION FOR SQLSTATE '45000';

    DECLARE EXIT HANDLER FOR ex_artista_duplicado
        SET p_resultado = -1;

    DECLARE EXIT HANDLER FOR ex_animal_no_existe
        SET p_resultado = -2;

    INSERT INTO ARTISTAS (nif, apellidos, nombre, nif_jefe)
    VALUES (p_nif, p_apellidos, p_nombre, p_nifJefe);

    CALL animales_addArtista(p_nombreAnimal, p_nif);

    SET p_resultado = 0;
END$$

DELIMITER ;

-- 1) Duplicado
CALL artistas_add('11111111A','X','Y',NULL,'Leo', @r);
SELECT @r;  -- -1

-- 2) OK
CALL artistas_add('99999999Z','Prueba','Ok',NULL,'Leo', @r);
SELECT @r;  -- 0

-- 3) Animal no existe
CALL artistas_add('99999998Z','Prueba','Fail',NULL,'NO_EXISTE', @r);
SELECT @r;  -- -2
```
</details>

---