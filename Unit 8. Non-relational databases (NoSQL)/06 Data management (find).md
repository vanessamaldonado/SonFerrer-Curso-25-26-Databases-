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
