# Ejercicios de Vistas

## Enunciado 1:
Un club dicta cursos de distintos deportes. Almacena la información en varias tablas.
El director no quiere que los empleados de administración conozcan la estructura de las tablas ni 
algunos datos de los profesores y socios, por ello se crean vistas a las cuales tendrán acceso.

1 - Elimine las tablas si existen  y créelas nuevamente con las siguientes estructuras:

```sql
 create table socios(
  documento char(8) not null,
  nombre varchar(40),
  domicilio varchar(30),
  primary key (documento)
 );

 create table profesores(
  documento char(8) not null,
  nombre varchar(40),
  domicilio varchar(30),
  primary key (documento)
 );

 create table cursos(
  numero integer auto_increment,
  deporte varchar(20),
  dia varchar(15),
  documentoprofesor char(8),
  primary key (numero)
 );

 create table inscriptos(
  documentosocio char(8) not null,
  numero integer not null,
  matricula char(1),
  primary key (documentosocio,numero)
 );
```

2- Ingrese algunos registros para todas las tablas:
```sql
 insert into socios values('30000000','Fabian Fuentes','Caseros 987');
 insert into socios values('31111111','Gaston Garcia','Guemes 65');
 insert into socios values('32222222','Hector Huerta','Sucre 534');
 insert into socios values('33333333','Ines Irala','Bulnes 345');

 insert into profesores values('22222222','Ana Acosta','Avellaneda 231');
 insert into profesores values('23333333','Carlos Caseres','Colon 245');
 insert into profesores values('24444444','Daniel Duarte','Sarmiento 987');
 insert into profesores values('25555555','Esteban Lopez','Sucre 1204');

 insert into cursos(deporte,dia,documentoprofesor) 
  values('tenis','lunes','22222222');
 insert into cursos(deporte,dia,documentoprofesor) 
  values('tenis','martes','22222222');
 insert into cursos(deporte,dia,documentoprofesor) 
  values('natacion','miercoles','22222222');
 insert into cursos(deporte,dia,documentoprofesor) 
  values('natacion','jueves','23333333');
 insert into cursos(deporte,dia,documentoprofesor) 
  values('natacion','viernes','23333333');
 insert into cursos(deporte,dia,documentoprofesor) 
  values('futbol','sabado','24444444');
 insert into cursos(deporte,dia,documentoprofesor) 
  values('futbol','lunes','24444444');
 insert into cursos(deporte,dia,documentoprofesor) 
  values('basquet','martes','24444444');

 insert into inscriptos values('30000000',1,'s');
 insert into inscriptos values('30000000',3,'n');
 insert into inscriptos values('30000000',6,null);
 insert into inscriptos values('31111111',1,'s');
 insert into inscriptos values('31111111',4,'s');
 insert into inscriptos values('32222222',8,'s');
```

3- Elimine la vista "vista_club" si existe.

4 - Cree una vista en la que aparezca el nombre y documento del socio, el deporte, el día y el nombre del profesor (no mostrar datos de los socios que no están inscriptos en deportes)

5- Muestre la información contenida en la vista.

6- Realice una consulta a la vista donde muestre la cantidad de socios inscriptos en cada deporte ordenados por cantidad.

7- Muestre (consultando la vista) el nombre y documento de los socios que deben matrículas.

8- Consulte la vista y muestre los nombres de los profesores y los días en que asisten al club para dictar sus clases.

9- Muestre todos los socios que son compañeros en tenis los lunes.

10 - Cree una nueva vista llamada `vista_inscriptos` que muestre la cantidad de inscriptos por curso, incluyendo el nombre del deporte y el día. Elimine la vista previamente si ya existe.

11- Consulte la vista 'vista_inscriptos':


## Enunciado 2:
Un profesor almacena el documento, nombre y la nota final de cada alumno de su clase en una tabla 
llamada **alumnos**.

1- Elimine la tabla si existe y luego Créela
```sql  
 drop table if exists alumnos;

 create table alumnos(
  documento char(8),
  nombre varchar(30),
  nota decimal(4,2),
  primary key(documento)
 );
```
2-Ingrese algunos registros:
```sql
 insert into alumnos values('30111111','Ana Algarbe',5.1);
 insert into alumnos values('30222222','Bernardo Bustamante',3.2);
 insert into alumnos values('30333333','Carolina Conte',4.5);
 insert into alumnos values('30444444','Diana Dominguez',9.7);
 insert into alumnos values('30555555','Fabian Fuentes',8.5);
 insert into alumnos values('30666666','Gaston Gonzalez',9.70);
```

3-Cree una vista que recupere el nombre y la nota de todos los alumnos (borrar la vista si ya existe)

4-Mostrar el resultado de llamar la vista en un comando SQL 'select'.

5-Crear una vista que retorne el nombre y la nota de todos los alumnos aprobados (notas mayores iguales a 7) a partir de la vista anterior.

6-Muestre la información que genera la vista.

--- 



