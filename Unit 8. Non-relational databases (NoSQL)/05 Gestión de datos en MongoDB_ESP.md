# 1. Gestión de datos en MongoDB

Las operaciones fundamentales en cualquier base de datos son crear, leer, actualizar y borrar, conocidas por el acrónimo **CRUD**, que toma las iniciales de las palabras en inglés: Create, Read, Update y Delete. 

El modelo de datos flexible de MongoDB facilita la realización de estas tareas :

- *Create*: Permite añadir nuevos datos.
- *Read*: Permite recuperar y visualizar datos basándose en ciertos criterios de búsqueda.
- *Update*: Permite modificar datos ya existentes, ya sea para corregir errores o para mantenerlos al día.
- *Delete*: Permite borrar datos de la base de datos.


## 1.2 Documentos: Añadir, modificar y borrar

Un documento en MongoDB puede definirse como un conjunto de pares clave-valor que constituye la unidad básica de almacenamiento de datos. Es el equivalente a una fila o registro en una base de datos relacional, pero con una estructura mucho más flexible y dinámica.

Sus características clave son:

- **Formato BSON**: Los documentos se almacenan en el formato BSON (Binary JSON), una representación binaria de datos tipificados en JSON . 
  
- **Estructura sin esquema**: A diferencia de las tablas en bases de datos SQL, los documentos dentro de una misma colección no necesitan tener la misma estructura o los mismos campos. 


- **Identificador único ( _id )**: Cada documento debe tener una clave primaria, llamada `_id`, que es única dentro de la colección. Si no especificas un valor para `_id` al crear un documento, MongoDB genera un automáticamente mediante un `ObjectId`.


> **Ejemplo de dos documentos de una misma colección**
>
> Considera una colección llamada usuarios. Aquí tienes dos documentos que podrían existir:
> 
```json
{
    "_id": ObjectId("65324546851f5e6a9f8b4567"),
    "nombre": "Anna",
    "email": "anna@example.com",
    "fecha_registro": ISODate("2024-01-20T10:00:00Z"),
    "preferencias": {
    "lenguaje": "catalán",
    "tema": "oscuro"
    }
}
```
> Y otro con una estructura ligeramente distinta:
>
```json
{
    "_id": ObjectId("65324546851f5e6a9f8b4568"),
    "nombre": "Pere",
    "email": "pere@example.com",
    "roles": [ "editor", "gestor_contenido" ]
}
```
>Como puede ver, en el segundo documento no figuran ni el campo `data_registre` ni el campo `preferencias`, pero incluye el campo 'roles', que tiene valores de tipo array. Ésta es la característica principal de la estructura flexible de los documentos en MongoDB.


En MongoDB, el campo clave principal de cada documento, conocido como `_id`, puede aceptar casi cualquier tipo de dato BSON. Sin embargo, existen algunas excepciones y prácticas recomendadas para una gestión eficiente de los datos.

La clave _id puede ser de cualquiera de estos tipos de datos:

- **ObjectId**: Éste es el tipo por defecto. MongoDB lo genera automáticamente si no se especifica un `_id` al crear un documento. Es una cadena de 12 bytes única, rápida de generar y excelente para un entorno distribuido.
- **String**: Muy común. Se utiliza a menudo para claves generadas por el usuario, como nombres de usuario, correos electrónicos, u otros identificadores alfanuméricos.
- **Integer o Long**: Son útiles para claves numéricas, como identificadores de series o números de inventario.
- **Date**: Se pueden utilizar fechas como clave si la unicidad se garantiza por fecha y hora.
- **Binary data**: Para datos binarios como un UUID .

Hay algunas limitaciones importantes a tener en cuenta:

- **No puede ser un array o una expresión regular**: Un array o una expresión regular no pueden utilizarse como valor para el campo `_id`.
- **Debe ser único e inmutable**: El valor de `_id` debe ser único para cada documento de la colección e inmutable (no se puede modificar una vez asignado).

Para el resto de campos de un documento de MongoDB, no existe ninguna restricción sobre los tipos de datos que se pueden utilizar. Un campo puede ser de cualquiera de los tipos de datos BSON compatibles con MongoDB.

