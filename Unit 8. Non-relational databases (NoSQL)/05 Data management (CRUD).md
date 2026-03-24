# 1. Data management in MongoDB

The fundamental operations in any database are create, read, update, and delete, commonly known by the acronym CRUD, which comes from the initials of the English words: Create, Read, Update, and Delete.

MongoDB’s flexible data model makes it easy to perform these tasks:

- *Create*: Allows you to add new data.
- *Read*: Allows you to retrieve and view data based on specific search criteria.
- *Update*: Allows you to modify existing data, either to correct errors or keep it up to date.
- *Delete*: Allows you to remove data from the database.


## 1.2 Documents: Add, modify, and delete

A document in MongoDB can be defined as a set of key-value pairs that constitutes the basic unit of data storage. It is the equivalent of a row or record in a relational database, but with a much more flexible and dynamic structure.

Its key characteristics are:

- **BSON Format**: Documents are stored in BSON (Binary JSON) format, a binary representation of JSON-like typed data. 
  
- **Schema-less structure**: Unlike tables in SQL databases, documents within the same collection do not need to have the same structure or the same fields. 

- **Unique identifier (_id)**: Each document must have a primary key called `_id`, which is unique within the collection. If you do not specify a value for `_id` when creating a document, MongoDB automatically generates one using an `ObjectId`.


> **Example of two documents in the same collection:**
>
> Consider a collection called `users`. Here are two documents that could exist in it:
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
> And another one with a slightly different structure:
>
```json
{
    "_id": ObjectId("65324546851f5e6a9f8b4568"),
    "nombre": "Pere",
    "email": "pere@example.com",
    "roles": [ "editor", "gestor_contenido" ]
}
```
>As you can see, the second document does not include either the registration_date field or the `preferences` field, but it does include the roles field, which contains values of the array type. This is the main characteristic of the flexible structure of documents in MongoDB.

In MongoDB, the primary key field of each document, known as `_id`, can accept almost any BSON data type. However, there are some exceptions and best practices for efficient data management.

The _id field can be of any of the following data types:

- **ObjectId**: This is the default type. MongoDB automatically generates it if no _id is specified when creating a document. It is a 12-byte unique value, fast to generate and ideal for distributed environments.
- **String**: Very common. Often used for user-generated keys such as usernames, email addresses, or other alphanumeric identifiers.
- **Integer or Long**: Useful for numeric keys, such as sequence identifiers or inventory numbers.
- **Date**: Dates can be used as keys if uniqueness is guaranteed by date and time.
- **Binary data**: For binary data such as a UUID.

There are some important limitations to keep in mind:

- **It cannot be an array or a regular expression**: An array or a regular expression cannot be used as the value of the `_id` field.
- **It must be unique and immutable**: The value of `_id` must be unique for each document in the collection and immutable (it cannot be modified once assigned).

For the rest of the fields in a MongoDB document, there are no restrictions on the data types that can be used. A field can be of any BSON data type supported by MongoDB.

The BSON (Binary JSON) data types that can be used are:

- **String**: Text. This is the most common type.
- **Number**: Includes Integer, Long (long integer), and Double (decimal).
- **Boolean**: true or false.
- **Array**: A list of values, which can be of any BSON data type.
- **Object**: An embedded (nested) document containing key-value pairs.
- **Date**: Stores date and time.
- **ObjectId**: MongoDB’s unique identifier, such as the one used for the _id field.
- **Null**: Indicates a null value.
- **Binary Data**: For binary data.
- **Regular Expression**: For regular expressions.
- **Timestamp**: A timestamp.

---

## 1.3 Document insertion

In MongoDB, there are two methods that allow documents to be inserted into a collection: `insertOne()` and `insertMany()`.

### The **insertOne()** method:

It allows the insertion of a single document into a collection. This function is essential for adding data to your database. Its syntax is as follows:

```javascript
db.<collection>.insertOne(<documento>);
```

Executing the above statement inserts the document provided as an argument into the collection of the database to which we are connected.

