# Lab06. Ejercicios con varias colecciones

Crear una nueva BBDD llamada 'sample_mflix' con las colecciones: 
- comments
- movies
- sessions
- theaters
- users


## Ejercicios de Actualización
Vamos a trabajar ahora con la colección movies de la BD `sample_mflix`

1. Actualiza el campo year de la pelicula de título “Civilization” a “1985”
2. Incrementar en 1 el número de comentarios (num_mflix_comments) de todas las películas del tipo (type) “movie”
3. Añadir un nuevo campo «pub_es» y con el valor “verdadero”
4. Renombra el nombre del campo num_mflix_comments a comentarios (en todas las películas)
5. Actualiza el campo comentarios multiplicándolo por un factor de 4 en las película “Civilization”
6. Actualiza el campo comentarios de todas las películas, sumándole 10
7. Actualiza el campo year de la película “Civilization”, estableciéndolo en el momento actual (timestamp)
8. Actualiza el campo cast de la película “Civilization” añadiendole el actor “Perico de los Palotes”
9. Actualiza el campo year de las peliculas con duración (runtime) mayor a 100 para que sea 100 (es decir, no habrá ninguna duración mayor que 100)
10. Actualiza todas las películas cuya duración (runtime) sea de 100, para que no tengan el género (genres) “Action”. Es decir, quitarle el género Action del array.

## Uso de $expr 
Usando la colección `movies`:
1. Contar cuántas películas tienen más años desde su estreno que comentarios.
2. Listar el titulo de las películas donde IMDb < Metacritic.
3. Contar películas con Metacritic > 80 (convertido a entero).
4. Listar el titulo de las películas con más de 10 comentarios (convertido a entero).
5. Listar el titulo y año de las películas estrenadas después del año 2000 y menos de 20 comentarios.
6. Buscar películas donde IMDb > Metacritic o comentarios > 50.
7. Contar películas con más de 2 géneros.
8. Listar titulo y año de películas cuyo año de estreno > longitud del título.
9. Contar películas con más de 5 palabras en el título.
10. Listar titulo y año de películas donde número de comentarios >= año estreno - 2000.
11. Contar películas con título más largo que cualquier otra película del mismo director.

## Uso de $regex 
Usando la colección `movies`:
1. Contar películas cuyo título empiece con “The”.
2. Listar películas cuyo título termine con “Man”.
3. Contar películas donde el campo plot contenga la palabra “love” (insensible a mayúsculas).
4. Listar películas cuyo título contenga “Star” o “Wars”.
5. Listar películas donde el título contenga un número.
6. Contar películas cuyo título termine con “Part 2” o “II”.
7. Listar películas cuyo director contenga apellido que empiece con S.
8. Contar películas donde el país de producción sea USA o Canadá (regex en el campo countries).
9. Listar películas cuyo título contenga caracteres especiales como ! o ?.
10. Contar películas cuyo título contenga minúsculas seguidas de mayúsculas (ej: iPhone style).
11. Listar películas donde cualquier palabra del título empiece con “A” o “E”.

Usando la colección `theater`:

12. Listar el id de los teatros donde el número de dígitos de zipcode sea mayor que 4.
13. Listar el id de los teatros teatros donde la longitud de city sea mayor a la longitud de state.


## Uso de sort() y limit() 
Usando la colección `movies`:
1. Listar el titulo y año de las 5 películas más recientes.
2. Listar el titulo y año de las 5 películas más antiguas.
3. Listar el titulo y numero de comentarios de las 10 películas con más comentarios.
4. Listar el titulo y el rating de las 5 películas mejor valoradas por IMDb.
5. Listar el titulo y año de las 5 películas más recientes de “Charles Chaplin”.

Usando la colección `comments`:

6. Listar los 5 comentarios más recientes (mostrar name y date).
7. Listar los 5 primeros comentarios en orden alfabético por name.

Usando la colección `users`:

8. Listar los 5 primeros usuarios en orden alfabético por name
9. Listar los usuarios cuyo name empiece con "J", ordenados alfabéticamente y mostrar solo 5
10. Listar todos los usuarios que tengan el campo password definido y mostrar solo los 5 primeros ordenados por name

