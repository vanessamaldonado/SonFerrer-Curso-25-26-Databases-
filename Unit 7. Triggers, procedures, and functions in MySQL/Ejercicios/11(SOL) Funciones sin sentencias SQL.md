# 11 Funciones sin sentencias SQL

## Ejercicio 1:
Escribe una función que reciba un número entero de entrada y devuelva TRUE si el número es par o FALSE en caso contrario.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE FUNCTION es_par(numero INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    IF numero % 2 = 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //

DELIMITER ;

SELECT es_par(10);  -- Devuelve 1 (TRUE)
SELECT es_par(7);   -- Devuelve 0 (FALSE)

```

</details>

## Ejercicio 2:
Escribe una función que devuelva el valor de la hipotenusa de un triángulo a partir de los valores de sus lados.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE FUNCTION calcular_hipotenusa(cateto1 DOUBLE, cateto2 DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    RETURN SQRT(POW(cateto1, 2) + POW(cateto2, 2));
END //

DELIMITER ;

SELECT calcular_hipotenusa(3, 4);
```

</details>

## Ejercicio 3:
Escribe una función que reciba como parámetro de entrada un valor numérico que represente un día de la semana y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente. Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE FUNCTION nombre_dia_semana(dia INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CASE dia
        WHEN 1 THEN 'lunes'
        WHEN 2 THEN 'martes'
        WHEN 3 THEN 'miércoles'
        WHEN 4 THEN 'jueves'
        WHEN 5 THEN 'viernes'
        WHEN 6 THEN 'sábado'
        WHEN 7 THEN 'domingo'
        ELSE 'valor no válido'
    END;
END //

DELIMITER ;

SELECT nombre_dia_semana(1);  -- lunes
SELECT nombre_dia_semana(5);  -- viernes
SELECT nombre_dia_semana(9);  -- valor no válido
```
</details>

## Ejercicio 4:
Escribe una función que reciba tres números reales como parámetros de entrada y devuelva el mayor de los tres.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE FUNCTION mayor_de_tres(num1 DOUBLE, num2 DOUBLE, num3 DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE mayor DOUBLE;
    
    SET mayor = num1;
    
    IF num2 > mayor THEN
        SET mayor = num2;
    END IF;
    
    IF num3 > mayor THEN
        SET mayor = num3;
    END IF;
    
    RETURN mayor;
END //

DELIMITER ;

SELECT mayor_de_tres(4.5, 8.2, 3.1);   -- 8.2
SELECT mayor_de_tres(-10, -3, -7);     -- -3
```
</details>

## Ejercicio 5:
Escribe una función que devuelva el valor del área de un círculo a partir del valor del radio que se recibirá como parámetro de entrada.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE FUNCTION area_circulo(radio DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    RETURN PI() * POW(radio, 2);
END //

DELIMITER ;

SELECT area_circulo(5);
```
</details>

## Ejercicio 6:
Escribe una función que devuelva como salida el número de años que han transcurrido entre dos fechas que se reciben como parámetros de entrada. Por ejemplo, si pasamos como parámetros de entrada las fechas 2018-01-01 y 2008-01-01 la función tiene que devolver que han pasado 10 años.

Para realizar esta función puede hacer uso de las siguientes funciones que nos proporciona MySQL:

- DATEDIFF
- TRUNCATE

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE FUNCTION anios_transcurridos(fecha1 DATE, fecha2 DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TRUNCATE(DATEDIFF(fecha1, fecha2) / 365, 0);
END //

DELIMITER ;

SELECT anios_transcurridos('2018-01-01', '2008-01-01') AS anios;
```
</details>

## Ejercicio 7:
Escribe una función que reciba una cadena de entrada y devuelva la misma cadena pero sin acentos. La función tendrá que reemplazar todas las vocales que tengan acento por la misma vocal pero sin acento. Por ejemplo, si la función recibe como parámetro de entrada la cadena María la función debe devolver la cadena Maria.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE FUNCTION quitar_acentos(texto VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    SET texto = REPLACE(texto, 'á', 'a');
    SET texto = REPLACE(texto, 'é', 'e');
    SET texto = REPLACE(texto, 'í', 'i');
    SET texto = REPLACE(texto, 'ó', 'o');
    SET texto = REPLACE(texto, 'ú', 'u');
    
    SET texto = REPLACE(texto, 'Á', 'A');
    SET texto = REPLACE(texto, 'É', 'E');
    SET texto = REPLACE(texto, 'Í', 'I');
    SET texto = REPLACE(texto, 'Ó', 'O');
    SET texto = REPLACE(texto, 'Ú', 'U');

    RETURN texto;
END //

DELIMITER ;

SELECT quitar_acentos('María');        -- Maria
SELECT quitar_acentos('Canción');      -- Cancion
SELECT quitar_acentos('Árbol Útil');   -- Arbol Util
```

</details>