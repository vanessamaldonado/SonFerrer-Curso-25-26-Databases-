# Lab05. Ejercicios de Consultas

Trabajaremos sobre la colección `restaurants`. Se trata de mostrar los documentos (recuerda que la búsqueda devuelve una colección de documentos):

## Parte 1: Ejercicios de Consultas
1. Todos los documentos de la colección restaurants
2. El primer documento de la colección
3. Los que sean de cocina griega (Greek)
4. Los que sean de cocina griega y tengan una nota (grade) de B
5. Los que estén en una determinada ciudad
6. Los que tengan restaurante id 40370781, 40369158 y 40367677
7. Los que hayan tenido una valoración (score) de al menos 30 puntos
8. Los que sean de cocina Italian o Mexican
9. Los que sean de cocina Italina o Mexican y estén en Manhattan (borough)
10. Los peores (con algún score menor de 5) de los de comida italiana

## Parte 2: Ejercicios de Proyección
Los ejercicios de proyección buscan mostrar sólo algunos campos de los documentos que resultan de la consulta. Seguimos trabajando con la colección `restaurants`

1. ¿Cuales son los nombres de los restaurantes que tenemos almacenados?
2. ¿Y qué tipos de cocina?
3. ¿Y el nombre de restaurante, el tipo de cocina y barrio (borough) en el que está?
4. ¿Cuales son los nombres de los restaurantes que ofrecen comida italiana?
5. ¿Cual es el nombre, la calle y el barrio de los peores (con algún score menor de 5) de los de comida italiana?

---


<details><summary>Solución Parte 1</summary>

```javascript
use restaurants

//1. Todos los documentos de la colección restaurants
db.establishments.find();

//2. El primer documento de la colección
db.establishments.findOne();

//3. Los que sean de cocina griega (Greek)
db.establishments.find({cuisine: 'Greek'});

//4. Los que sean de cocina griega y tengan una nota (grade) de B
db.establishments.find({cuisine: 'Greek', "grades.grade": 'B'});

//5. Los que estén en una determinada dirección ('Stillwell Avenue')
db.establishments.find({ "address.street": "Stillwell Avenue" })

//6. Los que tengan restaurante id 40370781, 40369158 y 40367677
db.establishments.find({restaurant_id: {$in: ['40370781','40369158','40367677']}});

//7. Los que hayan tenido una valoración (score) de al menos 30 puntos
db.establishments.find({score: {$gt 30}});

//8. Los que sean de cocina Italian o Mexican
db.establishments.find({ $or: [ { cuisine: "Italian" }, { cuisine: "Mexican" } ] })

//9. Los que sean de cocina Italina o Mexican y estén en Manhattan (borough)
db.establishments.find({ borough: 'Manhattan', $or: [ { cuisine: "Italian" }, { cuisine: "Mexican" } ]})

//10. Los peores (con algún score menor de 5) de los de comida italiana
db.establishments.find({ $and: [ {cuisine: "Italian"} , {"grades.score": {$lt: 5}} ]})
```
</details>

---


<details><summary>Solución Parte 2</summary>

```javascript
//1 ¿Cuales son los nombres de los restaurantes que tenemos almacenados?
db.establishments.find({}, {name: 1});

//2 ¿Y qué tipos de cocina?
db.establishments.find({}, {cuisine: 1,_id: 0});

//3 ¿Y el nombre de restaurante, el tipo de cocina y barrio (borough) en el que está?
db.establishments.find({}, {name: 1, cuisine: 1, borough: 1, _id: 0});

//4 ¿Cuales son los nombres de los restaurantes que ofrecen comida italiana?
db.establishments.find({cuisine: 'Italian'}, {name: 1, _id: 0});

//5 ¿Cual es el nombre, la calle y el barrio de los peores (con algún score menor de 5) de los de comida italiana?
db.establishments.find({ $and: [ {cuisine: "Italian"} , {"grades.score": {$lt: 5}} ]}, {name: 1, "address.street": 1, "borough": 1, _id: 0})
```

</details>
