# **Ejercicios propuestos Funciones**
Haremos uso de la BD `Circo`.


### **Ejercicio 1:**

Crea una función de nombre `utilidades_getMesEnLetra` a la que se le pase un número y devuelva el nombre del mes. En caso de que el número no se corresponda con ningún mes, debe devolver null.

Fijarse que esta función es determinista.
Llama a la función directamente y guarda el resultado en una variable de sesión.
Llama a la función para que muestre los meses en letra en los que se celebró la atracción 'El gran felino'.
Llama a la función para que muestre las atracciones que se celebraron en ABRIL (busca por la cadena ABRIL) (recuerda hacer uso de COLLATE).
Nota: Indicar que Mysql ya dispone de dicha función, a la que se le pasa una fecha y devuelve el mes en forma de cadena: monthname()

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP FUNCTION IF EXISTS utilidades_getMesEnLetra;

DELIMITER $$
CREATE FUNCTION utilidades_getMesEnLetra (p_mes tinyint)
RETURNS VARCHAR(10) DETERMINISTIC NO SQL
    COMMENT 'Devuelve el mes en letra que se corresponde con el número de mes'
BEGIN
	DECLARE v_mesEnLetra varchar(10);		-- Valor por defecto NULL

	CASE p_mes
		WHEN 1 THEN SET v_mesEnLetra = 'ENERO';
		WHEN 2 THEN	SET v_mesEnLetra = 'FEBRERO';
		WHEN 3 THEN SET v_mesEnLetra = 'MARZO';
		WHEN 4 THEN SET v_mesEnLetra = 'ABRIL';
		WHEN 5 THEN SET v_mesEnLetra = 'MAYO';
		WHEN 6 THEN SET v_mesEnLetra = 'JUNIO';
		WHEN 7 THEN SET v_mesEnLetra = 'JULIO';
		WHEN 8 THEN SET v_mesEnLetra = 'AGOSTO';
		WHEN 9 THEN SET v_mesEnLetra = 'SEPTIEMBRE';
		WHEN 10 THEN SET v_mesEnLetra = 'OCTUBRE';
		WHEN 11 THEN SET v_mesEnLetra = 'NOVIEMBRE';
		WHEN 12 THEN SET v_mesEnLetra = 'DICIEMBRE';
           ELSE '';
	END CASE;
	
	RETURN v_mesEnLetra;
END $$
DELIMITER ;

SET @mes = utilidades_getMesEnLetra(10);
SELECT @mes;

SELECT DISTINCT MONTH(fecha) as mesNumero, utilidades_getMesEnLetra(MONTH(fecha)) as mesCadena
FROM ATRACCION_DIA
WHERE nombre_atraccion='El gran felino'
ORDER BY mesNumero;

SELECT *
FROM ATRACCION_DIA
WHERE utilidades_getMesEnLetra(MONTH(fecha)) = 'ABRIL' COLLATE 'utf8mb4_spanish2_ci'
ORDER BY nombre_atraccion, fecha;
```

</details>

---

### **Ejercicio 2:**

Crea una función de nombre `animales_getEstadoPorAnhos` que devuelva la cadena:

Si tipo = León

    - anhos < 2: 'JOVEN'
	- anhos >=2 y <=5: 'MADURO'
	- anhos > 5: 'VIEJO'

Cualquier otro tipo:

    - anhos < 1: 'JOVEN'
	- anhos >=1 y <=3: 'MADURO'
	- anhos > 3: 'VIEJO'

Llama a la función para mostrar el estado por años de cada uno de los animales del CIRCO.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP FUNCTION IF EXISTS animales_getEstadoPorAnhos;
DELIMITER $$
CREATE FUNCTION animales_getEstadoPorAnhos (p_tipo varchar(9), p_anhos tinyint)	-- El tipo se corresponde con el de la tabla
RETURNS CHAR(6)	DETERMINISTIC NO SQL
    COMMENT 'Devuelve una cadena indicativa de la edad en función de la edad y tipo de animal'
BEGIN
	DECLARE v_cadena char(6) default '';

	IF (p_tipo='León') THEN
		CASE 
			WHEN p_anhos < 2 THEN SET v_cadena = 'JOVEN';
			WHEN p_anhos >= 2 AND p_anhos <= 5 THEN SET v_cadena = 'MADURO';
			WHEN p_anhos > 5 THEN SET v_cadena = 'VIEJO';
		END CASE;
    ELSE
		CASE
			WHEN p_anhos < 1 THEN SET v_cadena = 'JOVEN';
			WHEN p_anhos >= 1 AND p_anhos <= 3 THEN SET v_cadena = 'MADURO';
			WHEN p_anhos > 3 THEN SET v_cadena = 'VIEJO';
		END CASE;
    END IF;

	RETURN v_cadena;
END $$
DELIMITER ;

SELECT *,animales_getEstadoPorAnhos(tipo,anhos) as estado
FROM ANIMALES
ORDER BY nombre;
```

</details>

---

### **Ejercicio 3:**

