# 1. Document Search and Counting

For searching documents in MongoDB, the `find()` method is the main
tool. This powerful function allows complex queries to select documents
that meet specific criteria. If you only need the first document that
matches a filter, use `findOne()`, a more specific version of `find()`.

To know how many documents match a filter, use the `countDocuments()`
method.

In addition to basic searching, the `find()` method can incorporate a
wide variety of query operators (see the tables provided in point 05
Data management (CRUD)):

-   **Comparison operators**: Such as \$eq (equal to) or \$in (included
    in a list).
-   **Logical operators**: To combine multiple conditions.
-   **Array operators**: Such as \$elemMatch to search within arrays or
    embedded documents.

## 1.1 The find() method

The syntax of the find() method is as follows:

``` javascript
db.<collection>.find(<query>, <projection>)
```

Where:

`<query>` (optional): This is the first argument and is optional, used
to filter documents. If omitted, find() returns all documents in the
collection.

`<projection>`: This is the second argument and is optional, used to
select which fields (or columns) should be returned in the resulting
documents. By default, find() returns all fields. A JSON document is
used where each field is set to 1 to include it or 0 to exclude it.

**Practical example using the cursor returned by find()**

If you want to list all establishments in the `establishments`
collection, run:

``` javascript
db.establishment.find()
```

This method returns a cursor with the results of the find() execution
and paginates them, so you need to type `it` to iterate through the
result list.

**Practical example of filtered search**

If you want to list all documents in the `establishments` collection
where the `cuisine` field has the value `Catalan`, run:

``` javascript
db.establishment.find({"Cuisine": "Catalan"})
```

## 1.2 The findOne() method

To retrieve a single document that meets a condition, use the
`findOne()` method. Its syntax is:

``` javascript
db.<collection>.findOne(<query>, <projection>)
```

Where:

-   **Query**: Optional. This is the filter document specifying
    selection criteria. Only the first matching document will be
    returned. If omitted (using {}), it returns the first document in
    the collection without filtering.
-   **Projection**: Optional. Determines which fields are included or
    excluded. Helps reduce returned data, improving performance and
    readability. Fields set to 1 are included. The `_id` field is
    included by default unless explicitly excluded.

> **Projections in find()** 
> Used to specify which fields to include or exclude: 
> - 1 (or true): Include the field. 
> - 0 (or false): Exclude the field.

**Projection example**

Include specific fields:

``` javascript
db.users.find({}, { name: 1, email: 1, _id: 0 })
```

Exclude specific fields:

``` javascript
db.users.find({}, { password: 0, registrationDate: 0 })
```

**Practical example of findOne()**

Even if multiple documents match the filter, findOne() only returns the
first one found, so results may appear random unless sorted:

``` javascript
db.establishment.findOne({"Cuisine": "Catalan"})
```

### Predictable Search with findOne()

When using `findOne()` and multiple documents match, MongoDB does not
guarantee order. The returned document is simply the first match found.

To ensure consistent results (e.g., newest or alphabetical), enforce
ordering using `find()`, `sort()`, and `limit(1)`.

> **Sorting (sort())** 
> 
> - 1: Ascending order (A-Z, 0-9). 
> - -1: Descending order (Z-A, 9-0).

``` javascript
db.products.find().sort({ price: 1 })
```

``` javascript
db.establishments.find({"cuisine": "Catalan"}).sort({ name: 1 }).limit(1)
```

This query: - Finds documents where `cuisine` is `Catalan` - Sorts them
by name ascending - Returns the first result

## Document Counting: countDocuments()

The `countDocuments()` method counts documents matching a filter.
Syntax:

``` javascript
db.<collection>.countDocuments(query, options)
```

Where:

-   **query**: Required. Filter criteria (same as find()). Use {} to
    count all documents.
-   **options**: Optional. Modifies behavior.

**Example**

Count all documents:

``` javascript
db.establishments.countDocuments({})
```

Count filtered documents:

``` javascript
db.establishments.countDocuments({"cuisine": "Catalan"})
```

## Sorting and Limiting Queries