Los tipos de datos BSON (Binary JSON) que se pueden utilizar son:

- **String**: Texto. Es el tipo más común.
- **Number**: Incluye Integer ( entero), Long ( entero largo), Double ( decimal ).
- **Boolean**: true o false .
- **Array**: Una lista de valores, que pueden ser de cualquier tipo de datos BSON .
- **Object**: Un documento incrustado ( nested document ) que contiene pares clave-valor.
- **Date**: Almacena la fecha y hora.
- **ObjectId**: El identificador único de MongoDB, como el que se utiliza para la clave _id .
- **Null**: Indica un valor nulo.
- **Binary Data**: Para datos binarios.
- **Regular Expression**: Para expresiones regulares.
- **Timestamp**: Marca de tiempo.

---

## 1.3 Inserción de documentos

En MongoDB, existen dos métodos que permiten la inserción de documentos en una colección, `insertOne()` , e `insertMany()`.

### El método **insertOne()**:

Permite la inserción de un solo documento en una colección. Esta función es fundamental para añadir datos a su base de datos. Su sintaxis es la siguiente:

```javascript
db.<collection>.insertOne(<documento>);
```

La ejecución de la instrucción anterior, inserta el documento proporcionado como argumento en la colección de la base de datos a la que estamos conectados.

**Ejemplo práctico de uso del método insertOne():**

Por ejemplo, si está conectado a la base de datos `restaurants`, y ejecutas la siguiente instrucción, se insertará un nuevo documento en la colección `establishments` con los siguientes datos:

    - borough: 'Brooklyn'
    - cuisine: 'Catalan'
    - name: 'Rocabruna'
    - restaurante_id: '50018997'

```javascript
db.establishments.insertOne ({ 
  borough: 'Brooklyn', 
  cuisine: 'Catalan', 
  name: 'Rucabruna',
  restaurant_id: '50018997'
})
```

**Muestra del documento insertado:**
Si desea comprobar que el establecimiento se ha insertado correctamente, puede ejecutar el siguiente pedido de búsqueda, `db.establishments.findOne()` , que nos permite localizar un único documento detallando el valor de algún campo que tome valores únicos.

```javascript
db.establishments.findOne ({ 
  name: 'Rucabruna'
})
```

### El método **insertMany()**
También es posible que queramos realizar la inserción de varios documentos en una sola instrucción. El método para hacerlo es `insertMany()`, y su sintaxis es la siguiente:

```javascript
db.<collection>.insertMany([ <documento 1>, <documento 2>, … <documento n> ]);
```

Este método recibe como argumento un array (indicado por los corchetes []) que contiene los documentos a insertar. Cada documento dentro del array debe separarse con una coma. Esta aproximación es ideal para cargar grandes cantidades de datos eficientemente con una operación.

**Ejemplo de inserción múltiple:**

```javascript
db.establishments.insertMany ([{ 
  borough: 'Brooklyn', 
  cuisine: 'Catalan', 
  name: 'Rucabruna 2',
  restaurant_id: '70018998'
},{ 
  borough: 'Brooklyn', 
  cuisine: 'Catalan', 
  name: 'Rucabruna 3',
  restaurant_id: '70018999'
}])
```

## 1.4 Actualización de documentos

MongoDB proporciona dos métodos principales para actualizar documentos en una colección:

- **updateOne()**: Permite actualizar un solo documento que coincida con un criterio de búsqueda.
- **updateMany()**: Permite actualizar todos los documentos que coincidan con un criterio de búsqueda.
  
Estas operaciones utilizan frecuentemente operadores de actualización, como `$set` para modificar valores de campo, o `$push` para añadir elementos a un array. Además, la opción `upsert` permite insertar un documento, si no se encuentra ninguno que coincida con el filtro. 

### El método **updateOne()**
El método `updateOne()` se utiliza para actualizar un único documento de una colección que coincida con un filtro.

Su sintaxis es la siguiente:

```javascript
db.<collection>.updateOne( <filtro>, <actualización>, { <opciones> } );
```

Este método acepta tres argumentos :

