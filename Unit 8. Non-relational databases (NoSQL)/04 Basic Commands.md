# ⚡ Creating a Simple Database

- To create a database, you also use the **`use`** command along with the name of the new database.
```bash
use mibase
```
- If you run the `show dbs` command, it will not appear in the list yet because you need to create a collection (table).

- The `db.createCollection()` command creates a collection in the current database. You must provide a name for the collection.
```javascript
db.createCollection('miColeccion')
```
- If you run the `show dbs` command again, it will now appear in the list.

- The `db.myCollection.drop()` command deletes a collection from the database.
```javascript
db.miColeccion.drop()
```
- The `db.dropDatabase()` command deletes the database you are currently using.
```javascript
db.dropDatabase()
```

## Example: 

**👉 First**: download the collections (JSON files) `movies.json` and `comments.json` to upload them to the database `Sample1` that you will need to create.

- **movies**: [download link](./BBDD/movies.json)

- **comments**: [download link](./BBDD/comments.json)

**👉 Second**: create a database in the console called `Sample1`.

**👉 Third**: import the movies and comments collections from their respective JSON files.

Done, you now have a database with 2 collections to start performing queries, filters, updates, etc.


## Learning Basic Commands

The `cls` command clears the console:

```bash
cls
```

The `show dbs` command displays all databases stored in MongoDB:

```bash
show dbs
```

The `db` command shows which database you are currently using. Initially, it will indicate that you are in test:

```bash
db
```

The `use` command is used to switch to the database you want to work with:

```bash
use Sample1
```

> If you run the db command again, it will show that you are now in the `Sample1` database.

The `show collections` command displays the COLLECTIONS (TABLES) of the Sample1 database. In this case, we have 2 collections: comments and movies:

```bash
show collections
```
