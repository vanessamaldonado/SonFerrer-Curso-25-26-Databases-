# Stored Procedures
A stored procedure is a set of instructions (SQL commands) given a name, which is stored on the server. They allow you to encapsulate repetitive tasks.
A stored procedure can reference objects (tables, views, etc.) that do not exist at the time of its creation. The objects must exist when the stored procedure is executed.

## Advantages
- They share the application logic with the other applications, so access to and modification of data are done in one place.
- They allow users to perform all the operations they need without giving them direct access to the tables.
- They reduce network traffic; instead of sending many instructions, users perform operations by sending a single instruction, which decreases the number of requests between 
the client and the server.

## Disadvantages
- The instructions we can use within a stored procedure are not designed to implement very complex business logic.
- They are difficult to debug.
- Knowing the advantages and disadvantages of stored procedures, we must identify the cases where they can facilitate the implementation of our applications.

---

# Stored procedures (create - execute)
Stored procedures are created in the selected database.
First, the instructions included in the stored procedure must be typed and tested; then, if the expected result is obtained, the procedure is created.
- Stored procedures can reference tables, views, and other stored procedures.
- A stored procedure can include any number and type of instructions.
- To create a stored procedure we use the `create procedure` instruction.

The basic partial syntax is:

```sql
create procedure PROCEDURENAME()
begin
 INSTRUCTIONS;
end
```

With the following instructions we create a stored procedure called `pa_libros_limite_stock` that returns all the books of which there are fewer than 10 available:

```sql
create procedure pa_libros_limite_stock()
 begin
   select * from libros
   where stock<=10;
 end
```
To then call the stored procedure, we must use the `call` clause followed by the name of the stored procedure:

```sql
call pa_libros_limite_stock();
```

## 'Delimiter' clause
Since a stored procedure can contain many SQL commands between the `begin` and `end` keywords, we must somehow instruct MySQL not to execute those commands. 
To do this, we use the `delimiter` command, replacing the semicolon (`;`) with the semicolon as the end of the statement. Then, we must code the stored procedure, 
changing the delimiter with the following syntax:

```sql
 delimiter //
 create procedure pa_libros_limite_stock()
 begin
   select * from libros
   where stock<=10;
 end //
 delimiter ;
 
 call pa_libros_limite_stock();
```

We use the delimiter `//` as it could be any other, for example '$':

```sql
delimiter $
 create procedure pa_libros_limite_stock()
 begin
   select * from libros
   where stock<=10;
 end $
 delimiter ;
 
 call pa_libros_limite_stock();
 ```
