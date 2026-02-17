# 08 Ejercicios: Procedimientos con sentencias SQL

## Ejercicio 1
Escribe un procedimiento que reciba el nombre de un país como parámetro de entrada y realice una consulta sobre la tabla cliente para obtener todos los clientes que existen en la tabla de ese país.

## Ejercicio 2 
Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc). Y devuelva como salida el pago de máximo valor realizado para esa forma de pago. Deberá hacer uso de la tabla pago de la base de datos jardineria.

## Ejercicio 3
Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc). Y devuelva como salida los siguientes valores teniendo en cuenta la forma de pago seleccionada como parámetro de entrada:

- el pago de máximo valor,
- el pago de mínimo valor,
- el valor medio de los pagos realizados,
- la suma de todos los pagos,
- el número de pagos realizados para esa forma de pago.
Deberá hacer uso de la tabla pago de la base de datos jardineria.

## Ejercicio 4
Crea una base de datos llamada `procedimientos` que contenga una tabla llamada `cuadrados`. La tabla cuadrados debe tener dos columnas de tipo INT UNSIGNED, una columna llamada `número` y otra columna llamada `cuadrado`.

Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado `calcular_cuadrados` con las siguientes características:
- El procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y calculará el valor de los cuadrados de los primeros números naturales hasta el valor introducido como parámetro. 
- El valor del números y de sus cuadrados deberán ser almacenados en la tabla cuadrados que hemos creado previamente.

Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de la tabla antes de insertar los nuevos valores de los cuadrados que va a calcular.

Utilice un bucle WHILE para resolver el procedimiento.

## Ejercicio 5 
Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.

## Ejercicio 6 
Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.

## Ejercicio 7 
Crea una base de datos llamada `procedimientos` que contenga una tabla llamada `ejercicio`. La tabla debe tener una única columna llamada `número` y el tipo de dato de esta columna debe ser INT UNSIGNED.

Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado `calcular_números` con las siguientes características:
- El procedimiento recibe un parámetro de entrada llamado `valor_inicial` de tipo INT UNSIGNED y deberá almacenar en la tabla ejercicio toda la secuencia de números desde el valor inicial pasado como entrada hasta el 1.

Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los nuevos valores.

Utilice un bucle WHILE para resolver el procedimiento.

## Ejercicio 8 
Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.

## Ejercicio 9
Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.

## Ejercicio 10
Crea una base de datos llamada `procedimientos` que contenga una tabla llamada `pares` y otra tabla llamada `impares`. Las dos tablas deben tener única columna llamada `número` y el tipo de dato de esta columna debe ser INT UNSIGNED.

Una vez creada la base de datos y las tablas deberá crear un procedimiento llamado `calcular_pares_impares` con las siguientes características:
- El procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y deberá almacenar en la tabla pares aquellos números pares que existan entre el número 1 el valor introducido como parámetro. 
- Habrá que realizar la misma operación para almacenar los números impares en la tabla impares.

Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los nuevos valores.

Utilice un bucle WHILE para resolver el procedimiento.

## Ejercicio 11
Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.

## Ejercicio 12
Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.