<filtro>: Un documento de consulta que especifica el criterio para seleccionar el documento a actualizar. Si más de un documento coincide, sólo se actualizará el primero que se encuentre.
<actualización>: Un documento de actualización que contiene los operadores (como $set, $push, etc.) que definen los cambios a realizar en el documento.
<opciones>: Un documento opcional que puede incluir parámetros como upsert , que si se establece en true, insertará un nuevo documento si no se encuentra ninguno que coincida con el filtro.

Si el filtro de `updateOne()` selecciona varios documentos, el método sólo actualizará el primer documento que encuentre que coincida con el criterio de búsqueda, dado que este método está diseñado específicamente para modificar un único documento. Si desea actualizar todos los documentos que coinciden con un filtro, deberá utilizar el método `updateMany()`.

Para realizar las actualizaciones es necesario usar operadores como `$set` y `$push` en los dos métodos que realizan actualizaciones, tanto en lo que nos ocupa ahora, como en el método `updateMany()`.

**Operador $set**. El operador $set de MongoDB actualiza el valor de un campo. Realiza una de dos acciones:

  - Modifica el valor de un campo existente en el documento.
  - Añade un nuevo campo con su valor correspondiente si el campo no existe.

En esencia, el operador `$set` garantiza que un campo tendrá el valor especificado después de la operación, independientemente de si el campo ya estaba o no.

**Operador $push**. El operador $push añade un elemento a un array. Actúa de la siguiente manera:

  - Añade el elemento al final de un campo de tipo array existente.
  - Si el campo especificado no existe, lo crea como un nuevo array y añade el elemento como único valor.

Es importante notar que `$push` sólo funciona con campos de tipo array y es la forma estándar de añadir elementos a una lista dentro de un documento en MongoDB.

Es importante notar que `$push` sólo funciona con campos de tipo array y es la forma estándar de añadir elementos a una lista dentro de un documento en MongoDB.

**Ejemplo práctico de uso del método Operador $push (I):**

Si seguimos trabajando con la base de datos `restaurants` creada anteriormente, vemos que los documentos de la colección `establishments` tienen un campo `address`. El campo `address` es un objeto que contiene varios campos, incluido el campo `coord`, que es un array que almacena las coordenadas de latitud y longitud del restaurante.

Supongamos que queremos actualizar el siguiente documento: `restaurant_id: 50018997`.

De momento lo que haremos es que aparezca el campo `address`. Para ello usaremos el método `updateOne()` de la siguiente forma:

```javascript
db.establishments.updateOne(
    { name: 'Rucabruna' },
    { $set: { address: { coord: [] } } }
)
```

Estamos identificando el documento a actualizar a partir del valor de la propiedad `name`, y que hemos usado el operador `$set` para añadir el campo `address`, que como ve es un objeto incrustado (o embedded document) con un subcampo `coord` que es un array, cuyos valores todavía no.

Si usa ahora el método `find()`, para ver qué cambios se han producido en el documento, vemos tal que en el documento aparece ahora un campo `address`, que contiene un subdocumento con un campo de tipo array que de momento está vacío:

```javascript
db.establishments.find({ name: 'Rucabruna' })
```

**Ejemplo práctico de uso del método updateOne() (II):**

Queremos ahora a añadir en el mismo documento los campos de `address`, `Building` , `street` y `zipcode` que también cuelgan del campo `address`. Volveremos a ejecutar el método `updateOne()` de una forma parecida a la del ejemplo al anterior: 

```javascript
db.establishments.updateOne(
    { 
      name: 'Rucabruna' 
    },
    { 
      $set: { 
        "address.building": "",
        "address.street": "",
        "address.zipcode": "",
      } 
    })
```

Observa que usamos la sintaxis del punto para referirnos a estos subcampos, ya que forman parte de un subdocumento que se encuentra como valor de un campo llamado `address`.

**Ejemplo práctico dando valores:**

Finalmente mediante un tercer ejemplo veremos cómo dar valores a los campos del subdocumento que cuelga del campo `address`. Lo haremos de la siguiente forma, si queremos dar al campo `buiding` el valor `469`, usaremos el método `updateOne()`:

```javascript
db.establishments.updateOne(
    { 
      name: 'Rucabruna' 
    },
    { 
      $set: { 
        "address.building": "469"
      } 
    })
```