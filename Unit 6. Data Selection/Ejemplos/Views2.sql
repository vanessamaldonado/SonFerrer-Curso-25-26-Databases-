create database views2;
use views2;

drop table if exists alumnos;
drop table if exists profesores;

 create table alumnos(
  documento char(8),
  nombre varchar(30),
  nota decimal(4,2),
  codigoprofesor int,
  primary key(documento)
 );

 create table profesores (
   codigo int auto_increment,
   nombre varchar(30),
   primary key(codigo)
 );
 insert into alumnos values('30111111','Ana Algarbe', 5.1, 1);
 insert into alumnos values('30222222','Bernardo Bustamante', 3.2, 1);
 insert into alumnos values('30333333','Carolina Conte',4.5, 1);
 insert into alumnos values('30444444','Diana Dominguez',9.7, 1);
 insert into alumnos values('30555555','Fabian Fuentes',8.5, 2);
 insert into alumnos values('30666666','Gaston Gonzalez',9.70, 2);

 insert into profesores(nombre) values ('Maria Luque');
 insert into profesores(nombre) values ('Jorje Dante'); 

 drop view if exists vista_nota_alumnos_aprobados;

 -- Creamos una vista con los datos de todos los alumnos que tienen
 -- una nota mayor o igual a 7, junto con el nombre del profesor que lo calificó
 create view vista_nota_alumnos_aprobados as
   select documento,
          a.nombre as nombrealumno,
          p.nombre as nombreprofesor,
          nota,
          codigoprofesor
     from alumnos as a
     join profesores as p on a.codigoprofesor=p.codigo
     where nota>=7;

select * from vista_nota_alumnos_aprobados;

-- Mediante la vista insertamos un nuevo alumno calificado por el profesor con código 1
insert into vista_nota_alumnos_aprobados(documento, nombrealumno, nota, codigoprofesor)
  values('99999999','Rodriguez Pablo', 10, 1);
   
select * from vista_nota_alumnos_aprobados;  

-- si consultamos la tabla base: alumnos tenemos una nueva fila con el alumno insertado
select * from alumnos;

-- modificamos la nota de un alumno aprobado mediante la vista
update vista_nota_alumnos_aprobados set nota=10 
  where documento='30444444';
  
select * from alumnos;

/* Si efectuamos un insert mediante la vista creada e insertamos un alumno con 
una nota inferior a 7 luego dicha fila se inserta en la tabla base pero no se visualiza en la vista:*/

insert vista_nota_alumnos_aprobados(documento, nombrealumno, nota, codigoprofesor)
  values('88888888','Laura Robles', 3, 1);

-- se cargó en la tabla 'alumnos'
select * from alumnos;  

-- no se visualiza en la vista
select * from vista_nota_alumnos_aprobados;  

/* Para evitar este tipo de inconsistencias se ha creado la cláusula 'with check option'. 
Si agregamos ésta cláusula cuando creamos la vista luego no se harán inserciones, 
borrados o actualizaciones cuando los cambios no se visualizan en la vista.
Probemos de crear ahora la vista con la cláusula 'with check option' y tratemos de insertar 
una fila que no se visualiza en la vista:*/

drop table if exists alumnos;
drop table if exists profesores;
 
 create table alumnos(
  documento char(8),
  nombre varchar(30),
  nota decimal(4,2),
  codigoprofesor int,
  primary key(documento)
 );

 create table profesores (
   codigo int auto_increment,
   nombre varchar(30),
   primary key(codigo)
 );
 insert into alumnos values('30111111','Ana Algarbe', 5.1, 1);
 insert into alumnos values('30222222','Bernardo Bustamante', 3.2, 1);
 insert into alumnos values('30333333','Carolina Conte',4.5, 1);
 insert into alumnos values('30444444','Diana Dominguez',9.7, 1);
 insert into alumnos values('30555555','Fabian Fuentes',8.5, 2);
 insert into alumnos values('30666666','Gaston Gonzalez',9.70, 2);

 insert into profesores(nombre) values ('Maria Luque');
 insert into profesores(nombre) values ('Jorje Dante'); 

 drop view if exists vista_nota_alumnos_aprobados;

 create view vista_nota_alumnos_aprobados as
   select documento,
          a.nombre as nombrealumno,
          p.nombre as nombreprofesor,
          nota,
          codigoprofesor
     from alumnos as a
     join profesores as p on a.codigoprofesor=p.codigo
     where nota>=7
     with check option;

-- Se genera error ya que luego este alumno no aparecerá en la vista
 update vista_nota_alumnos_aprobados set nota=1 
   where documento='30444444';
   
 -- Se genera un error
 insert vista_nota_alumnos_aprobados(documento, nombrealumno, nota, codigoprofesor)
  values('73777777','Raquel Montes', 3, 1);
     
 -- Se efectúa la inserción en forma correcta
 insert vista_nota_alumnos_aprobados(documento, nombrealumno, nota, codigoprofesor)
  values('73777777','Raquel Montes', 7, 1);

 select * from vista_nota_alumnos_aprobados;  
-- Se produce un error al tratar de insertar un alumno con nota menor a 7:

