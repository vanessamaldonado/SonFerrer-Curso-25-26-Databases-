# Crear una Colección e Insertar un Documento 

1. Utilice el comando `use` para cambiar a una nueva base de datos llamada `my_store`.
2. Crea una colección llamada `products`. 
3. Lista todas las colecciones en la base de datos actual para verificar que se creó `products`.
4. Utilice el método `insertOne()` para añadir el siguiente documento a la colección `products`:
   - name: Laptop
   - price: 1200
   - category: Electronics
5. Utilice el método `insertMany()` para añadir los siguientes documentos a la colección `products`:
   
   - Product1: 
      - name: Keyboard
      - price: 75
      - category: Electronics
   - Product2:
      - name: Desk Chair
      - price: 150
      - category: Furniture
6.  Comprueba el número total de documentos en la colección `products`
7.  Utiliza el método `find()` para ver todos los documentos en la colección `products`. 
8.  Busca todos los productos de la categoría `Electronics`.
9.  Crea una nueva colección llamada `temp_data`;
10. Usa el método `drop()` en la colección `temp_data` para eliminarla.
11. Lista todas las colecciones de la base de datos.


<details><summary>Mostrar Solución</summary>

```javascript
use my_store

db.createCollection("products")

show collections

db.products.insertOne({
  name: "Laptop",
  price: 1200,
  category: "Electronics"
})

db.products.insertMany([
  {
    name: "Keyboard",
    price: 75,
    category: "Electronics"
  },
  {
    name: "Desk Chair",
    price: 150,
    category: "Furniture"
  }
])

db.products.countDocuments()

db.products.find().pretty()

db.products.find({ category: "Electronics" }).pretty()

db.createCollection("temp_data")

db.temp_data.drop()

show collections
```
</details>