Crea una función de nombre `pistas_getDiferenciaAforo` al que se le pase el nuevo aforo de una pista y devuelva la diferencia entre el aforo nuevo y el aforo anterior.

- Si la diferencia < 100 debe devolver la cadena 'PEQUEÑA menor que 100'
- Si la diferencia está entre 100 y 500 debe devolver la cadena 'REGULAR entre 100 y 500'
- Si la diferencia > 500 debe devolver la cadena 'ABISMAL mayor que 500'. Por ejemplo: PISTA1, 150 => Si la pista tiene actualmente un aforo de 100, debe devolver 150-100 = 50 => PEQUEÑA menor que 100
- Si la pista no existe debe devolver null.

Acordaos de añadir los modificadores adecuados a la creación de la función.

Muestra los datos de todas las pistas junto la diferencia del aforo empleando la función anterior y enviando un aforo de 600.

Muestra las pistas que tengan una diferencia ABISMAL (busca la cadena con la función INSTR con un aforo propuesto de 1000.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DROP FUNCTION IF EXISTS pistas_getDiferenciaAforo;

DELIMITER $$
CREATE FUNCTION pistas_getDiferenciaAforo (p_nombrePista varchar(50), p_aforo smallint)	-- El tipo se corresponde con el de la tabla
RETURNS varchar(100) READS SQL DATA 
    COMMENT 'Devuelve la diferencia entre el nuevo aforo y el antiguo'
BEGIN
    DECLARE v_aforoAntiguo smallint default -1;
    DECLARE v_cadena varchar(100);
    DECLARE v_diferenciaAforo smallint default 0;

    SELECT aforo
    INTO v_aforoAntiguo
    FROM PISTAS
    WHERE nombre = p_nombrePista;
    
    IF (v_aforoAntiguo=-1) THEN	-- La pista no existe
        RETURN v_cadena;
    END IF;
    
    SET v_diferenciaAforo = p_aforo-v_aforoAntiguo;
    CASE 
        WHEN v_diferenciaAforo < 100 THEN 
            SET v_cadena = 'PEQUEÑA menor que 100';
        WHEN v_diferenciaAforo >= 100 AND v_diferenciaAforo <= 500  THEN 
            SET v_cadena = 'REGULAR entre 100 y 500';
        WHEN v_diferenciaAforo > 500 THEN 
        SET v_cadena = 'ABISMAL mayor que 500';
    END CASE;
    
   RETURN v_cadena;

END $$
DELIMITER ;

SELECT *,pistas_getDiferenciaAforo(nombre,600) as estado
FROM PISTAS
ORDER BY nombre;

SELECT *
FROM PISTAS
WHERE INSTR(pistas_getDiferenciaAforo(nombre,1000),'ABISMAL' COLLATE 'utf8mb4_spanish2_ci')>0
ORDER BY nombre;
```

</details>

---

### **Ejercicio 4:**

Crea una función de nombre ´pistas_getNumAtracciones´ que dada una pista devuelva el número de veces que se celebró una atracción en dicha pista.

Llama a dicha función por cada una de las pistas.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DELIMITER $$

DROP FUNCTION IF EXISTS pistas_getNumAtracciones $$
CREATE FUNCTION pistas_getNumAtracciones(p_nombre_pista VARCHAR(50))
RETURNS INT
READS SQL DATA
BEGIN
  DECLARE v_total INT DEFAULT 0;

  SELECT COUNT(*) INTO v_total
  FROM ATRACCION_DIA ad
  WHERE EXISTS (
    SELECT 1
    FROM ANIMALES a
    WHERE a.nombre_pista = p_nombre_pista
      AND a.nombre_atraccion = ad.nombre_atraccion
  );

  RETURN v_total;
END $$

DELIMITER ;

SELECT 
  p.nombre AS pista,
  pistas_getNumAtracciones(p.nombre) AS num_celebraciones
FROM PISTAS p
ORDER BY p.nombre;

```

</details>

---

### **Ejercicio 5:**
Crea una función de nombre `atracciones_getListEntreFechas` que devuelva el número de atracciones que se celebraron entre dos fechas dadas.

Se debe comprobar que las fechas tienen el formato correcto y que primero se envía la fecha menor. En caso contrario debe devolver el valor -1.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DELIMITER $$

DROP FUNCTION IF EXISTS atracciones_getListEntreFechas $$
CREATE FUNCTION atracciones_getListEntreFechas(p_fecha_ini VARCHAR(10), p_fecha_fin VARCHAR(10))
RETURNS INT
READS SQL DATA
BEGIN
  DECLARE d_ini DATE;
  DECLARE d_fin DATE;
  DECLARE v_total INT DEFAULT 0;

  -- Validar formato YYYY-MM-DD (y que sea una fecha real)
  SET d_ini = STR_TO_DATE(p_fecha_ini, '%Y-%m-%d');
  SET d_fin = STR_TO_DATE(p_fecha_fin, '%Y-%m-%d');

  IF d_ini IS NULL OR  DATE_FORMAT(d_ini, '%Y-%m-%d') <> p_fecha_ini THEN
    RETURN -1;
  END IF;

  IF d_fin IS NULL OR DATE_FORMAT(d_fin, '%Y-%m-%d') <> p_fecha_fin THEN
    RETURN -1;
  END IF;

  -- Validar orden
  IF d_ini > d_fin THEN
    RETURN -1;
  END IF;

  SELECT COUNT(*) INTO v_total
  FROM ATRACCION_DIA
  WHERE fecha BETWEEN d_ini AND d_fin;

  RETURN v_total;
END $$

DELIMITER ;

SELECT atracciones_getListEntreFechas('2000-01-01', '2000-12-31') AS celebraciones;

```
</details>

### **Ejercicio 6:**
Crea una función de nombre `artistas_getNumAnimales` al que se le pase el nif de un artista y devuelva a cuantos animales cuida.

En caso de que no exista el artista debe devolver -1.
Llama a la función y haz que muestre a cuantos animales cuidan cada uno de los artistas.
Guarda en una variable de sesión a cuantos animales cuida el artista con nif 22222222B y muestra su valor.
Muestra los artistas que cuidan a 2 o más animales empleando la función.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DELIMITER $$

DROP FUNCTION IF EXISTS artistas_getNumAnimales $$
CREATE FUNCTION artistas_getNumAnimales(p_nif CHAR(9))
RETURNS INT
READS SQL DATA
BEGIN
  DECLARE v_existe INT DEFAULT 0;
  DECLARE v_total  INT DEFAULT 0;

  -- ¿Existe el artista?
  SELECT COUNT(*) INTO v_existe
  FROM ARTISTAS
  WHERE nif = p_nif;

  IF v_existe = 0 THEN
    RETURN -1;
  END IF;

  -- ¿A cuántos animales cuida?
  SELECT COUNT(DISTINCT nombre_animal) INTO v_total
  FROM ANIMALES_ARTISTAS
  WHERE nif_artista = p_nif;

  RETURN v_total;
END $$

DELIMITER ;

-- Llamar la función para que muestre cuántos animales cuida cada artista
SELECT
  a.nif,
  a.nombre,
  a.apellidos,
  artistas_getNumAnimales(a.nif) AS num_animales
FROM ARTISTAS a
ORDER BY num_animales DESC, a.nif;

-- Guardar en variable de sesión los animales que cuida 22222222B y mostrarla
SET @num_animales_22222222B := artistas_getNumAnimales('22222222B');
SELECT @num_animales_22222222B AS num_animales_22222222B;

-- Mostrar artistas que cuidan 2 o más animales usando la función
SELECT
  a.nif,
  a.nombre,
  a.apellidos,
  artistas_getNumAnimales(a.nif) AS num_animales
FROM ARTISTAS a
WHERE artistas_getNumAnimales(a.nif) >= 2
ORDER BY num_animales DESC, a.nif;

```
</details>

### **Ejercicio 7:**
Crea una función de nombre `utilidades_getEstacionPorMes` que en función del mes que se le envíe como dato, devuelva la estación en la que se encuentre.

Llama a dicha función con el valor 7 y guarda el resultado en una variable de sesión. Muestra su valor.
Muestra las atracciones que empezaran en PRIMAVERA (tabla ATRACCIONES).
Muestra las ganancias por estación.

<details><summary>Mostrar Solución</summary>

```sql
USE CIRCO;
DELIMITER $$

DROP FUNCTION IF EXISTS utilidades_getEstacionPorMes $$
CREATE FUNCTION utilidades_getEstacionPorMes(p_mes TINYINT)
RETURNS VARCHAR(12)
DETERMINISTIC
BEGIN
  IF p_mes IS NULL OR p_mes < 1 OR p_mes > 12 THEN
    RETURN NULL;
  END IF;

  RETURN CASE
    WHEN p_mes IN (3,4,5) THEN 'PRIMAVERA'
    WHEN p_mes IN (6,7,8) THEN 'VERANO'
    WHEN p_mes IN (9,10,11) THEN 'OTOÑO'
    ELSE 'INVIERNO'  -- (12,1,2)
  END;
END $$

DELIMITER ;

-- Llamar a la función con 7, guardar en variable de sesión y mostrar
SET @estacion := utilidades_getEstacionPorMes(7);
SELECT @estacion AS estacion_mes_7;

-- Mostrar atracciones que empezaran en PRIMAVERA
SELECT
  nombre,
  fecha_inicio,
  ganancias
FROM ATRACCIONES
WHERE fecha_inicio IS NOT NULL
  AND utilidades_getEstacionPorMes(MONTH(fecha_inicio)) = 'PRIMAVERA'
ORDER BY fecha_inicio, nombre;

-- Mostrar las ganancias por estación
SELECT
  utilidades_getEstacionPorMes(MONTH(fecha_inicio)) AS estacion,
  SUM(ganancias) AS ganancias_totales
FROM ATRACCIONES
WHERE fecha_inicio IS NOT NULL
GROUP BY estacion
ORDER BY FIELD(estacion,'INVIERNO','PRIMAVERA','VERANO','OTOÑO');

```

</details>
