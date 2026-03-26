# Crear una Colección e Insertar un Documento 

1. Utilice el comando `use` para cambiar a una nueva base de datos llamada `bookstore`.
2. Inserta un único documento en una nueva colección llamada `books`.

  - title: The Great Gatsby
  - author: F. Scott Fitzgerald
  - year: 1925
  - genres: Classic, Fiction
  - stock: 10 

3. Agrega tres libros más a la colección `books` en un solo comando:

   - Book 1:
       - title: 1984
       - author: George Orwell
       - year: 1949
       - genres: Dystopian, Science Fiction
       - stock: 15
   - Book 2:
       - title: To Kill a Mockingbird
       - author: Harper Lee
       - year: 1960
       - genres: Classic, Fiction
       - stock: 5
   - Book 3:
       - title: Pride and Prejudice
       - author: Jane Austen
       - year: 1813
       - genres: Romance, Classic
       - stock: 12
4. Cuenta el número total de documentos en la colección.
5. Recupera todos los documentos de la colección `books`.
6. Recupera todos los libros del género `Classic`.


<details><summary>Mostrar Solución</summary>

```javascript
use bookstore

db.books.insertOne({
  title: "The Great Gatsby",
  author: "F. Scott Fitzgerald",
  year: 1925,
  genres: ["Classic", "Fiction"],
  stock: 10
})

db.books.insertMany([
  {
    title: "1984",
    author: "George Orwell",
    year: 1949,
    genres: ["Dystopian", "Science Fiction"],
    stock: 15
  },
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    year: 1960,
    genres: ["Classic", "Fiction"],
    stock: 5
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    year: 1813,
    genres: ["Romance", "Classic"],
    stock: 12
  }
])

db.books.countDocuments()

db.books.find()

db.books.find({ genres: "Classic" })
```
</details>
