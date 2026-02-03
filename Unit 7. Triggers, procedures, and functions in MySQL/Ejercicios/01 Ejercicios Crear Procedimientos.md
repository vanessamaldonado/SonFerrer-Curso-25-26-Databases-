# Ejercicios propuestos
Notas:
- Probar a crear los procedimientos de diferentes formas: directamente en una pestaña SQL o a través del asistente de MysqlWorkBench.
- Después de crear el procedimiento llámalo.
- Crea cada procedimiento con un pequeño comentario de su objetivo.
- En caso de que no se indique ordenación, establecer vosotros mismos un criterio de ordenación.

---

## Ejercicio 1
Crea un procedimiento de nombre `artistas_getList()´ que devuelva el nombre y apellidos de los artistas separados por coma con el formato: 
apellidos,nombre ordenados de forma descendente.

## Ejercicio 2
Crea un procedimiento de nombre `artistas_getListAnimales()` que devuelva los nombres de los artistas junto con su nif así como el nombre y peso 
de los animales que están atendidos por los artistas, ordenados por nif del artista y nombre del animal.

## Ejercicio 3
Crea un procedimiento de nombre `atracciones_getListConAntiguedad5()` que devuelva los datos de las atracciones que hayan comenzado hace 5 años con 
respecto a la fecha actual. Tendrás que hacer uso de alguna de las funciones Date Time. Intenta averiguar cual.

Fijarse que este procedimiento es un buen candidato para emplear un parámetro en donde indiquemos el número de años. 
Lo veremos después cuando expliquemos el paso de datos por parámetros.

## Ejercicio 4
Crea un procedimiento de nombre `animales_Leo_getPista()` que muestre los datos de la pista donde trabaja el animal de nombre 'Leo'. 
Hacerlo empleando una variable local que guarde el nombre de la pista. Después consultar los datos de la pista empleando dicha variable local.

Fijarse que este procedimiento es un buen candidato para emplear un parámetro en donde indiquemos el nombre del animal. 
Lo veremos después cuando expliquemos el paso de datos por parámetros.