## Ejercicios de Borrado
Usando la colección `movies`:

1. Borra una específica, usando su _id (busca uno cualquiera)
2. Borra las que sean del año 1985
3. Borra las que sean el género Action
4. Borra las que tengan una puntuación (rating) en imdb menor a 3.4
5. Borra las que sean se hayan lanzado (released) antes del 15 de Julio del 2001 (ISODate(«2001-07-15»))
6. Borra la que se titula Meshes of the Afternoon
7. Borra sólo una que tenga el campo pub_es en verdadero (true)
8. Borra las que haya dirigido Steven Spielberg
9.  Borra las películas de entre los años 1950 y 1970 y que tengan menos de 80 votos en imdb
10. Borrar todos los documentos de la colección

---

<details><summary>Solución Ejercicios de Actualización</summary>

```javascript
use sample_mflix
show collections

//1. Actualiza el campo year de la pelicula de título “Civilization” a “1985”
db.movies.updateOne({title: "Civilization"},{$set: {year: 1985}});
//2. Incrementar en 1 el número de comentarios (num_mflix_comments) de todas las películas del tipo (type) “movie”
db.movies.updateMany({type: "movie"},{$inc: {num_mflix_comments: 1}});
//3. Añadir un nuevo campo «pub_es» y con el valor “verdadero”
db.movies.updateMany({},{$set: {pub_es: true}});
//4. Renombra el nombre del campo num_mflix_comments a comentarios (en todas las películas)
db.movies.updateMany({},{$rename: {num_mflix_comments: "comentarios"}});
//5. Actualiza el campo comentarios multiplicándolo por un factor de 4 en las película “Civilization”
db.movies.updateOne({title: 'Civilization'},{$mul: {comentarios: 4}});
//6. Actualiza el campo comentarios de todas las películas, sumándole 10
db.movies.updateMany({},{$inc: {comentarios: 10}});
//7. Actualiza el campo year de la película “Civilization”, estableciéndolo en el momento actual (timestamp)
db.movies.updateOne({title: 'Civilization'},{$currentDate: {year: true }});
//8. Actualiza el campo cast de la película “Civilization” añadiendole el actor “Perico de los Palotes”
db.movies.updateOne({title: 'Civilization'},{$push: {cast: "Perico de los Palotes" }});
//9. Actualiza el campo year de las peliculas con duración (runtime) mayor a 100 para que sea 100 (es decir, no habrá ninguna duración mayor que 100)
db.movies.updateMany({runtime: {$gt: 100}}, {$set: {runtime: 100}});
//10. Actualiza todas las películas cuya duración (runtime) sea de 100, para que no tengan el género (genres) “Action”. Es decir, quitarle el género Action del array.
db.movies.updateMany({runtime: 100}, {$pull: {genres: 'Action'}});
```
</details>

---

<details><summary>Solución de ejercicios con $expr </summary>

