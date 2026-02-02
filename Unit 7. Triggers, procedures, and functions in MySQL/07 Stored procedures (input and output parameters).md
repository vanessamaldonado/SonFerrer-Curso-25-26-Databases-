# Stored procedures (input and output parameters)

The third way to define a parameter in a stored procedure in MySQL is to define it as input and output simultaneously.
We define an input and output parameter using the inout keyword:

```sql
create procedure PROCEDURENAME (inout PARAMETERNAME DATATYPE)
 begin
 end
```
As an example, we will implement a stored procedure that receives an input/output parameter with an integer and returns it incremented by 1:

```sql
 drop procedure if exists pa_incrementar;
 
 delimiter //
 create procedure pa_incrementar(
   inout contador int)
 begin
   set counter = counter + 1;
 end //
 delimiter ;
 
 set @conta=1;
 select @conta; -- a 1 is printed
 call pa_incrementar(@conta);
 select @conta; -- a 2 is printed
 call pa_incrementar(@conta);
 select @conta; -- a 3 is printed
 call pa_incrementar(@conta);
 select @conta; -- a 4 is printed
 call pa_incrementar(@conta);
 select @conta; -- a 5 is printed
 ```
As we can see within the stored procedure, we modify the counter parameter by storing the current value plus 1:

```sql
   set counter = counter + 1;
```
When calling the stored procedure, we must be careful to pass a variable that has already been initialized:

```sql
set @conta=1;
 select @account;
 call pa_incrementar(@conta);
 select @account;
```
The variable @conta starts with the value 1 and after the 'pa_incrementar' procedure is executed, the variable @conta stores the value 2.