In this section, we will learn how to sort and limit the results of a MongoDB query using two cursor methods: `cursor.sort()` and `cursor.limit()`. To understand how they work, we first need to know what a cursor is in MongoDB.

A cursor is a pointer or reference to the set of documents returned by a query. For example, when you run `db.<collection>.find()`, MongoDB returns a cursor that points to all documents matching the search criteria.

Methods like `.sort()` and `.limit()` are chained directly to queries to modify the result set. In this case, they are used to sort documents and limit the number of results before processing them.

### Cursor.sort() Method

The `.sort()` method allows you to order the documents of a query based on the values of one or more fields, either in ascending or descending order. This functionality is essential for organizing data and presenting it in a more logical way, whether by numeric, alphabetical, or other data types.

Syntax:

```javascript
db.collection.find(<query>).sort(<sort>)
```

This can be broken down as follows:

- `db.collection.find(<query>)`: This is the base query. It returns a cursor with the set of documents that match the specified criteria in `<query>`. If `<query>` is an empty object ({}), the query will return all documents in the collection.

- `.sort(<sort>)`: This is the method chained to the find() query. The `<sort>` parameter is an object that specifies the fields to sort by, along with the sort direction.

**Practical example of using .sort()**

If you want to list all restaurants in the establishments collection that serve Portuguese cuisine, and you want the list sorted alphabetically by restaurant name:

```javascript
db.establishments.find({ cuisine: "Portuguese" }).sort({ name: 1 })
```

### Field Projection

Projection allows you to select which fields you want to include in the result set of a query. Instead of receiving the full document, you can explicitly tell MongoDB to return only the fields you are interested in.

This functionality is crucial for optimizing application performance. By limiting the amount of data transferred over the network, you reduce processing load and improve query speed.

Projection syntax is applied as the second parameter of the find() method and uses the object `{ <field>: <value> }`, where:

- 1 (or true) indicates the field should be included.
- 0 (or false) indicates the field should be excluded.

Remember that by default, the _id field is always included. If you do not want it to appear, you must explicitly specify { _id: 0 }.

**Practical example using .sort() and field projection**

Now let’s display the results of the previous query, but only showing specific fields—in this case, the name field:

```javascript
db.establishments.find({ cuisine: "Portuguese" }, { name: 1 }).sort({ name: 1 })
```

### Cursor.limit() Method

The `.limit()` method is used to restrict the number of documents returned by a MongoDB query. This technique is essential for optimizing performance, as it prevents the server from processing and transferring more data than necessary. 

Its syntax is very simple and is chained to the find() method:

```javascript
db.establishments.find(<query>).limit(<number>)
```

Where `<number>` is the maximum number of documents returned by the query.

**Practical example using .limit()**

If you want to display the northernmost Portuguese restaurant, you would do the following:

```javascript
db.establishments.find(
  { cuisine: "Portuguese" },
  { borough: 1, name: 1, "address.coord": 1, _id: 0 }
)
```

The imposed sorting orders the documents based on latitude, which is located at index 1 of the coord array within the address sub-document. The value -1 ensures descending order, so the document with the highest latitude (the northernmost) appears first.

To display only the northernmost result, you would limit the output as follows:

```javascript
db.establishments.find(
  { cuisine: "Portuguese" },
  { borough: 1, name: 1, "address.coord": 1, _id: 0 }
).limit(1)
```

## Advanced Queries in MongoDB with the $expr Operator

In MongoDB queries, we usually compare fixed values with document fields. However, there are situations where we need more complex filtering logic, such as comparing two fields, performing mathematical calculations directly in the query, or converting a field’s data type for proper comparison.

To solve these challenges, MongoDB provides the $expr operator. Think of it as a key that unlocks the power of the aggregation framework within simple queries. Below are some of its most common uses.

Using the $expr operator, you can:

- Compare two fields within the same document: for example, find all documents where the total field is greater than the subtotal field.
```javascript
{ $expr: { $gt: [ "$total", "$subtotal" ] } }
```