**Practical example of using the insertOne() method:**

For example, if you are connected to the restaurants database and execute the following statement, a new document will be inserted into the establishments collection with the following data:

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

**Sample of the inserted document:**
If you want to verify that the establishment has been inserted correctly, you can run the following query: `db.establishments.findOne()`, which allows you to locate a single document by specifying the value of a field that contains unique values.

```javascript
db.establishments.findOne ({ 
  name: 'Rucabruna'
})
```

### The **insertMany()** method
You may also want to insert multiple documents in a single statement. The method used to do this is `insertMany()`, and its syntax is as follows:

```javascript
db.<collection>.insertMany([ <documento 1>, <documento 2>, … <documento n> ]);
```

This method takes an array as its argument (indicated by square brackets []) containing the documents to be inserted. Each document within the array must be separated by a comma. This approach is ideal for efficiently loading large amounts of data in a single operation.

**Example of multiple insertion:**

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

## 1.4 Document update

MongoDB provides two main methods for updating documents in a collection:

- **updateOne()**: Allows you to update a single document that matches a search criterion.
- **updateMany()**: Allows you to update all documents that match a search criterion.
  
These operations often use update operators, such as `$set` to modify field values or `$push` to add elements to an array. In addition, the upsert option allows a document to be inserted if no document matching the filter is found. 

### The **updateOne()** method
The `updateOne()` method is used to update a single document in a collection that matches a filter.

Its syntax is as follows:

```javascript
db.<collection>.updateOne( <filtro>, <actualización>, { <opciones> } );
```

This method accepts three arguments:

`<filter>`: A query document that specifies the criteria for selecting the document to update. If more than one document matches, only the first one found will be updated.

`<update>`: An update document containing the operators (such as $set, $push, etc.) that define the changes to be made to the document.

`<options>`: An optional document that may include parameters such as upsert, which, when set to true, inserts a new document if none matches the filter.

If the `updateOne()` filter matches multiple documents, the method will update only the first document it finds that meets the search criteria, since this method is specifically designed to modify a single document. If you want to update all documents that match a filter, you should use the `updateMany()` method.

To perform updates, it is necessary to use operators such as `$set` and `$push` in both methods that handle updates, both in the one we are discussing now and in the `updateMany()` method.

**$set operator**. MongoDB’s $set operator updates the value of a field. It performs one of two actions:

- Modifies the value of an existing field in the document.
- Adds a new field with its corresponding value if the field does not exist.

In essence, the `$set` operator ensures that a field will have the specified value after the operation, regardless of whether the field already existed or not.

**$push operator**. The $push operator adds an element to an array. It works as follows:

- Adds the element to the end of an existing array field.
- If the specified field does not exist, it creates it as a new array and adds the element as its only value.

It is important to note that `$push` only works with fields of type array and is the standard way to add elements to a list within a MongoDB document.

**Practical example of using the $push operator (I):**

If we continue working with the `restaurants` database created earlier, we can see that the documents in the `establishments` collection have an address field. The address field is an object containing several fields, including the coord field, which is an array that stores the restaurant’s latitude and longitude coordinates.

Suppose we want to update the following document: `restaurant_id: 50018997`.

For now, what we will do is make the address field appear. To do this, we will use the `updateOne()` method as follows:

```javascript
db.establishments.find({ name: 'Rucabruna' }) 

db.establishments.updateOne(
    { name: 'Rucabruna' },
    { $set: { address: { coord: [] } } }
)
```

We are identifying the document to be updated based on the value of the name property, and we have used the `$set` operator to add the address field, which, as you can see, is an embedded document with a coord subfield that is an array, although its values have not yet been defined.

If you now use the `find()` method to see what changes have been made to the document, you will see that the document now includes an address field, which contains a subdocument with an array-type field that is currently empty:

```javascript
db.establishments.find({ name: 'Rucabruna' })
```

**Practical example of using the updateOne() method (II):**

We now want to add the building, street, and zipcode fields to the same document under the address field. We will run the `updateOne()` method again in a similar way to the previous example:

