# Lab09. Ejercicios Agregaciones

## Resuelva las siguientes consultas empleando el pipeline de agregaciones:

Crea una nueva base de datos llamada `sample_aggregacions` y crea las colecciones:
- Ciudades: [Download ciudades.json](../BBDD/ciudades.json)
- planetas: [Download planetas.json](../BBDD/planetas.json)

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

---

<details><summary>Ejercicios con la colección `ciudades`</summary>

```javascript
// 1 Mostrar los 3 países con mayor número de ciudades
db.ciudades.aggregate([
    {$group: {_id: "$country", nciudades: {$sum: 1}}}, // Agrupa por país y cuenta 1 por cada ciudad
    {$sort: {nciudades: -1}}, // Ordena de mayor a menor número de ciudades
    {$limit: 3} // Devuelve solo los 3 primeros países
])

// 2 Devolver los 3 países con mayor número de habitantes
db.ciudades.aggregate([
    {$group: {_id: "$country", nhabs: {$sum: "$population"}}}, // Agrupa por país y suma la población
    {$sort: {nhabs: -1}}, // Ordena de mayor a menor población
    {$limit: 3} // Devuelve los 3 países más poblados
])

// 3 Calcular y devolver la población total de España, Francia e Italia, en orden descendente.
db.ciudades.aggregate([
    {$match: {country: {$in: ["ES", "FR", "IT"]}}}, // Filtra solo España, Francia y Alemania
    {$group: {_id: "$country", nhabs: {$sum: "$population"}}}, // Suma población por país
    {$sort: {nhabs: -1}} // Ordena de mayor a menor población
])

// 4 Calcular la latitud y longitud media para cada zona horaria europea.
db.ciudades.aggregate([
    {$match: {timezone: {$regex: /^Europe/}}}, // Selecciona zonas horarias que empiezan por "Europe"
    {$group: {
        _id: "$timezone", // Agrupa por zona horaria
        longmed: {$avg: "$location.longitude"}, // Calcula la media de longitudes
        latmed: {$avg: "$location.latitude"} // Calcula la media de latitudes
    }}
])

// 5 Devolver los países en la posición 5ª y 6ª si ordenamos su población total en orden descendente.
db.ciudades.aggregate([
    {$group: {_id: "$country", nhabs: {$sum: "$population"}}}, // Suma población por país
    {$sort: {nhabs: -1}}, // Ordena de mayor a menor
    {$skip: 4}, // Salta los 4 primeros (empieza en el 5º)
    {$limit: 2} // Devuelve el 5º y 6º país
])

// 6 Calcular las zonas horarias con mayor y menor número de habitantes para España y Rusia. Añade también un campo extra que indique cuántas zonas horarias tiene cada país.
db.ciudades.aggregate([
    {$match: {country: {$in: ["ES", "RU"]}}}, // Filtra España y Rusia
    {$group: {
        _id: {pais: "$country", zona: "$timezone"}, // Agrupa por país y zona horaria
        nhabs: {$sum: "$population"} // Suma población por cada zona
    }},
    {$sort: {nhabs: -1}}, // Ordena zonas por población (descendente)
    {$group: {
        _id: "$_id.pais", // Agrupa de nuevo por país
        zonamayor: {$first: "$_id.zona"}, // Primera zona = la más poblada
        zonamenor: {$last: "$_id.zona"}, // Última zona = la menos poblada
        nzonas: {$sum: 1} // Cuenta cuántas zonas tiene el país
    }}
])

// 7 Calcular qué porcentaje de la población representa la ciudad más poblada de España.
db.ciudades.aggregate([
    {$match: {country: "ES"}}, // Filtra solo ciudades de España
    {$sort: {population: 1}}, // Ordena de menor a mayor población
    {$group: {
        _id: null, // Agrupa todo en un solo grupo
        pobmax: {$last: "$population"}, // Último valor = ciudad más poblada
        pobtotal: {$sum: "$population"} // Suma total de población
    }},
    {$project: {
        porc: {$multiply: [{$divide: ["$pobmax", "$pobtotal"]}, 100]} // Calcula el porcentaje
    }}
])

// 8 Utilizando unwind, devuelve los pares únicos (Pais,Timezone) con un campo que indique la suma total de población del país.
db.ciudades.aggregate([
    {$group: {
        _id: "$country", // Agrupa por país
        zonash: {$addToSet: "$timezone"}, // Guarda zonas horarias únicas en un array
        pobtotal: {$sum: "$population"} // Suma población total del país
    }},
    {$unwind: "$zonash"} // Descompone el array → una fila por zona horaria
])
```
</details>

<details><summary>Ejercicios con la colección `planetas`:</summary>

