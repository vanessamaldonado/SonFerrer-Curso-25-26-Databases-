# Ejercicios MongoDB - Colección Planetas

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

---

<details><summary>Ejercicio 1: Consultas Básicas</summary>

```javascript
//1. Encontrar el primer planeta cuyo nombre sea “Tatooine”.
db.planetas.findOne({ 
  name: "Tatooine" // Busca el primer documento con ese nombre
})

//2. Encontrar todos los planetas que tengan clima “temperate”.
db.planetas.find({ 
  climate: "temperate" // Filtra por valor exacto del campo climate
})

//3. Listar todos los climas diferentes que existen en la colección.
db.planetas.distinct("climate") // Devuelve valores únicos del campo climate

//4. Contar cuántos planetas tienen población desconocida (valor “unknown”).
db.planetas.countDocuments({ 
  population : "unknown" // Cuenta documentos con población "unknown"
})

//5. Encontrar planetas que tengan terreno de montañas (mountains) O bosques (forests).
db.planetas.find({
  $or: [
    {terrain: /\bmountains\b/i}, // Busca "mountains" como palabra completa
    {terrain: /\bforests\b/i} // Busca "forests"
  ]
})
// \b es un límite de palabra que asegura que la coincidencia sea una palabra completa, no parte de otra.

//6. Encontrar planetas cuyo diámetro sea mayor a 10000.
db.planetas.find({
  $expr: {
    $gt: [
      { $toInt: "$diameter" },
      10000
    ]
  }
})
//opcion B
db.planetas.aggregate([
  {
    $match: {
      $expr: {
        $gt: [
          { $toInt: "$diameter" },
          10000
        ]
      }
    }
  }
])

//7. Encontrar planetas que tengan superficie de agua mayor a 50.
db.planetas.find({
  $expr: {
    $gt: [
      { $toInt: "$surface_water" },
      50
    ]
  }
})
// opción B
db.planetas.aggregate([
  {
    $addFields: {
      surfaceWaterNum: { $toInt: "$surface_water" }
    }
  },
  {
    $match: {
      surfaceWaterNum: { $gt: 50 }
    }
  }
])

//8. Encontrar planetas que NO tengan residentes (array vacío).
db.planetas.find({ 
  residents : {$size: 0} // Array vacío
})

//9. Contar cuántos planetas aparecen en la película con URL https://swapi.co/api/films/2/.
db.planetas.countDocuments({
  films: "https://swapi.co/api/films/2/" // Busca valor dentro del array
})

//10. Encontrar planetas cuyo período de rotación sea 24 horas y período orbital menor a 400 días.
db.planetas.find({
  $expr: {
    $and: [
      { $eq: [ { $toInt: "$rotation_period" }, 24 ] },
      { $lt: [ { $toInt: "$orbital_period" }, 400 ] }
    ]
  }
})

// opción b
db.planetas.aggregate([
  {
    $addFields: {
      rotation: { $toInt: "$rotation_period" },
      orbital: { $toInt: "$orbital_period" }
    }
  },
  {
    $match: {
      rotation: 24,
      orbital: { $lt: 400 }
    }
  }
])

//11. Encontrar los 5 planetas con mayor población (orden descendente).
db.planetas.find({
  $expr: {
    $ne: ["$population", "unknown"]
  }
}).sort({
  population: -1
}).limit(5)

// opcion b
db.planetas.aggregate([
  {
    $match: {
      population: { $ne: "unknown" }
    }
  },
  {
    $addFields: {
      populationInt: { $toLong: "$population" }
    }
  },
  {
    $sort: { populationInt: -1 }
  },
  {
    $limit: 5
  }
])

//12. Encontrar planetas cuyos residentes incluyan a la persona con URL https://swapi.co/api/people/1/.
db.planetas.find({
  residents : "https://swapi.co/api/people/1/" // Busca dentro del array
})

//13. Encontrar planetas que tengan terreno de desierto (desert) O clima árido (arid).
db.planetas.find({
  $or: [
    {terrain: /\bdesert\b/i}, // Busca "desert"
    {climate: /\barid\b/i} // Busca "arid"
  ]
})

//14. Mostrar los 3 primeros planetas ordenados alfabéticamente por nombre.
db.planetas.find({})
.sort({ name: 1}) // Orden alfabético
.limit(3) // Primeros 3

//15. Encontrar planetas saltando los primeros 10 resultados y mostrando los siguientes 5.
db.planetas.find({})
.skip(10) // Salta 10 documentos
.limit(5) // Devuelve los siguientes 5

```
</details>

<details><summary>Ejercicio 2: Agregaciones</summary>

