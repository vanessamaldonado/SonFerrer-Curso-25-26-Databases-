# Stored procedures (input parameters)
Stored procedures can receive and return information; this is done using input and output parameters, respectively.
Let's look at the first ones. Input parameters allow information to be passed to a procedure.

For a stored procedure to accept input parameters, variables must be declared as parameters when it is created. The syntax is:
```sql
create procedure PROCEDURENAME (in PARAMETERNAME DATATYPE)
 begin
 end
```
Input parameters are defined after the procedure name, preceded by the keyword `in`. Parameters are local to the procedure; that is, 
they exist only within it. Multiple parameters can be declared per procedure, separated by commas.
When the procedure is executed, values ​​must be specified for each of the parameters (in the order in which they were defined).
Input parameters can be of any data type.

For example, we create the stored procedure called `pa_libros_autor` which receives an input parameter of type varchar(30):

```sql
 delimiter //
 create procedure pa_libros_autor(in p_autor varchar(30))
 begin
   select title, publisher, price
     from libros
     where autor= p_autor;
 end //
 delimiter ;
```
Then, to call the stored procedure, we must pass a value for the parameter:
```sql
call pa_libros_autor('Richard Bach');
```
