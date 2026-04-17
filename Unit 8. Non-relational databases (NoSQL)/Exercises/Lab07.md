# Lab07. Ejercicios con consultas en arrays

## Ejercicios de Arrays
Vamos a trabajar ahora con la colección establishments de la BD `restaurant`

1. Encuentra los restaurantes cuya coordenada sea exactamente: -73.856077, 40.848447
2. Encuentra todos los restaurantes donde alguna coordenada sea: 40.848447
3. Encuentra restaurantes donde alguna coordenada sea uno de estos valores: 40.848447 o 40.662942
4. Encuentra restaurantes cuya coordenada contenga ambos valores, sin importar el orden: -73.856077 y 40.848447
5. Encuentra restaurantes que tengan exactamente 5 calificaciones en grades.
6. Encuentra restaurantes que tengan alguna calificación con: grade: "B"
7. Encuentra restaurantes que tengan una misma calificación con: grade: "B" y score mayor que 10.
8. Encuentra restaurantes donde exista una calificación que cumpla: grade: "A" y score menor que 5.
9. Encuentra restaurantes que tengan una calificación posterior a: 2013-01-01 y con grade: "A" en ese mismo registro.
10. Encuentra restaurantes donde: grades tenga al menos una nota "B" y el array tenga más de 3 elementos.
11. Encuentra restaurantes que NO tengan ninguna calificación "C".
12. Encuentra restaurantes donde exista una calificación que cumpla: score entre 10 y 20 y grade distinto de "A".

---

<details><summary>Solución Ejercicios de Arrays</summary>

```javascript
use restuarant

//1. Encuentra los restaurantes cuya coordenada sea exactamente: -73.856077, 40.848447
db.establishments.find({
  'address.coord': { $eq: [-73.856077, 40.848447] }
})

//2. Encuentra todos los restaurantes donde alguna coordenada sea: 40.848447
db.establishments.find({
  'address.coord': 40.848447
})

//3. Encuentra restaurantes donde alguna coordenada sea uno de estos valores: 40.848447 o 40.662942
db.establishments.find({
  'address.coord': { $in: [40.848447, 40.662942] }
})

//4. Encuentra restaurantes cuya coordenada contenga ambos valores, sin importar el orden: -73.856077 y 40.848447
db.establishments.find({
  'address.coord': { $all: [-73.856077, 40.848447] }
})

//5. Encuentra restaurantes que tengan exactamente 5 calificaciones en grades.
db.establishments.find({
  grades: { $size: 5 }
})

//6. Encuentra restaurantes que tengan alguna calificación con: grade: "B"
db.establishments.find({
  'grades.grade': 'B'
})

//7. Encuentra restaurantes que tengan una misma calificación con: grade: "B" y score mayor que 10.
db.establishments.find({
  grades: {
    $elemMatch: {
      grade: 'B',
      score: { $gt: 10 }
    }
  }
})

//8. Encuentra restaurantes donde exista una calificación que cumpla: grade: "A" y score menor que 5.
db.establishments.find({
  grades: {
    $elemMatch: {
      grade: 'A',
      score: { $lt: 5 }
    }
  }
})

//9. Encuentra restaurantes que tengan una calificación posterior a: 2013-01-01 y con grade: "A" en ese mismo registro.
db.establishments.find({
  grades: {
    $elemMatch: {
      grade: 'A',
      date: { $gt: new Date('2013-01-01') }
    }
  }
})
//10. Encuentra restaurantes donde: grades tenga al menos una nota "B" y el array tenga más de 3 elementos.
db.establishments.find({
  'grades.grade': 'B',
  'grades.3': { $exists: true }
})

//11. Encuentra restaurantes que NO tengan ninguna calificación "C".
db.establishments.find({
  'grades.grade': { $ne: 'C' }
})

//12. Encuentra restaurantes donde exista una calificación que cumpla: score entre 10 y 20 y grade distinto de "A".
db.establishments.find({
  grades: {
    $elemMatch: {
      score: { $gte: 10, $lte: 20 },
      grade: { $ne: 'A' }
    }
  }
})

```
</details>