```javascript
// 1. Contar cuántas películas tienen más años desde su estreno que comentarios.
db.movies.countDocuments({
  $expr: {
    $gt: [
      {
        $subtract: [
          { $year: "$$NOW" },
          "$year"
        ]
      },
      "$num_mflix_comments"
    ]
  }
})

// 2. Listar el titulo de las películas donde IMDb < Metacritic.
db.movies.find({ $expr: { $lt: ["$imdb.rating", "$metacritic"] } },{title:1,_id:0})

// 3. Contar películas con Metacritic > 80 (convertido a entero).
db.movies.countDocuments({ $expr: { $gt: [{ $toInt: "$metacritic" }, 80] } })

// 4. Listar el titulo de las películas con más de 10 comentarios (convertido a entero).
db.movies.find({ $expr: { $gt: [{ $toInt: "$num_mflix_comments" }, 10] } },{title:1,_id:0})

// 5. Listar el titulo y año de las películas estrenadas después del año 2000 y menos de 20 comentarios.
db.movies.find({ $expr: { $and: [{ $gt: ["$year", 2000] }, { $lt: ["$num_mflix_comments", 20] }] } },{title:1, year:1,_id:0})

// 6. Buscar películas donde IMDb > Metacritic o comentarios > 50.
db.movies.find({ $expr: { $or: [{ $gt: ["$imdb.rating", "$metacritic"] }, { $gt: ["$num_mflix_comments", 50] }] } }, {title:1, _id:0})

// 7. Contar películas con más de 2 géneros.
db.movies.countDocuments({
  $expr: {
    $and: [
      { $isArray: "$genres" },        // Se asegura de que genres exista y sea un array
      { $gt: [{ $size: "$genres" }, 2] }  // Solo cuenta los que tienen más de 2 elementos
    ]
  }
})

// 8. Listar titulo y año de películas cuyo año de estreno > longitud del título.
db.movies.find({ $expr: { $gt: ["$year", { $strLenCP: "$title" }] } }, {title:1, year:1, _id:0})

// 9. Contar películas con más de 5 palabras en el título.
db.movies.countDocuments({ $expr: { $gt: [{ $size: { $split: ["$title", " "] } }, 5] } })

// 10. Listar titulo y año de películas donde número de comentarios >= año estreno - 2000.
db.movies.find({ $expr: { $gte: ["$num_mflix_comments", { $subtract: ["$year", 2000] }] } } , {title:1, year:1, _id:0})

```
</details>

---

<details><summary>Solución de ejercicios con $regex </summary>

```javascript
// 1. Contar películas cuyo título empiece con “The”.
db.movies.countDocuments({ title: { $regex: /^The/ } })

//2. Mostrar el título de las películas cuyo título termine con “Man”.
db.movies.find({ title: { $regex: /Man$/ } }, {title:1, _id:0})

//3. Contar películas donde el campo plot contenga la palabra “love” (insensible a mayúsculas).
db.movies.countDocuments({ plot: { $regex: /love/i } })

//4. Mostrar el título de las películas cuyo título contenga “Star” o “Wars”.
db.movies.find({ title: { $regex: /(Star|Wars)/ } },{title:1, _id:0})

//5. Mostrar el título de las películas donde el título contenga un número.
db.movies.find({ title: { $regex: /\d/ } },{title:1, _id:0})

//6. Contar películas cuyo título termine con “Part 2” o “II”.
db.movies.countDocuments({ title: { $regex: /(Part 2|II)$/ } })

//7. Mostrar el título y el director de las películas cuyo director contenga apellido que empiece con S.
db.movies.find(
  {
    directors: {
      $elemMatch: {
        $regex: /\sS/i
      }
    }
  },
  { title: 1, directors: 1, _id: 0 }
)
//\s → espacio antes del apellido

//8. Contar películas donde el país de producción sea USA o Canadá.
db.movies.countDocuments({ countries: { $regex: /(USA|Canada)/ } })

//9. Mostrar el título de las películas cuyo título contenga caracteres especiales como ! o ?.
db.movies.find({ title: { $regex: /[!?]/ } },{title:1, _id:0})

//10. Contar películas cuyo título contenga minúsculas seguidas de mayúsculas (ej: iPhone style).
db.movies.countDocuments({ title: { $regex: /[a-z][A-Z]/ } })

//11. Mostrar el título de las películas donde cualquier palabra del título empiece con “A” o “E”.
db.movies.find({ title: { $regex: /\b[AaEe]\w*/ } },{title:1, _id:0})

//12. Listar el id de los teatros donde el número de dígitos de zipcode sea mayor que 4.
db.theaters.find(
  { 
    "location.address.zipcode": { $exists: true, $type: "string" },
    $expr: { 
      $gt: [ { $strLenCP: "$location.address.zipcode" }, 4 ] 
    } 
  },
  { theaterId: 1, "location.address.zipcode": 1, _id: 0 }
)

//13. Listar el id de los teatros teatros donde la longitud de city sea mayor a la longitud de state.
db.theaters.find(
  { 
    $expr: { 
      $gt: [
        { $strLenCP: "$location.address.city" }, 
        { $strLenCP: "$location.address.state" }
      ] 
    } 
  },
  { theaterId: 1, "location.address.city": 1, "location.address.state":1,   _id: 0 }
)
```
</details>

