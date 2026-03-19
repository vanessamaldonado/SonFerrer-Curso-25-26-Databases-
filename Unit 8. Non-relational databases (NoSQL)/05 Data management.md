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

<filter>: A query document that specifies the criteria for selecting the document to update. If more than one document matches, only the first one found will be updated.
<update>: An update document containing the operators (such as $set, $push, etc.) that define the changes to be made to the document.
<options>: An optional document that may include parameters such as upsert, which, when set to true, inserts a new document if none matches the filter.

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

It is important to note that `$push` only works with fields of type array and is the standard way to add elements to a list within a MongoDB document.

**Practical example of using the $push operator (I):**

If we continue working with the `restaurants` database created earlier, we can see that the documents in the `establishments` collection have an address field. The address field is an object containing several fields, including the coord field, which is an array that stores the restaurant’s latitude and longitude coordinates.

Suppose we want to update the following document: `restaurant_id: 50018997`.

For now, what we will do is make the address field appear. To do this, we will use the `updateOne()` method as follows:

```javascript
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