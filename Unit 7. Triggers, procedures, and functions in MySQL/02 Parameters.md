# Parameters
When we call a procedure, it may be necessary to 'send' information to it.

For example:
- We may want to know the active connections of a particular user.
- We may want to know which users have selection permission on a given database.
- We may want to know who earns more than a certain salary.

In each of the previous queries we will want to use a piece of data that must be supplied by the user at the time of calling the procedure.

- Each piece of data that we send to a stored procedure is called a parameter. 
  Parameters are variables whose value is used within the stored procedure.
  As a general rule, any modification we make to the parameter value within the stored procedure has no effect outside of it.
  These types of parameters are called input parameters.
- Output parameters are parameters used by a stored procedure to inform the caller and assign a value to   that parameter within the procedure. This value will then be used by the caller, who reads the modified parameter value. This type of parameter is called an output parameter .
- The parameters that can carry information to the procedure, that can be modified within the procedure, and that can be used by the person who made the procedure call are called input/output parameters.
- We must be careful with the parameter names and ensure they do not match the column names in a table, as MySQL will always interpret them as the parameter name and never the column name.
- We could solve this by referencing the column name in the following format: table_name.column_name
- Although there is no rule that dictates how to name the parameters, I recommend following this:
  Define the parameters with the prefix: `p_ parameter_name type`

--- 

## Entrance
It is the default type if we do not specify anything in the procedure definition.

```sql
DELIMITER  \\
CREATE  PROCEDURE  procedure_name  ( IN  parameter_name  data_type )
BEGIN

END // 
DELIMITER  ;
```

It would be the same as not putting IN (default type):

```sql
DELIMITER  \\
CREATE  PROCEDURE  procedure_name  ( parameter_name  data_type )
BEGIN

END // 
DELIMITER  ;
```

Once defined, we can use it within the procedure as if we had a local variable.

The difference is that the person calling the procedure will be able to send a value in the following format:

```sql
CALL  procedure_name ( 100 );
```

In this case, the parameter must be defined as a numeric type (for example, int).
Or in the form:

```sql
SET  @ data  =  100 ;
CALL  procedure_name ( @ data );
```

![Note] 

Remember that these types of variables are session variables and are global to the current MySQL connection. Therefore, we could directly access and modify their value within the stored procedure without using parameters, but from a programming perspective, it's more correct to use parameters for procedures that require them. Furthermore, we can call procedures from other procedures where the variables are local.

We can define as many parameters as we want, as long as the number of data to be sent corresponds to the number of parameters in the procedure.

```sql
DELIMITER \\
CREATE PROCEDURE nombre_proc_varios_param (nombre_parametro1 tipo_dato,nombre_parametro2 tipo_dato,....)
BEGIN

END//
DELIMITER ;

CALL nombre_proc_varios_param(dato1,datos2,...);
```

## Output

In this type of parameter, when the stored procedure modifies its value, this is reflected in the code from where the call was made.

In the parameter definition we must add the word `OUT`.

For example:

```sql
DELIMITER \\
CREATE PROCEDURE nombre_proc (OUT nombre_parametro1 tipo_dato)
BEGIN
     .......
     SET nombre_parametro1 = 1;  // Cualquier instrucción que modifique el valor, como SELECT INTO, SET,....
END//
DELIMITER ;
```

Upon exiting the procedure, the parameter value will be 1.
Who calls him:

```sql
CALL nombre_proc(@dato);

SELECT @dato;    // El valor de la variable @dato es uno, ya que fue modificado por el procedimiento y es de salida.  
```

We can use any combination of output and input parameters in the same procedure.

## IN/OUT

Input/Output parameters are the result of applying the concepts learned for input and output parameters.

These are parameters to which we will be able to give an initial value, call the procedure and it will be able to use the value sent and within the procedure it will be able to change its value and this will be reflected from where it was called.

For example:

```sql
DELIMITER \\
CREATE PROCEDURE nombre_proc (INOUT nombre_parametro1 tipo_dato)
BEGIN
     SELECT 
     FROM TABLA
     WHERE columna = nombre_parametro1;
     .......
     SET nombre_parametro1 = 1;  // Cualquier instrucción que modifique el valor, como SELECT INTO, SET,....
END//
DELIMITER ;
```

Upon exiting the procedure, the parameter value will be 1.

Who calls him:

```sql
SET @dato = 100;  // El procedimiento podrá hacer uso del valor enviado en la variable @dato
CALL nombre_proc(@dato); 

SELECT @dato;    // El valor de la variable @dato es uno, ya que fue modificado por el procedimiento y es de salida.
```