```javascript
//1. Agrupar planetas por clima y contar cuántos hay de cada tipo.
db.planetas.aggregate([
  {
    $group: {
      _id: "$climate", // Agrupa por tipo de clima
      total: { $sum: 1 } // Cuenta cuántos planetas hay en cada clima
    }
  }
])


//2. Mostrar solo el nombre y diámetro de los planetas con clima “frozen”.
db.planetas.aggregate([
  {
    $match: { climate: "frozen" } // Filtra planetas con clima frozen
  },
  {
    $project: {
      name: 1, // Muestra nombre
      diameter: 1, // Muestra diámetro
      _id: 0 // Oculta _id
    }
  }
])

//3. Encontrar el diámetro promedio de todos los planetas.
db.planetas.aggregate([
  {
    $match: {
      diameter: { $nin: ["0", "unknown", null] } // Filtra valores inválidos
    }
  },
  {
    $group: {
      _id: null, // Un solo grupo global
      promedio: {
        $avg: { $toInt: "$diameter" } // Convierte a número y calcula media
      }
    }
  }
])
// _id: null cuando no quiero agrupar por ningún campo en concreto. Quiero tratar TODOS los documentos como un único grupo.

//4. Listar planetas que tengan más de 2 residentes.
db.planetas.aggregate([
  {
    $match: {
      $expr: {
        $gt: [
          { $size: "$residents" }, // Tamaño del array
          2 // Mayor que 2
        ]
      }
    }
  }
])

//5. Ordenar planetas por diámetro de mayor a menor y mostrar solo los 3 primeros.
db.planetas.aggregate([
  {
    $match: {
      diameter: { $nin: ["0", "unknown", null] } // Filtra valores inválidos
    }
  },
  {
    $addFields: {
      diameter_num: { $toInt: "$diameter" } // Convierte a número
    }
  },
  {
    $sort: { diameter_num: -1 } // Ordena de mayor a menor
  },
  {
    $limit: 3 // Toma los 3 primeros
  }
])

//6. Mostrar los 5 planetas con menor período de rotación.
db.planetas.aggregate([
  {
    $match: {
      rotation_period: { $ne: "unknown" } // Filtra valores válidos
    }
  },
  {
    $addFields: {
      rotation_int: { $toInt: "$rotation_period" } // Convierte a número
    }
  },
  {
    $sort: { rotation_int: 1 } // Ordena de menor a mayor
  },
  {
    $limit: 5 // Toma los 5 más pequeños
  }
])

//7. Calcular la población total de todos los planetas (ignorando “unknown”).
db.planetas.aggregate([
  {
    $match: {
      population: { $nin: ["unknown", null] } // Filtra valores inválidos
    }
  },
  {
    $group: {
      _id: null,
      totalPoblacion: {
        $sum: { $toLong: "$population" } // Convierte y suma
      }
    }
  }
])

//8. Agrupar por terreno y contar planetas, mostrando solo los terrenos con más de 2 planetas.
db.planetas.aggregate([
  {
    $unwind: "$terrain" // Separa cada terreno
  },
  {
    $group: {
      _id: "$terrain", // Agrupa por terreno
      total: { $sum: 1 } // Cuenta planetas
    }
  },
  {
    $match: {
      total: { $gt: 2 } // Solo terrenos con más de 2 planetas
    }
  }
])

//9. Encontrar cuántos planetas tienen superficie de agua igual a 0.
db.planetas.aggregate([
  {
    $match: { surface_water: "0" } // Filtra valor exacto
  },
  {
    $count: "total" // Cuenta resultados
  }
])

//10. Hacer una lista única de todas las URLs de películas que aparecen en todos los planetas.
db.planetas.aggregate([
  {
    $unwind: "$films" // Separa cada película
  },
  {
    $group: {
      _id: "$films" // Elimina duplicados
    }
  }
])

//11. Mostrar cada residente individualmente con su planeta correspondiente.
db.planetas.aggregate([
  {
    $unwind: "$residents" // Separa cada residente
  },
  {
    $project: {
      name: 1, // Nombre del planeta
      residente: "$residents" // URL del residente
    }
  }
])

//12. Contar cuántos residentes tiene cada planeta.
db.planetas.aggregate([
  {
    $project: {
      name: 1, // Nombre planeta
      numResidents: {
        $size: { $ifNull: ["$residents", []] } // Si residents es null → usa [] (array vacío)
      }
    }
  }
])

//13. Mostrar para cada planeta: nombre, número de películas y número de residentes.
db.planetas.aggregate([
    $project: {
      name: 1, // Nombre planeta
      numFilms: {
        $size: { $ifNull: ["$films", []] } // Si films es null → usa [] (array vacío)
      },
      numResidents: {
        $size: { $ifNull: ["$residents", []] } // Si residents es null → usa [] (array vacío)
    }
  }
])

//14. Encontrar planetas que aparezcan en más de 2 películas.
db.planetas.aggregate([
  {
    $project: {
      name: 1,
      numFilms: {
        $size: { $ifNull: ["$films", []] } // Si films es null o no existe → lo reemplaza por [] (array vacío)
      }
    }
  },
  {
    $match: {
      numFilms: { $gt: 2 } // Filtra >2 películas
    }
  }
])

//15. Calcular el promedio de residentes por planeta.
db.planetas.aggregate([
  {
    $group: {
      _id: null,
      promedioResidentes: {
        $avg: {
          $size: { $ifNull: ["$residents", []] } // Si residents es null → usa [] (array vacío)
        }
      }
    }
  }
])
```
</details>