```javascript
db.establishments.find({ name: 'Rucabruna' }) 

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

Note that we use dot notation to refer to these subfields, since they are part of a subdocument stored as the value of a field called `address`.

**Practical example with assigned values:**

Finally, through a third example, we will see how to assign values to the fields of the subdocument under the `address` field. We will do it as follows: if we want to assign the value `469` to the building field, we will use the `updateOne()` method:

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

**Use of the $push operator:**

The `$push` operator, as we have explained, is used to add a new element to a field of type array. In a previous example, we inserted an establishment named `Rocabruna`, with an `address.coord` field of type array without any values. In the following example, we will see how to assign values to it.

We are going to insert values into an array-type field, doing so one by one:

```javascript
db.establishments.find({ name: 'Rucabruna' }) 

db.establishments.updateOne(
    { 
      name: 'Rucabruna' 
    },
    { 
      $push: { 
        "address.coord": -73.98967650000002
      } 
    })

db.establishments.find({ name: 'Rucabruna' }) 

db.establishments.updateOne(
    { 
      name: 'Rucabruna' 
    },
    { 
      $push: { 
        "address.coord": 40.6690748
      } 
    })
```

**Updating more than one value in an array-type field:**

If we want to update more than one value in an array-type field, the syntax would be as follows:

```javascript
db.establishments.find({ name: 'Rucabruna 2' }) 

db.establishments.updateOne(
    { 
      name: 'Rucabruna 2' 
    },
    { 
      $push: { 
        "address.coord": {
          $each: [
          -73.98967650000002, 
          40.6690748
          ]
        }  
      } 
    })

db.establishments.find({ name: 'Rucabruna 2' }) 
```

**Upsert option.**
If the filter in the `updateOne()` method does not match any document, we may want the document to be created. This is where the upsert option comes into play. The upsert option inserts a document with the provided information if no document exists that matches the criteria specified in the filter argument.

Let’s see it with an example: if we execute the following code for an establishment with the key name and value `Rocabruna 4`, which we know does not exist:

```javascript
db.establishments.updateOne(
    { 
      name: 'Rucabruna 4' 
    },
    { 
      $set: { 
        "address.coord": [ -73.98967650000002, 
          40.6690748
          ],
         "address.street" : "4 Avenue" ,
         "address.zipcode" : "11215"
        }  
      })

db.establishments.find({ name: 'Rucabruna 4' }) 
```

Since no document matches the filter, no document can be updated. However, if we use the `upsert` option:

```javascript
db.establishments.updateOne(
    { 
      name: 'Rucabruna 4' 
    },
    { 
      $set: { 
        "address.coord": [ -73.98967650000002, 
          40.6690748
          ],
         "address.street" : "4 Avenue" ,
         "address.zipcode" : "11215"
        }  
      }, {
        upsert: true
      })

db.establishments.find({ name: 'Rucabruna 4' }) 
```

### The updateMany() method

The `updateMany()` method is used to update multiple documents in a collection. It accepts a filter document, an update document, and an options object as parameters. This last argument is optional.

Its syntax is as follows:

```javascript
db.<collection>.updateMany(
  <filtre>
  <actualizacion>,
  { <opciones>}
)
```

Next, we detail its arguments:

`<filter>`: This argument is a query document that defines the criteria for selecting the documents to be updated. If omitted (by passing an empty document {}), all documents in the collection will be updated. For example, { "estado": "pendiente" } would update only the documents where the estado field has the value "pendiente".

`<update>`: This document specifies the changes to be applied to the selected documents. Update operators such as $set, $inc, $unset, etc., are generally used to modify existing fields, add new ones, or remove them. It is crucial to use these operators to avoid replacing the entire document, because without them, updateMany() would simply overwrite the existing document with the update document.

`<options>`: This optional argument is a document containing additional options for the operation, such as upsert: true, which creates a new document if none match the filter.

**Practical example of using the updateMany() method:**

Imagine we need to change the neighborhood for all establishments with a specific zipcode. The query could be as follows:

```javascript
db.establishments.updateMany(
    { 
      "address.zipcode" : "11215"
    },
    { 
      $set: { 
        "borough":  "Brooklyn"
        }  
      })
