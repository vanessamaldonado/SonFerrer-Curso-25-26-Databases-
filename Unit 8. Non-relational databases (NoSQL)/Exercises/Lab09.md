# Lab09. Ejercicios Agregaciones

## Resuelva las siguientes consultas empleando el pipeline de agregaciones:

Crea una nueva base de datos llamada `sample_aggregacions` y crea las colecciones:
- Ciudades: [Download restaurants.json](../BBDD/ciudades.json)
- planetas: [Download restaurants.json](../BBDD/planetas.json)

## Ejercicios con la colección `ciudades`
1. Mostrar los 3 países con mayor número de ciudades
2. Devolver los 3 países con mayor número de habitantes
3. Calcular y devolver la población total de España, Francia e Italia, en orden descendente.
4. Calcular la latitud y longitud media para cada zona horaria europea.
5. Devolver los países en la posición 5ª y 6ª si ordenamos su población total en orden descendente.
6. Calcular las zonas horarias con mayor y menor número de habitantes para España y Rusia. Añade también un campo extra que indique cuántas zonas horarias tiene cada país.
7. Calcular qué porcentaje de la población representa la ciudad más poblada de España.
8. Utilizando unwind, devuelve los pares únicos (Pais,Timezone) con un campo que indique la suma total de población del país.


## Ejercicios con la colección `planetas`:

1. Mostrar los 4 valores más comunes de periodo de rotación.
2. Repetir lo anterior, pero restringiéndonos a los periodos no desconocidos, y hacer que el identificador sea un objeto que contenga un campo `periodo_rot`, en lugar del valor simple que tomamos dentro del `_id` en el apartado anterior.
3. Devolver los 5 periodos de rotación cuyos planetas tengan un mayor diámetro promedio.
4. Calcular y devolver la población total de los climas cuyo valor sea árido, cálido y templado (exactamente esos valores, no que incluyan - para este apartado olvide las regex -), y ordenarlos descendentemente.
5. Calcular la población media para cada tipo de clima que incluya templado.
6. Tomando los planetas con periodo orbital conocido, devolver los periodos orbitales en la posición segunda y tercera si ordenamos la población total por periodo orbital en orden descendente.
7. Calcular los periodos orbitales con mayor población total para los climas árido, cálido y templado. Añadir también un campo extra que indique cuántos periodos orbitales distintos tiene cada clima.
8. Calcular cuántas veces más grande es el mayor planeta con respecto al último, dentro de los que tienen periodo de rotación 24.
