# Lab08. Ejercicios repaso

## Ejercicios con Base de datos `restaurant`

1. Escribe una consulta de MongoDB para encontrar todos los restaurantes chinos en Brooklyn.
2. Escribe una consulta de MongoDB para encontrar el nombre, la dirección y el tipo de cocina de los restaurantes que incluyan la palabra "Pizza" en su cuisine.
3. Escribe una consulta de MongoDB para encontrar el nombre, la dirección y el tipo de cocina de los restaurantes cuyo tipo de cocina termine con la letra 'y'.
4. Escribe una consulta de MongoDB para encontrar el nombre y la dirección de los restaurantes cuya cocina comience con la letra 'B'.
5. Escribe una consulta de MongoDB para encontrar el nombre y la dirección de los restaurantes que tienen la palabra "coffee" en su nombre.
6. Escribe una consulta de MongoDB para encontrar el nombre, la dirección y las calificaciones de los restaurantes que tengan al menos una calificación 'A', ninguna calificación 'B' y ninguna calificación 'C'.
7. Escribe una consulta de MongoDB para encontrar el nombre, la dirección y las calificaciones de los restaurantes que tengan al menos una calificación 'A' y ninguna calificación 'C'.
8. Escribe una consulta de MongoDB para encontrar el nombre y la dirección de los restaurantes que recibieron una calificación de 'B' o 'C' en una fecha específica ISODate("2013-04-05").
9.  Escribe una consulta de MongoDB para encontrar los restaurantes que tengan todas las calificaciones con una puntuación superior a 5 y que estén ubicados en el distrito de Manhattan o Brooklyn.
10. Escribe una consulta de MongoDB para encontrar el nombre del restaurante, el distrito, la longitud, la latitud y el tipo de cocina de aquellos restaurantes que contengan "Mad" como las tres primeras letras de su nombre.
11. Escribe una consulta de MongoDB para encontrar el nombre del restaurante, el distrito, la longitud, la actitud y el tipo de cocina de aquellos restaurantes que contengan las tres primeras letras "mon" en su nombre.

## Ejercicios con Base de datos `sample_mflix` colección `movies`

1. Encuentra todas las películas con título, idiomas, fecha de estreno, duración, directores, guionistas y países de la colección 'movies' en MongoDB que tengan una duración entre 60 y 90 minutos.
2. Devuelve todas las películas con título, idiomas, sinopsis completa, fecha de estreno, directores, guionistas y países de la colección 'movies' en MongoDB donde se mencione la palabra "metal" en la sinopsis completa.
3. Devuelve todas las películas con título, idiomas, argumento, fecha de estreno, directores, guionistas y países de la colección 'movies' en MongoDB donde se mencione la palabra "beer" en el argumento.
4. Encuentra todas las películas con título, idiomas, argumento completo, fecha de estreno, directores, guionistas y países de la colección 'movies' en MongoDB que tengan un argumento completo que contenga la palabra "fire".
5. Recupera todas las películas con título, idiomas, fecha de estreno, año, directores, guionistas y países de la colección 'movies' en MongoDB que se estrenaron antes del año 1900.

---

<details><summary>Mostrar Solución Ejercicios con Base de datos `restaurant`</summary>

```javascript
// 1. Escribe una consulta de MongoDB para encontrar todos los restaurantes chinos en Brooklyn.
db.establishments.find({"borough": "Brooklyn", "cuisine": "Chinese"})

//2. Escribe una consulta de MongoDB para encontrar el nombre, la dirección y el tipo de cocina de los restaurantes que incluyan la palabra "Pizza" en su menú.
db.establishments.find(
    { cuisine: { $regex: /Pizza/i } },
    { name: 1, address: 1, cuisine: 1, _id: 0 }
)

//3. Escribe una consulta de MongoDB para encontrar el nombre, la dirección y el tipo de cocina de los restaurantes cuyo tipo de cocina termine con la letra 'y'.
db.establishments.find(
{ cuisine: { $regex: /y$/i } },
{ 
    name: 1, 
    address: 1,
    cuisine: 1, 
    _id: 0 }
)

//4. Escribe una consulta de MongoDB para encontrar el nombre y la dirección de los restaurantes cuya cocina comience con la letra 'B'.
db.establishments.find(
	{ "cuisine": { $regex: /^B/ } }, 
	{ 
        name: 1, 
	    address: 1,
	    cuisine : 1, 
	    _id: 0 }
)

//5. Escribe una consulta de MongoDB para encontrar el nombre y la dirección de los restaurantes que tienen la palabra "coffee" en su nombre.
db.establishments.find({ name: { $regex: /coffee/i } }, { name: 1, address: 1 })

//6. Escribe una consulta de MongoDB para encontrar el nombre, la dirección y las calificaciones de los restaurantes que tengan al menos una calificación 'A', ninguna calificación 'B' y ninguna calificación 'C'.
db.establishments.find({
  $and: [
    { "grades.grade": "A" },
    { "grades.grade": { $not: { $eq: "B" } } },
    { "grades.grade": { $not: { $eq: "C" } } }
  ]
},
{ name: 1, address: 1, "grades.grade":1, _id: 0 })

//7. Escribe una consulta de MongoDB para encontrar el nombre, la dirección y las calificaciones de los restaurantes que tengan al menos una calificación 'A' y ninguna calificación 'C'.
db.establishments.find({
  $and: [
    { "grades.grade": "A" },
    { "grades.grade": { $not: { $eq: "C" } } }
  ]
},
{ name: 1, address: 1, "grades.grade":1, _id: 0 })

//8. Escribe una consulta de MongoDB para encontrar el nombre y la dirección de los restaurantes que recibieron una calificación de 'B' o 'C' en una fecha específica ISODate("2013-04-05").
db.establishments.find(
   { 
     "grades": { 
       $elemMatch: { 
         "date": ISODate("2013-04-05"), 
         "grade": { $in: [ "B", "C" ] } 
       } 
     } 
   },
   { 
     "name": 1, 
     "address": 1 
   }
)

//9. Escribe una consulta de MongoDB para encontrar los restaurantes que tengan todas las calificaciones con una puntuación superior a 5 y que estén ubicados en el distrito de Manhattan o Brooklyn.
db.establishments.find({
  "borough": {
    "$in": ["Manhattan", "Brooklyn"]
  },
  "grades": {
    "$not": {
      "$elemMatch": {
        "score": {
          "$lte": 5
        }
      }
    }
  }
})

//10. Escribe una consulta de MongoDB para encontrar el nombre del restaurante, el distrito, la longitud, la latitud y el tipo de cocina de aquellos restaurantes que contengan "Mad" como las tres primeras letras de su nombre.
db.establishments.find(
                   { name : 
                     { $regex : /^Mad/i, } 
                   },
                       {
                         "name":1,
                         "borough":1,
                         "address.coord":1,
                         "cuisine" :1
                        }
                   );

//11. Escribe una consulta de MongoDB para encontrar el nombre del restaurante, el distrito, la longitud, la actitud y el tipo de cocina de aquellos restaurantes que contengan las tres primeras letras "mon" en su nombre.
db.establishments.find(
                   { name : 
                     { $regex : "mon.*", $options: "i" } 
                   },
                       {
                         "name":1,
                         "borough":1,
                         "address.coord":1,
                         "cuisine" :1
                        }
                   );


```
</details>