---

<details><summary>Solución de ejercicios con sort() + limit()</summary>

```javascript
// 1 Listar el titulo y año de las 5 películas más recientes.
db.movies.find({},{title: 1, year: 1}).sort({ year: -1 }).limit(5)
// 2 Listar el titulo y año de las 5 películas más antiguas.
db.movies.find({},{title: 1, year: 1}).sort({ year: 1 }).limit(5)
// 3 Listar el titulo y numero de comentarios de las 10 películas con más comentarios.
db.movies.find({},{ title: 1, num_mflix_comments: 1, _id: 0 }).sort({ num_mflix_comments: -1 }).limit(10)
// 4 Listar el titulo y el rating de las 5 películas mejor valoradas por IMDb.
db.movies.find(
  { "imdb.rating": { $exists: true } },
  { title: 1, "imdb.rating": 1, _id: 0 }
).sort({ "imdb.rating": -1 }).limit(5)

// 5 Listar el titulo y año de las 5 películas más recientes de “Charles Chaplin”.
db.movies.find(
  { directors: "Charles Chaplin" },
  { title: 1, year: 1, _id: 0 }     
)
.sort({ year: -1 })                     
.limit(5)  

// 6 Listar los 5 comentarios más recientes (mostrar name y date).
db.comments.find(
  {},                       // sin filtro, todos los documentos
  { name: 1, date: 1, _id: 0 }  // proyección: solo name y date
).sort({ date: -1 }).limit(5)

// 7 Listar los 5 primeros comentarios en orden alfabético por name.
db.comments.find(
  {},
  { name: 1, _id: 0 }
).sort({ name: 1 }).limit(5)

// 8 Listar los 5 primeros usuarios en orden alfabético por name
db.users.find({}, { name: 1, email: 1, _id: 0 }).sort({ name: 1 }).limit(5)

// 9 Listar los usuarios cuyo name empiece con "J", ordenados alfabéticamente y mostrar solo 5
db.users.find({ name: { $regex: "^J", $options: "i" } }, { name: 1, email: 1, _id: 0 }).sort({ name: 1 }).limit(5)

// 10 Listar todos los usuarios que tengan el campo password definido y mostrar solo los 5 primeros ordenados por name
db.users.find({ password: { $exists: true } }, { name: 1, email: 1, _id: 0 }).sort({ name: 1 }).limit(5)
```

</details>

---

<details><summary>Solución Ejercicios de Borrado</summary>

```javascript
//1. Borra una específica, usando su _id (busca uno cualquiera)
db.movies.deleteOne({ _id: ObjectId("573a1390f29313caabcd42e8") });

//2. Borra las que sean del año 1985
db.movies.deleteMany({ year: 1985});

//3. Borra las que sean el género Action
db.movies.deleteMany({ genres: "Action" });

//4. Borra las que tengan una puntuación (rating) en imdb menor a 3.4
db.movies.deleteMany({"imdb.rating": {$lt: 3.4}});

//5. Borra las que sean se hayan lanzado (released) antes del 15 de Julio del 2001 (ISODate(«2001-07-15»))
db.movies.deleteMany({ released: { $lt: ISODate("2001-07-15") } });

//6. Borra la que se titula Meshes of the Afternoon
db.movies.deleteOne({title: 'Meshes of the Afternoon'});

//7. Borra sólo una que tenga el campo pub_es en verdadero (true)
db.movies.deleteOne({pub_es: {$exists: 1}});

//8. Borra las que haya dirigido Steven Spielberg
db.movies.deleteMany({ directors: "Steven Spielberg" });

//9.  Borra las películas de entre los años 1950 y 1970 y que tengan menos de 80 votos en imdb
db.movies.deleteMany({"imdb.votes": {$lt: 80}, year: {$gt: 1950}, year: {$lt: 1970}});

//10. Borrar todos los documentos de la colección
db.movies.deleteMany({});
```
</details>
