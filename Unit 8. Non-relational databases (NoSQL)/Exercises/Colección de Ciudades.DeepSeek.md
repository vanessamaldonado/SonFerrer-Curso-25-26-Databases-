# Ejercicios de MongoDB: Consultas sobre Colección de Ciudades: DeepSeek

**Contexto:**

Partiendo de la colección de `ciudades`, que contiene documentos con el siguiente formato:

```json
{
    "name": "Nombre de la ciudad",
    "country": "Código de país (2 letras)",
    "timezone": "Zona horaria",
    "population": número ,
    "location": {
        "longitude": número ,
        "latitude": número
     }
}
```

Ejemplos de países presentes: AD (Andorra), AE (Emiratos Árabes), AF (Afganistán), AG (Antigua), AL (Albania), AM (Armenia), AN (Antillas), AO (Angola), AQ (Antártida), AR (Argentina).


## Ejercicio 1: Consultas Básicas

Realiza las siguientes consultas utilizando operaciones básicas de MongoDB (findOne, find,
distinct, countDocuments). En algunas deberás usar operadores como $or, $in, $gt, $lt, $regex,
etc., y aplicar funciones sobre el cursor como sort(), limit(), skip().

1. Encuentra una ciudad de Argentina con más de 500,000 habitantes.
2. Encuentra todas las ciudades de Andorra (código AD) con menos de 5,000 habitantes.
3. Muestra los nombres de todas las ciudades de Albania (AL) o Armenia (AM).
4. Cuenta cuántas ciudades tienen más de 1 millón de habitantes.
5. Encuentra las primeras 10 ciudades ordenadas por nombre (alfabético ascendente).
6. Obtén todas las ciudades cuya población sea exactamente 0. 
7. Encuentra ciudades que tengan en su nombre la palabra “San” (puede estar al principio, medio o final).
8. Muestra todas las ciudades de Afganistán (AF) ordenadas por población de mayor a menor, mostrando solo el nombre y la población.
9. Obtén las ciudades 11 a 20 más pobladas del dataset (hint: usar sort, skip, limit).
10. Cuenta cuántas ciudades hay en cada uno de estos países: AD, AE, AF, AG, AL.
11. Encuentra ciudades cuyo nombre empiece por “Villa” y estén en Argentina (AR).
12. Obtén una lista sin repeticiones de todos los códigos de país presentes en la colección.
13. Encuentra ciudades con población entre 50,000 y 100,000 habitantes.
14. Cuenta cuántas ciudades no tienen población registrada (campo population no existe o es null).
15. Encuentra la ciudad más poblada de Emiratos Árabes (AE) y muestra solo su nombre y población.

## Ejercicio 2: Agregaciones

Realiza las siguientes consultas utilizando el framework de aggregation de MongoDB. Deberás
usar principalmente $group, $match, $project, $sort, $limit, $skip, $unwind.

1. Calcula la población total de cada país.
2. Obtén el promedio de población de las ciudades por país, solo para países con más de 5 ciudades en la colección.
3. Encuentra los 5 países con más ciudades en la colección.
4. Para cada país, encuentra la ciudad más poblada y su población.
5. Lista las ciudades ordenadas por país y, dentro de cada país, por población descendente.
6. Obtén los 3 países con menor población total.
7. Encuentra países donde ninguna ciudad supere los 100,000 habitantes.
8. Para cada país, calcula la diferencia entre la ciudad más y menos poblada.
9. Obtén las 10 ciudades más pobladas usando aggregate (no find).
10. Calcula cuántas ciudades tiene cada país, ordenado de mayor a menor.
11. Encuentra países donde al menos una ciudad tenga más de 500,000 habitantes.
12. Obtén el top 3 de ciudades más pobladas por país.
13. Calcula la media y desviación estándar de la población de las ciudades por país (pista: investiga $stdDevPop).

---

<details><summary>Ejercicio 1: Consultas Básicas</summary>

