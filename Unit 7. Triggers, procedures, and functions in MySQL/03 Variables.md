# Variable Types in MySQL

In MySQL, you can use variables just like in programming languages, and this can be quite useful. You can store the value of a SELECT query in a variable. The syntax for assigning a variable within a SELECT statement is: `@var_name := value`.
One example of how useful this can be is when you need to delete rows of data in multiple tables where the rows are linked by a...foreign key. Let's look at an example:

```sql
SELECT @id := dept_id FROM departamentos WHERE departamento = 'Personal';
```

In the previous example, the department ID was stored in the variable @id . Now we have a variable with a value. Let's see an example of how to use that variable :

```sql
SELECT * FROM empleados WHERE dept_id = @id;
```

In MySQL we can use the following types of variables:

**Local variables** are declared using the reserved word `local` DECLAREwithin a procedure, function, or trigger. Their scope is local to the procedure, function, or trigger where they are declared.

Example:
```sql
DECLARE total INT UNSIGNED;
```

**User-defined variables within the session scope.** They are declared preceded by the `<span>` character @and are valid only within the session where they are declared. When the session ends, their value is lost.

Example:
```sql
SET @total = 0;
```

**System variables.** These variables are used to configure MySQL. They can be global or session variables. The difference between them is that a session variable loses its value when you close the session with the server, while a global variable retains its value until the service is restarted or it is changed to another value.

Example:
```sql
SET @@GLOBAL.lc_time_names = 'es_ES';
SET GLOBAL lc_time_names = 'es_ES';

SET @@SESSION.lc_time_names = 'es_ES';
SET SESSION lc_time_names = 'es_ES';
```

## Declaration of local variables with DECLARE
In both procedures and functions, it is possible to declare local variables using the reserved word `DECLARE`.

The syntax for declaring local variables with `DECLARE` is as follows.
```sql
DECLARE var_name [, var_name] ... type [DEFAULT value]
```

The scope of a local variable will be the block BEGIN and END of the procedure or function where it has been declared.

Example:

In this example we are declaring a local variable with the name total which is of type INT UNSIGNED.
```sql
DECLARE total INT UNSIGNED;
```

## Stored procedures (definition of local variables)

Depending on the complexity of a stored procedure, MySQL gives us the possibility of defining variables to store temporary values ​​and perform operations with them.

We use the keyword 'declare' followed by the variable name, the data type it stores, and the default value it stores:

```sql
declare [nombre de la variable] [tipo de dato] default [valor por defecto];
```

A variable that does not define the 'default' section stores null by default.

An example of defining a variable:
```sql
declare total int default 100;
```

**Example:**
Let's create a stored procedure that receives two integers, defines a local variable to store the sum of those values, and then executes the select command to retrieve the contents of that local variable:
```sql
drop procedure if exists pa_sumar;

delimiter //
create procedure pa_sumar(
  in v1 int,
  in v2 int)
begin
  declare suma int;
  set suma=v1+v2;
  select suma;  
end //
delimiter ;

call pa_sumar(4,5);
```

To modify a variable we use the keyword set:
```sql
set suma=v1+v2;
```