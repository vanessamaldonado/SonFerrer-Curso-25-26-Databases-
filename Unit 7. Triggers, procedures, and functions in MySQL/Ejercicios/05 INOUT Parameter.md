# Ejercicios propuestos de parámetros de Entrada/Salida

Crea los procedimientos indicados utilizando las formas vistas y añadiendo en todos ellos un comentario de cual es su objetivo. Si no está claro, documenta también cada uno de los parámetros. Escribe un ejemplo de llamada a cada uno de los procedimientos creados.

## Ejercicio 1
Crea un procedimiento de nombre `pistas_addAforo` al que se le envíe como parámetros el nombre de la pista y una cantidad que representa el incremento del aforo.

El procedimiento debe devolver en el mismo parámetro el nuevo aforo de la pista.
Nota: Aún no vimos el uso de IF pero en este método habría que tener en cuenta si el aforo es superior al rango de un smallint...

## Ejercicio 2
Crea un procedimiento de nombre `artistas_getNombreCompleto` al que se le pase como parámetro el nif y devuelva en el mismo parámetro el nombre completo con el formato: apellidos, nombre

## Ejercicio 3
Crea un procedimiento de nombre `animales_addAforo` al que se le envíe como parámetros el nombre del animal y el incremento del aforo en la pista en la que trabaja el animal. Debe de hacer uso del procedimiento creado en el ejercicio 1 y debe de devolver empleando los dos parámetros anteriores, el nombre de la pista y su nuevo aforo.