# Input Parameters Example

Let's open the "Workbench" program and run the following block of SQL instructions:

```sql
drop table if exists libros;

 create table libros(
  code int auto_increment,
  title varchar(40),
  author varchar(30),
  editorial varchar(20),
  decimal price(5,2),
  primary key(code)
 );

 INSERT INTO books (title, author, publisher, price)
  values ​​('One','Richard Bach','Planet',15);
 INSERT INTO books (title, author, publisher, price)
  values ​​('Illusions','Richard Bach','Planet',12);
 INSERT INTO books (title, author, publisher, price)
  values ​​('El aleph','Borges','Emece',25);
 INSERT INTO books (title, author, publisher, price)
  values ​​('Learn PHP','Mario Molina','New Century',50);
 INSERT INTO books (title, author, publisher, price)
  values ​​('Mathematics are there','Paenza','New century',18);
 INSERT INTO books (title, author, publisher, price)
  values ​​('Bridge to Infinity','Bach Richard','Sudamericana',14);
 INSERT INTO books (title, author, publisher, price)
  values ​​('Anthology','JL Borges','Paidos',24);
 INSERT INTO books (title, author, publisher, price)
  values ​​('Java in 10 minutes','Mario Molina','21st Century',45);
 INSERT INTO books (title, author, publisher, price)
  values ​​('Cervantes and Don Quixote','Borges-Casares','Planeta',34);

 drop procedure if exists pa_libros_autor;

 delimiter //
 create procedure pa_libros_autor(in p_autor varchar(30))
 begin
   select title, publisher, price
     from libros
     where autor= p_autor;
 end //
 delimiter ;
  
 call pa_libros_autor('Richard Bach');
 drop procedure if exists pa_libros_autor_editorial;

 delimiter //
 create procedure pa_libros_autor_editorial(
   in p_autor varchar(30),
   in p_editorial varchar(20))
 begin
   select title, price
     from libros
     where autor= p_autor and
           editorial=p_editorial;
 end //
 delimiter ;
 
 call pa_libros_autor_editorial('Richard Bach','Planeta');
 call pa_libros_autor_editorial('Borges','Emece');
```
It generates an output similar to this:

