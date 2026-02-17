# 07 Ejercicios: Procedimientos sin sentencias SQL

## Ejercicio 1
Escribe un procedimiento que no tenga ningún parámetro de entrada ni de salida y que muestre el texto ¡Hola mundo!.

<details><summary>Mostrar Solución</summary>

```sql
 DELIMITER //

CREATE PROCEDURE hola_mundo()
BEGIN
    SELECT '¡Hola mundo!' AS mensaje;
END //

DELIMITER ;

call hola_mundo();
```

</details>

## Ejercicio 2 
Escribe un procedimiento que reciba un número real de entrada y muestre un mensaje indicando si el número es positivo, negativo o cero.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE evaluar_numero(IN p_num REAL)
BEGIN
    IF p_num > 0 THEN
        SELECT 'El número es positivo' AS resultado;
    ELSEIF p_num < 0 THEN
        SELECT 'El número es negativo' AS resultado;
    ELSE
        SELECT 'El número es cero' AS resultado;
    END IF;
END //

DELIMITER ;

call evaluar_numero(5);
call evaluar_numero(-7);
call evaluar_numero(0);
```

</details>

## Ejercicio 3
Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, con el valor de un número de tipo real, y un parámetro de salida, que será una cadena de caracteres indicando si el número es positivo, negativo o cero.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE evaluar_numero_out(IN p_num REAL, OUT p_resultado VARCHAR(20))
BEGIN
    IF p_num > 0 THEN
        SET p_resultado = 'positivo';
    ELSEIF p_num < 0 THEN
        SET p_resultado = 'negativo';
    ELSE
        SET p_resultado = 'cero';
    END IF;
END //

DELIMITER ;

CALL evaluar_numero_out(5.3, @res);
SELECT @res;

CALL evaluar_numero_out(-2, @res);
SELECT @res;

CALL evaluar_numero_out(0, @res);
SELECT @res;
```
</details>

## Ejercicio 4
Escribe un procedimiento que reciba un número real de entrada, que representa el valor de la nota de un alumno, y muestre un mensaje indicando qué nota ha obtenido teniendo en cuenta las siguientes condiciones:
- [0,5) = Insuficiente
- [5,6) = Aprobado
- [6, 7) = Bien
- [7, 9) = Notable
- [9, 10] = Sobresaliente
En cualquier otro caso la nota no será válida.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE clasificar_nota(IN p_nota REAL)
BEGIN
    IF p_nota >= 0 AND p_nota < 5 THEN
        SELECT 'Insuficiente' AS calificacion;
        
    ELSEIF p_nota >= 5 AND p_nota < 6 THEN
        SELECT 'Aprobado' AS calificacion;
        
    ELSEIF p_nota >= 6 AND p_nota < 7 THEN
        SELECT 'Bien' AS calificacion;
        
    ELSEIF p_nota >= 7 AND p_nota < 9 THEN
        SELECT 'Notable' AS calificacion;
        
    ELSEIF p_nota >= 9 AND p_nota <= 10 THEN
        SELECT 'Sobresaliente' AS calificacion;
        
    ELSE
        SELECT 'Nota no válida' AS calificacion;
        
    END IF;
END //

DELIMITER ;

CALL clasificar_nota(4.5);
CALL clasificar_nota(6.8);
CALL clasificar_nota(9.2);
CALL clasificar_nota(11);
```
</details>

## Ejercicio 5 
Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, con el valor de la nota en formato numérico y un parámetro de salida, con una cadena de texto indicando la nota correspondiente.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE clasificar_nota_out(
    IN p_nota REAL,
    OUT calificacion VARCHAR(20)
)
BEGIN
    IF p_nota >= 0 AND p_nota < 5 THEN
        SET calificacion = 'Insuficiente';
        
    ELSEIF p_nota >= 5 AND p_nota < 6 THEN
        SET calificacion = 'Aprobado';
        
    ELSEIF p_nota >= 6 AND p_nota < 7 THEN
        SET calificacion = 'Bien';
        
    ELSEIF p_nota >= 7 AND p_nota < 9 THEN
        SET calificacion = 'Notable';
        
    ELSEIF p_nota >= 9 AND p_nota <= 10 THEN
        SET calificacion = 'Sobresaliente';
        
    ELSE
        SET calificacion = 'Nota no válida';
        
    END IF;
END //

DELIMITER ;

CALL clasificar_nota_out(8.5, @resultado);
SELECT @resultado;

CALL clasificar_nota_out(4.2, @resultado);
SELECT @resultado;

CALL clasificar_nota_out(12, @resultado);
SELECT @resultado;
```

</details>

## Ejercicio 6 
Resuelva el procedimiento diseñado en el ejercicio anterior haciendo uso de la estructura de control CASE.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE clasificar_nota_out_case(
    IN p_nota REAL,
    OUT calificacion VARCHAR(20)
)
BEGIN
    CASE
        WHEN p_nota >= 0 AND p_nota < 5 THEN
            SET calificacion = 'Insuficiente';
        WHEN p_nota >= 5 AND p_nota < 6 THEN
            SET calificacion = 'Aprobado';
        WHEN p_nota >= 6 AND p_nota < 7 THEN
            SET calificacion = 'Bien';
        WHEN p_nota >= 7 AND p_nota < 9 THEN
            SET calificacion = 'Notable';
        WHEN p_nota >= 9 AND p_nota <= 10 THEN
            SET calificacion = 'Sobresaliente';
        ELSE
            SET calificacion = 'Nota no válida';
    END CASE;
END //

DELIMITER ;

CALL clasificar_nota_out_case(7.8, @res);
SELECT @res;
```

</details>

## Ejercicio 7 
Escribe un procedimiento que reciba como parámetro de entrada un valor numérico que represente un día de la semana y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente. Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes. Resuelva el procedimiento haciendo uso de la estructura de control IF.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE obtener_dia_semana(
    IN p_num_dia INT,
    OUT p_nombre_dia VARCHAR(15)
)
BEGIN
    IF p_num_dia = 1 THEN
        SET p_nombre_dia = 'lunes';
        
    ELSEIF p_num_dia = 2 THEN
        SET p_nombre_dia = 'martes';
        
    ELSEIF p_num_dia = 3 THEN
        SET p_nombre_dia = 'miércoles';
        
    ELSEIF p_num_dia = 4 THEN
        SET p_nombre_dia = 'jueves';
        
    ELSEIF p_num_dia = 5 THEN
        SET p_nombre_dia = 'viernes';
        
    ELSEIF p_num_dia = 6 THEN
        SET p_nombre_dia = 'sábado';
        
    ELSEIF p_num_dia = 7 THEN
        SET p_nombre_dia = 'domingo';
        
    ELSE
        SET p_nombre_dia = 'Valor no válido';
        
    END IF;
END //

DELIMITER ;

CALL obtener_dia_semana(1, @dia);
SELECT @dia;

CALL obtener_dia_semana(6, @dia);
SELECT @dia;

CALL obtener_dia_semana(9, @dia);
SELECT @dia;
```

</details>


## Ejercicio 8 
Resuelva el procedimiento diseñado en el ejercicio anterior haciendo uso de la estructura de control CASE.

<details><summary>Mostrar Solución</summary>

```sql
DELIMITER //

CREATE PROCEDURE obtener_dia_semana_case(
    IN p_num_dia INT,
    OUT p_nombre_dia VARCHAR(15)
)
BEGIN
    CASE p_num_dia
        WHEN 1 THEN
            SET p_nombre_dia = 'lunes';
        WHEN 2 THEN
            SET p_nombre_dia = 'martes';
        WHEN 3 THEN
            SET p_nombre_dia = 'miércoles';
        WHEN 4 THEN
            SET p_nombre_dia = 'jueves';
        WHEN 5 THEN
            SET p_nombre_dia = 'viernes';
        WHEN 6 THEN
            SET p_nombre_dia = 'sábado';
        WHEN 7 THEN
            SET p_nombre_dia = 'domingo';
        ELSE
            SET p_nombre_dia = 'Valor no válido';
    END CASE;
END //

DELIMITER ;

CALL obtener_dia_semana_case(3, @dia);
SELECT @dia;

CALL obtener_dia_semana_case(8, @dia);
SELECT @dia;
```

</details>