```

In this case:

- The filter is { "address.zipcode": "12355" }.
- The update is { $set: { "borough": "Brooklyn" } }, which uses the $set operator to change the value of the borough field to "Brooklyn".

Therefore, the update will be applied to all documents where the zipcode field has the value 12355.

![Important]
It is important to note that updateMany() is not an atomic or transactional operation at the collection level. If the update process for 100 documents is interrupted after updating 50, the changes to those 50 documents will remain, while the remaining 50 will not have been updated. To complete the operation, the method would need to be executed again.

---
## **MongoDB Update Operators**

| Operator         | Description                                                                      | Example                                                                                            |
| ---------------- | -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **$currentDate** | Sets a field to the current date or timestamp.                                   | `db.restaurants.updateOne({name:"Morris Park Bake Shop"}, {$currentDate: {lastModified: true}})`   |
| **$inc**         | Increments a numeric field by a specified value.                                 | `db.restaurants.updateOne({name:"Wendy'S"}, {$inc: {reviewsCount: 1}})`                            |
| **$min**         | Updates the field only if the specified value is less than the current value.    | `db.restaurants.updateOne({name:"Dj Reynolds Pub And Restaurant"}, {$min: {"grades.0.score": 1}})` |
| **$max**         | Updates the field only if the specified value is greater than the current value. | `db.restaurants.updateOne({name:"Riviera Caterer"}, {$max: {"grades.0.score": 15}})`               |
| **$mul**         | Multiplies a numeric field by a specified value.                                 | `db.restaurants.updateOne({name:"Tov Kosher Kitchen"}, {$mul: {"grades.1.score": 2}})`             |
| **$rename**      | Renames a field.                                                                 | `db.restaurants.updateOne({name:"Brunos On The Boulevard"}, {$rename: {"cuisine":"foodType"}})`    |
| **$set**         | Sets the value of a field (creates it if it does not exist).                     | `db.restaurants.updateOne({name:"Morris Park Bake Shop"}, {$set: {borough:"Queens"}})`             |
| **$setOnInsert** | Sets a value only if a new document is inserted (upsert).                        | `db.restaurants.updateOne({name:"New Bakery"}, {$setOnInsert:{cuisine:"Bakery"}}, {upsert:true})`  |
| **$unset**       | Removes a field from the document.                                               | `db.restaurants.updateOne({name:"Wendy'S"}, {$unset: {address: ""}})`                              |


---

**MongoDB Update Operators – Array**

| Operator      | Description                                                                 | Example                                                                                                                                                              |
| ------------- | --------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **$**         | Updates the first array element that matches the query.                     | `db.restaurants.updateOne({"grades.grade":"B"}, {$set: {"grades.$.score": 10}})`                                                                                     |
| **$[]**       | Updates all elements in an array for a document that matches the query.     | `db.restaurants.updateOne({name:"Morris Park Bake Shop"}, {$set: {"grades.$[]": {score: 5}}})`                                                                       |
| **$[<id>]**   | Updates array elements that match a condition specified in `arrayFilters`.  | `db.restaurants.updateOne({name:"Tov Kosher Kitchen"}, {$set: {"grades.$[elem].score": 8}}, {arrayFilters:[{"elem.grade":"A"}]})`                                    |
| **$addToSet** | Adds elements to an array only if they don’t already exist (no duplicates). | `db.restaurants.updateOne({name:"Dj Reynolds Pub And Restaurant"}, {$addToSet: {tags: "popular"}})`                                                                  |
| **$pop**      | Removes the first (-1) or last (1) element from an array.                   | `db.restaurants.updateOne({name:"Riviera Caterer"}, {$pop: {grades: -1}})`                                                                                           |
| **$pull**     | Removes elements from an array that match a condition.                      | `db.restaurants.updateOne({name:"Tov Kosher Kitchen"}, {$pull: {grades: {grade:"Z"}}})`                                                                              |
| **$pullAll**  | Removes multiple specified elements from an array.                          | `db.restaurants.updateOne({name:"Brunos On The Boulevard"}, {$pullAll: {grades: [{score:38},{score:13}]}})`                                                          |
| **$push**     | Adds an element to an array.                                                | `db.restaurants.updateOne({name:"Morris Park Bake Shop"}, {$push: {grades: {date:new Date(), grade:"A", score:5}}})`                                                 |
| **$each**     | Adds multiple elements to an array (used with `$push` or `$addToSet`).      | `db.restaurants.updateOne({name:"Morris Park Bake Shop"}, {$push: {grades: {$each:[{date:new Date(), grade:"B", score:7},{date:new Date(), grade:"A", score:9}]}}})` |

--- 

**MongoDB Update Operators – Modifiers Avanzados**

| Operator / Modifier | Description                                                                      | Example                                                                                                                                                              |
| ------------------- | -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **$bit**            | Performs bitwise operations on a numeric field (AND, OR, XOR).                   | `db.restaurants.updateOne({name:"Morris Park Bake Shop"}, {$bit: {reviewsCount: {or: 2}}})`                                                                          |
| **Array Filters**   | `$[<id>]` updates only array elements that match a condition via `arrayFilters`. | `db.restaurants.updateOne({name:"Tov Kosher Kitchen"}, {$set: {"grades.$[elem].score": 8}}, {arrayFilters:[{"elem.grade":"A"}]})`                                    |

---

## 1.5 Deleting documents

There are two methods that allow deleting documents: `deleteOne()` and `deleteMany()`. As their names indicate, the first is used to delete a single document, while the second is used to delete multiple documents. It is important to understand how and when to use them correctly.

### Method deleteOne()

The `deleteOne()` method is used to delete a document from a collection. The method syntax accepts a filter document as a required argument and, optionally, an options object:

```javascript
db.<collection>.deleteOne(
  <filtre>,
  { <opcions>}
)
```

The filter document specifies the search criteria to find the document to be deleted.

The options object is an optional argument that may include parameters such as `writeConcern`, `collation`, or `hint`, which allow fine-tuning the behavior of the operation.

Some of the most common options to fine-tune the operation are:

- **writeConcern**: This option controls the level of acknowledgment MongoDB must wait for before returning the success of the operation. It is essential for data durability. For example, you can set a writeConcern to ensure the write has been replicated to a specific number of replica set members or written to the server’s journal.

- **collation**: Allows specifying string comparison rules for search and sort operations. It is useful for internationalization, as it enables defining string comparison behavior according to the rules of a language or region (for example, accented characters, case sensitivity, etc.).

- **hint**: This option is used to force the use of a specific index for an operation. If MongoDB’s query planner chooses a non-optimal index, you can manually “suggest” which index should be used to improve performance.

**Practical example of using the deleteOne() method**

Imagine we want to delete the establishment named `Rucabruna 4`. Executing the following query will perform the deletion:

```javascript
db.establishment.deleteOne(
  { "name" : `Rucabruna 4`}
)
```

### Method deleteMany()

The `deleteMany()` method is used to delete one or multiple documents that match the specified criteria. Its syntax is as follows:

```javascript
db.<collection>.deleteMany(
  <filtre>,
  { <opcions>}
)
```

Where:

- Filter document: This is a required argument that specifies the conditions that documents must meet to be deleted. If an empty filter document ({}) is passed, all documents in the collection will be deleted.

- Options object: This is an optional argument that may include additional parameters to fine-tune the operation’s behavior, such as writeConcern (for write durability) or collation (for character handling).

**Practical example of using the deleteMany() method**

If we want to delete all establishments with `zipcode` equal to 12355, we would execute the following:

```javascript
db.<collection>.deleteMany({
  "address.zipcode" : "12355"
})
```
This will delete all documents selected by the filter document.