```javascript
// 1 Mostrar los 4 valores más comunes de periodo de rotación.
db.planetas.aggregate([
    {$group: {_id: "$rotation_period", n: {$sum: 1}}}, // Agrupa por periodo de rotación y cuenta cuántos planetas hay en cada uno
    {$sort: {n: -1}}, // Ordena de mayor a menor frecuencia
    {$limit: 4} // Devuelve los 4 periodos más comunes
])

// 2 Repetir lo anterior, pero restringiéndonos a los periodos no desconocidos, y hacer que el identificador sea un objeto que contenga un campo `periodo_rot`, en lugar del valor simple que tomamos dentro del `_id` en el apartado anterior.
db.planetas.aggregate([
    {$match: {rotation_period: {$ne: "unknown"}}}, // Filtra periodos conocidos (distintos de "unknown")
    {$group: {_id: {periodo_rot: "$rotation_period"}, n: {$sum: 1}}}, // Agrupa usando un objeto como _id
    {$sort: {n: -1}}, // Ordena por frecuencia descendente
    {$limit: 4} // Devuelve los 4 más frecuentes
])

// 3 Devolver los 5 periodos de rotación cuyos planetas tengan un mayor diámetro promedio.
db.planetas.aggregate([
    {$match: {
        rotation_period: {$ne: "unknown"}, // Filtra periodos conocidos
        diameter: {$exists: true, $ne: null, $ne: "unknown"} // Asegura diámetro válido
    }},
    {$project: {
        diameter: {"$toInt": "$diameter"}, // Convierte diámetro a entero
        rotation_period: true // Mantiene el periodo de rotación
    }},
    {$group: {
        _id: "$rotation_period", // Agrupa por periodo de rotación
        diammed: {$avg: "$diameter"}, // Calcula diámetro medio
        rotation_period: {$first: "$rotation_period"} // Guarda el valor del periodo
    }},
    {$sort: {diammed: -1}}, // Ordena por diámetro medio descendente
    {$limit: 5}, // Se queda con los 5 mejores
    {$project: {
        rotation_period: true, // Muestra solo el periodo
        _id: false // Oculta el _id
    }}
])

// 4 Calcular y devolver la población total de los climas cuyo valor sea árido, cálido y templado (exactamente esos valores, no que incluyan - para este apartado olvide las regex -), y ordenarlos descendentemente.
db.planetas.aggregate([
    {$match: {
        climate: {$in: ["arid", "hot", "temperate"]}, // Filtra solo esos climas exactos
        population: {$exists: true, $ne: null, $ne: "unknown"} // Población válida
    }},
    {$project: {
        population: {"$toLong": "$population"}, // Convierte población a número
        climate: true, // Mantiene el clima
        _id: false // Elimina _id
    }},
    {$group: {
        _id: "$climate", // Agrupa por clima
        pob_total: {$sum: "$population"} // Suma población total
    }},
    {$sort: {pob_total: -1}} // Ordena de mayor a menor población
])

// 5 Calcular la población media para cada tipo de clima que incluya templado.
db.planetas.aggregate([
    {$match: {
        climate: {$regex: /temperate/}, // Selecciona climas que contienen "temperate"
        population: {$exists: true, $ne: null, $ne: "unknown"} // Población válida
    }},
    {$project: {
        population: {"$toLong": "$population"}, // Convierte a número
        climate: true, // Mantiene clima
        _id: false
    }},
    {$group: {
        _id: "$climate", // Agrupa por tipo de clima
        pob_media: {$avg: "$population"} // Calcula población media
    }}
])

// 6 Tomando los planetas con periodo orbital conocido, devolver los periodos orbitales en la posición segunda y tercera si ordenamos la población total por periodo orbital en orden descendente.
db.planetas.aggregate([
    {$match: {
        orbital_period: {$exists: true, $ne: null, $ne: "unknown"}, // Periodo orbital válido
        population: {$exists: true, $ne: null, $ne: "unknown"} // Población válida
    }},
    {$project: {
        population: {"$toLong": "$population"}, // Convierte población
        orbital_period: true, // Mantiene periodo orbital
        _id: false
    }},
    {$group: {
        _id: "$orbital_period", // Agrupa por periodo orbital
        pob_total: {$sum: "$population"} // Suma población
    }},
    {$sort: {pob_total: -1}}, // Ordena de mayor a menor
    {$skip: 1}, // Salta el primero (más poblado)
    {$limit: 2} // Devuelve el 2º y 3º
])

// 7 Calcular los periodos orbitales con mayor población total para los climas árido, cálido y templado. Añadir también un campo extra que indique cuántos periodos orbitales distintos tiene cada clima.
db.planetas.aggregate([
    {$match: {
        climate: {$in: ["arid", "hot", "temperate"]}, // Filtra climas concretos
        population: {$exists: true, $ne: null, $ne: "unknown"} // Población válida
    }},
    {$project: {
        population: {"$toLong": "$population"}, // Convierte población
        climate: true, // Mantiene clima
        orbital_period: true, // Mantiene periodo orbital
        _id: false
    }},
    {$group: {
        _id: {clima: "$climate", periodo: "$orbital_period"}, // Agrupa por clima y periodo
        pob_total: {$sum: "$population"} // Suma población
    }},
    {$sort: {pob_total: -1}}, // Ordena por población
    {$group: {
        _id: "$_id.clima", // Agrupa por clima
        periodo: {$first: "$_id.periodo"}, // Periodo con más población
        nperiodos: {$sum: 1} // Cuenta cuántos periodos distintos hay
    }}
])

// 8 Calcular cuántas veces más grande es el mayor planeta con respecto al último, dentro de los que tienen periodo de rotación 24.
db.planetas.aggregate([
    {$match: {
        rotation_period: "24", // Filtra planetas con periodo de rotación 24
        diameter: {$exists: true, $ne: null, $ne: "unknown"} // Diámetro válido
    }},
    {$project: {
        diameter: {"$toInt": "$diameter"}, // Convierte diámetro a entero
        _id: false
    }},
    {$match: {diameter: {$gt: 0}}}, // Filtra diámetros positivos
    {$sort: {diameter: -1}}, // Ordena de mayor a menor diámetro
    {$group: {
        _id: null, // Agrupa todo en uno
        mas_grande: {$first: "$diameter"}, // Primer valor = mayor diámetro
        mas_pequeño: {$last: "$diameter"} // Último valor = menor diámetro
    }},
    {$project: {
        ratio: {$divide: ["$mas_grande", "$mas_pequeño"]} // Calcula cuántas veces es mayor
    }}
])
```
</details>

