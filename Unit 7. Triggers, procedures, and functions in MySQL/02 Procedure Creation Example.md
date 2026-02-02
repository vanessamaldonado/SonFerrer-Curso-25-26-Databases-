# 
Let's open the "Workbench" program and run the following block of SQL instructions to test a stored procedure:

```sql
create database procedures;
use procedures;
drop table if exists libros;

create table libros(
  codigo int auto_increment,
  titulo varchar(40),
  autor varchar(30),
  editorial varchar(20),
  precio decimal(5,2),
  stock int,
  primary key(codigo)
);

 insert into libros(titulo,autor,editorial,precio,stock) 
  values('Alicia en el pais de las maravillas','Lewis Carroll','Emece',20.00, 9);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Alicia en el pais de las maravillas','Lewis Carroll','Plaza',35.00, 50);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Aprenda PHP','Mario Molina','Siglo XXI',40.00, 3);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('El aleph','Borges','Emece',10.00, 18);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Ilusiones','Richard Bach','Planeta',15.00, 22);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Java en 10 minutos','Mario Molina','Siglo XXI',50.00, 7);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Martin Fierro','Jose Hernandez','Planeta',20.00, 3);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Martin Fierro','Jose Hernandez','Emece',30.00, 70);
 insert into libros(titulo,autor,editorial,precio,stock)
  values('Uno','Richard Bach','Planeta',10.00, 120);

 drop procedure if exists pa_libros_limite_stock;

 delimiter //
 create procedure pa_libros_limite_stock()
 begin
   select * from libros
   where stock<=10;
 end //
 delimiter ;
 
 call pa_libros_limite_stock();
``` 
 
It generates an output similar to this:

![procedures](./assets/procedures01.png)

## Creating a stored procedure using the "Workbench" facilities:
We must press the left mouse button on **Stored Procedures** for the database where we want to create the stored procedure:

![procedures](./assets/procedures02.png)

A dialog box is created where we can code the stored procedure:

![procedures](./assets/procedures03.png)

After coding the stored procedure, we press the `Apply` button and a new dialog box appears with the final code of the stored procedure:


Once confirmed, the new procedure is stored in the database so that we can later invoke it with the 'call' command:

```sql
call st_libros_precios_bajos;
```