- Perform mathematical calculations in a query: for example, find documents where the price is 20% higher than another price.
```javascript
{ $expr: { $gt: [ "$final_price", { $multiply: [ "$base_price", 1.2 ] } ] } }
```

- Convert the data type of a field for comparison: this is the case covered in the previous example, where we convert a string to an integer in order to perform a numeric comparison.
```javascript
{ $expr: { $gt: [ { $toInt: "$string_field" }, 100 ] } }
```

**Example: Using $expr for Type Conversion**

Sometimes you may want to use comparison operators on numeric values that are stored as strings, but you need the comparison to be numeric rather than alphabetical. In the database we are working with, the value of the "building" field is stored as a string.

```javascript
{
  "_id": {
    "$_id": "69c2aaca3f2512eb343476fd"
  },
  "address": {
    "building": "1007",
    "coord": [
      -73.856077,
      40.848447
    ],
    "street": "Morris Park Ave",
    "zipcode": "10462"
  },
  "borough": "Bronx",
  "cuisine": "Bakery",
  "name": "Morris Park Bake Shop",
  "restaurant_id": "30075445"
}
```

If we want to count how many restaurants are on “Morris Park Ave” with a building number greater than 1000, we need to convert the value to an integer. To do this, we use the $expr operator along with $toInt.

The main function of $expr in MongoDB is to allow aggregation expressions within the query stage (find or countDocuments). Without $expr, queries can only compare fields with literal values. Thanks to this operator, we can convert the "building" field’s data type.

```javascript
db.establishments.countDocuments({
  "address.street": "Morris Park Ave",
  $expr: {
    $gt: [
      { $toInt: "$address.building" },
      1000
    ]
  }
})
```

## Pattern Operators

To search for documents matching a specific pattern, you need to include a query object with the field to search and, as its value, a regular expression. The basic syntax is:

```javascript
db.collection.find({ <field>: { $regex: /pattern/ } })
```

Where:

- `<field>`: The name of the field to search.

- `$regex`: The operator indicating that the value is a regular expression.

- `/pattern/`: The regular expression defining the search pattern.

You can also use the `$options` parameter to modify search behavior, for example, to make it case-insensitive (i).

**Regex Options:**
Modifiers can be added to adjust the search:

- i: Case-insensitive (e.g., /pattern/i).
- m: Multiline.
- x: Ignore whitespace.
- s: Allows the dot . to match newline characters.

**Common Examples:**

- Partial match:
```javascript
db.usuarios.find({ nombre: { $regex: "maria" } })
```
Searches for documents where "nombre" contains "maria".

- Case insensitive:
```javascript
db.usuarios.find({ nombre: { $regex: /maria/i } }) 
```
Searches for "Maria", "MARIA", "maria", etc.

- Start of string:
```javascript
db.usuarios.find({ nombre: { $regex: /^Mar/ } }) 
```
Searches for names that start with "Mar".

**Using Anchors (^ and $):**
For more precise searches, you can use anchors to specify the beginning or end of a string:

- ^: Start of the string.
- $: End of the string.

**The OR Operator (|):**
The vertical bar operator (|) allows matching any of multiple patterns. It works as a logical “OR” within the regular expression, enabling searches that satisfy one or more alternatives.

**Using Special Characters:**
If the pattern contains characters with special meaning in regular expressions (such as ., *, +, ?, etc.), you must escape them with a backslash (\) to treat them as literal characters.

> [!NOTE]
>To search for emails containing “domini.cat”, you must escape the dot (.):
```javascript
db.users.find({ "email": { $regex: /domini\.cat/i } })
```
Or:
```javascript
street: "St Convent Ave"
```

Where an abbreviation is used. The query could be:
```javascript
db.establishments.countDocuments({
  "address.street": { $regex: "(Ave|Avenue)$", $options: "i" }
})
```

Pattern explanation:

- "address.street": The field where the search is performed.

- $regex: Indicates the use of a regular expression.

- (Ave|Avenue)$:
    - (...): Groups the options.
    - |: Logical “OR” (matches “Ave” or “Avenue”).
    - $: Ensures the pattern appears at the end of the string.
    - $options: "i": Makes the search case-insensitive.
