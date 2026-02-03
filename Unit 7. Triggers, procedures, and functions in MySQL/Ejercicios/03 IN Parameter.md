# Ejercicios IN Parameter

Crea los procedimientos indicados utilizando las formas vistas y añadiendo en todos ellos un comentario de cual es su objetivo. Si no está claro, documenta también cada uno de los parámetros.

## Ejercicio 1: 
Crea un procedimiento de nombre `artistas_getAnimalesPorNif` que devuelva los animales que cuida un artista. Llevará como parámetro el nif de artista.


## Ejercicio 2: 
Crea un procedimiento de nombre `artistas_getAnimalesPorNombreApel` que devuelva los animales que cuida un artista. Llevará como parámetro el nombre y apellidos del artista. Suponemos que el nombre y apellidos conforman una clave alternativa.


## Ejercicio 3: 
Crea un procedimiento de nombre `atracciones_getListConAntiguedad` que devuelva los datos de las atracciones que hayan comenzado hace un número de años con respecto a la fecha actual. Tendrás que hacer uso de alguna de las funciones Date Time. Intenta averiguar cual.

## Ejercicio 4: 
Crea un procedimiento de nombre `artistas_getListMasAnimalesCuida` que devuelva los datos del/os artista/s que cuidan a más animales de los indicados (parámetro que se le envía).
Pista: Como la consulta puede devolver más de un artista no podremos hacer uso de INTO....


## Ejercicio 5: 
Crea un procedimiento de nombre `atracciones_getListPorFecha` que devuelva los datos de las atracciones que han comenzado a partir de la fecha indicada.
Pista: Recordar que las fechas son tratadas como cadenas...y tener en cuenta el formato.
Añade una nueva atracción con la fecha de inicio actual.
Llama al procedimiento empleando la fecha actual menos 3 días (haz uso de la función DATE_SUB y curdate)

## Ejercicio 6: 
Crea un procedimiento de nombre `pistas_add` y que añada una nueva pista.
Nota: Aún no vimos la validación de datos que tendría que darse en el paso de parámetros. En este caso podríamos tener condiciones if en el que se comprueba sin el aforo es mayor que cero....
Se puede hacer uso de la función `ROW_COUNT()` para saber cuantas filas fueron añadidas, borradas o modificadas.
Importante: Los parámetros deben de tener el mismo tipo de dato y tamaño que el que está definido a nivel de columnas en la tabla PISTAS.

## Ejercicio 7: 
Crea un procedimiento de nombre `atracciones_update` que permita modificar los datos de una atracción (no se permite actualizar su clave primaria).
Modifica la fecha de inicio de la atracción 'El gran felino' y ponla un día después de la que tiene ahora mismo.
Pista: Tendrás que guardar las ganancias y la fecha de inicio que tiene para poder enviar ese dato al procedimiento.
Comprueba como al llamar al método con una atracción que no existe, row_count va a devolver 0.


## Ejercicio 8: 
Crea un procedimiento de nombre `pistas_delete` que borre una pista por su nombre. Haz que borre en base al patrón nombre% (empleando el Like).
Borra la atracción que hayas añadido en el ejercicio 6 mandando las primeras letras (ten cuidado de que no haya otra atracción con esas letras al comienzo).
Pista: Emplea la función CONCAT para el LIKE