```javascript
//1. Encuentra una ciudad de Argentina con más de 500,000 habitantes.
db.ciudades.findOne({
  country: "AR", // Filtra ciudades de Argentina
  population : {$gt: 500000} // Solo las que tienen más de 500.000 habitantes
})

//2. Encuentra todas las ciudades de Andorra (código AD) con menos de 5,000 habitantes.
db.ciudades.find({
  country: "AD", // Filtra Andorra
  population : {$lt: 5000} // Población menor a 5000
})

//3. Muestra los nombres de todas las ciudades de Albania (AL) o Armenia (AM).
db.ciudades.find({
  country: {$in: ["AL", "AM"]} // Filtra países dentro del array
}, {name: 1, _id: 0}) // Muestra solo el campo name (sin _id)

//Alternativa con $or:
db.ciudades.find({
  $or: [
    { country: "AL"}, // Albania
    { country: "AM"}  // Armenia
  ]
}, {name: 1, _id: 0}) // Proyección: solo nombres

//4. Cuenta cuántas ciudades tienen más de 1 millón de habitantes.
db.ciudades.countDocuments({
  population : {$gt: 1000000} // Condición de población > 1 millón
})

//5. Encuentra las primeras 10 ciudades ordenadas por nombre (alfabético ascendente).
db.ciudades.find({}, {name: 1, _id: 0}) // Devuelve todas pero solo el campo name
  .sort({ name: 1}) // Orden alfabético ascendente
  .limit(10) // Limita a 10 resultados

//6. Obtén todas las ciudades cuya población sea exactamente 0.
db.ciudades.find({
 population : 0 // Filtra ciudades con población igual a 0
})

//7. Encuentra ciudades que tengan en su nombre la palabra “San” (puede estar al principio, medio o final).
db.ciudades.find({
  name: {$regex: /San/i} // Busca "San" en cualquier parte del nombre (i = ignora mayúsculas)
})
//Alternativa exacta:
db.ciudades.find({
  name: {$regex: "San"} // Igual pero sensible a mayúsculas/minúsculas
})

//8. Muestra todas las ciudades de Afganistán (AF) ordenadas por población de mayor a menor, mostrando solo el nombre y la población.
db.ciudades.find(
  {country: "AF"}, // Filtra Afganistán
  {name: 1, population : 1, _id: 0} // Muestra solo nombre y población
).sort({ population : -1}) // Ordena de mayor a menor población

//9. Obtén las ciudades 11 a 20 más pobladas del dataset (hint: usar sort, skip, limit).
db.ciudades.find({}, {name: 1, population : 1, _id: 0}) // Muestra nombre y población
  .sort({ population : -1}) // Ordena de mayor a menor
  .skip(10) // Salta las 10 primeras
  .limit(10) // Devuelve las siguientes 10 (11 a 20)


//10. Cuenta cuántas ciudades hay en cada uno de estos países: AD, AE, AF, AG, AL.
// Opción 1: Varias consultas
db.ciudades.countDocuments({ country: "AD"}) // Cuenta ciudades de Andorra
db.ciudades.countDocuments({ country: "AE"}) // Cuenta ciudades de Emiratos
// ... etc

// Opción 2: Para mejorarlo necesitaríamos aggregate:
db.ciudades.aggregate([
 {$match: {country: {$in: ["AD","AE","AF","AG","AL"]}}}, // Filtra esos países
 {$group: {
   _id: "$country", // Agrupa por país
   total: {$sum: 1} // Cuenta ciudades por país
 }}
])

//11. Encuentra ciudades cuyo nombre empiece por “Villa” y estén en Argentina (AR).
db.ciudades.find({
  name: {$regex: /^Villa/}, // Nombre que empieza por "Villa"
  country: "AR" // Filtra Argentina
})

//12. Obtén una lista sin repeticiones de todos los códigos de país presentes en la colección.
db.ciudades.distinct("country") // Devuelve valores únicos del campo country

//13. Encuentra ciudades con población entre 50,000 y 100,000 habitantes.
db.ciudades.find({
 population : {
   $gte: 50000, // Mayor o igual a 50k
   $lte: 100000 // Menor o igual a 100k
 }
})
//14. Cuenta cuántas ciudades no tienen población registrada (campo population no existe o es null).
db.ciudades.countDocuments({
  $or: [
    { population : {$exists: false}}, // Campo no existe
    { population : null} // Es null
  ]
})

//15. Encuentra la ciudad más poblada de Emiratos Árabes (AE) y muestra solo su nombre y población.
db.ciudades.find(
  {country: "AE"}, // Filtra Emiratos Árabes
  {name: 1, population : 1, _id: 0} // Muestra nombre y población
).sort({ population : -1}) // Ordena de mayor a menor
 .limit(1) // Devuelve solo la primera (la más poblada)
```
</details>
