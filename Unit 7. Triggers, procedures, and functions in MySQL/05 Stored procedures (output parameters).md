# Stored procedures (output parameters)

We said that stored procedures can return information; this is done using output parameters. The value is returned to the caller with output parameters. 
For a stored procedure to return a value, a variable must be declared with the keyword "out" when creating the procedure.

```sql
create procedure PROCEDURENAME (out PARAMETERNAME DATATYPE)
 begin
 end
```
As an example, we will implement a stored procedure that takes two integers and returns the average of those values:

```sql
drop procedure if exists pa_average;
 
 delimiter //
 create procedure pa_promedio(
   in n1 float,
   in n2 float,
   out result float)
 begin
   select (n1+n2)/2 into result;
 end //
 delimiter;
 
 call pa_promedio(10, 5, @resu);
 
 select @resu;
```

The stored procedure has three parameters; the first two are inputs, and the last is an output. Using a SELECT statement, we calculate 
the average of parameters n1 and n2, and store the average of the first two parameters in the 'resultado' parameter.

When we call the stored procedure, we must pass two numeric values ​​and, as a final piece of data, a variable where the result is stored:

```sql
call pa_promedio(10, 5, @resu);
```
Then we print the value stored in the variable @resu:

```sql
select @resu;
```
