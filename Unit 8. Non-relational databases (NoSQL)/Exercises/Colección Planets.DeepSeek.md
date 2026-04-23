# Ejercicios MongoDB - Colección Planetas: DeepSeek

**Contexto:**

Partiendo de la colección de `planetas`, que contiene documentos con el siguiente formato:

```json
{
  "_id": {
    "$oid": "69e7788db426601cdd798884"
  },
  "name": "Alderaan",
  "rotation_period": "24",
  "orbital_period": "364",
  "diameter": "12500",
  "climate": "temperate",
  "gravity": "1 standard",
  "terrain": "grasslands, mountains",
  "surface_water": "40",
  "population": "2000000000",
  "residents": [
    "https://swapi.co/api/people/5/",
    "https://swapi.co/api/people/68/",
    "https://swapi.co/api/people/81/"
  ],
  "films": [
    "https://swapi.co/api/films/6/",
    "https://swapi.co/api/films/1/"
  ],
  "created": "2014-12-10T11:35:48.479000Z",
  "edited": "2014-12-20T20:58:18.420000Z",
  "url": "https://swapi.co/api/planets/2/"
}
```

## Ejercicio 1: Consultas Básicas:

Escribe las consultas MongoDB para:

1. Encontrar el primer planeta cuyo nombre sea “Tatooine”.
2. Encontrar todos los planetas que tengan clima “temperate”.
3. Listar todos los climas diferentes que existen en la colección.
4. Contar cuántos planetas tienen población desconocida (valor “unknown”).
5. Encontrar planetas que tengan terreno de montañas (mountains) O bosques (forests).
6. Encontrar planetas cuyo diámetro sea mayor a 10000.
7. Encontrar planetas que tengan superficie de agua mayor a 50.
8. Encontrar planetas que NO tengan residentes (array vacío).
9. Contar cuántos planetas aparecen en la película con URL https://swapi.co/api/films/2/.
10. Encontrar planetas cuyo período de rotación sea 24 horas y período orbital menor a 400 días.
11. Encontrar los 5 planetas con mayor población (orden descendente).
12. Encontrar planetas cuyos residentes incluyan a la persona con URL https://swapi.co/api/people/1/.
13. Encontrar planetas que tengan terreno de desierto (desert) O clima árido (arid).
14. Mostrar los 3 primeros planetas ordenados alfabéticamente por nombre.
15. Encontrar planetas saltando los primeros 10 resultados y mostrando los siguientes 5.

## Ejercicio 2: Agregaciones

Escribe las consultas de agregación MongoDB para:

1. Agrupar planetas por clima y contar cuántos hay de cada tipo.
2. Mostrar solo el nombre y diámetro de los planetas con clima “frozen”.
3. Encontrar el diámetro promedio de todos los planetas.
4. Listar planetas que tengan más de 2 residentes.
5. Ordenar planetas por diámetro de mayor a menor y mostrar solo los 3 primeros.
6. Mostrar los 5 planetas con menor período de rotación.
7. Calcular la población total de todos los planetas (ignorando “unknown”).
8. Agrupar por terreno y contar planetas, mostrando solo los terrenos con más de 2 planetas.
9. Encontrar cuántos planetas tienen superficie de agua igual a 0.
10. Hacer una lista única de todas las URLs de películas que aparecen en todos los planetas.
11. Mostrar cada residente individualmente con su planeta correspondiente.
12. Contar cuántos residentes tiene cada planeta.
13. Mostrar para cada planeta: nombre, número de películas y número de residentes.
14. Encontrar planetas que aparezcan en más de 2 películas.
15. Calcular el promedio de residentes por planeta.

