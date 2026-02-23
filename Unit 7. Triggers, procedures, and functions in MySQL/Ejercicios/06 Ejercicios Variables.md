# 06 Ejercicios  de Variable.

**Ejemplo guiado:**

Una empresa tiene registrados sus clientes en una tabla llamada "clientes", también tiene una tabla "provincias" donde registra los nombres de las provincias.

Borramos las tablas si existen y procedemos a crearlas:
```sql
drop table if exists clientes;
 drop table if exists provincias;

 create table clientes (
  codigo int unsigned auto_increment,
  nombre varchar(30) not null,
  domicilio varchar(30),
  ciudad varchar(20),
  codigoprovincia tinyint unsigned,
  telefono varchar(11),
  primary key(codigo)
 );

 create table provincias(
  codigo tinyint unsigned auto_increment,
  nombre varchar(20),
  primary key (codigo)
 );

 insert into provincias (nombre) values('Cordoba');
 insert into provincias (nombre) values('Santa Fe');
 insert into provincias (nombre) values('Corrientes');
 insert into provincias (nombre) values('Misiones');
 insert into provincias (nombre) values('Salta');
 insert into provincias (nombre) values('Buenos Aires');
 insert into provincias (nombre) values('Neuquen');

 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Lopez Marcos', 'Colon 111', 'Córdoba',1,'null');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Perez Ana', 'San Martin 222', 'Cruz del Eje',1,'4578585');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Garcia Juan', 'Rivadavia 333', 'Villa Maria',1,'4578445');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Perez Luis', 'Sarmiento 444', 'Rosario',2,null);
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Pereyra Lucas', 'San Martin 555', 'Cruz del Eje',1,'4253685');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Gomez Ines', 'San Martin 666', 'Santa Fe',2,'0345252525');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Torres Fabiola', 'Alem 777', 'Villa del Rosario',1,'4554455');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Lopez Carlos', 'Irigoyen 888', 'Cruz del Eje',1,null);
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Ramos Betina', 'San Martin 999', 'Cordoba',1,'4223366');
 insert into clientes (nombre,domicilio,ciudad,codigoProvincia,telefono)
  values ('Lopez Lucas', 'San Martin 1010', 'Posadas',4,'0457858745');
```
Crearemos un procedimiento almacenado que le enviemos como parámetro los nombres de dos provincias y genere como resultado la cantidad de clientes que tenemos en cada una de dichas provincias:
```sql
drop procedure if exists pa_cantidad_clientes_provincias;

delimiter //
 create procedure pa_cantidad_clientes_provincias(
   in provincia1 varchar(20),
   in provincia2 varchar(20))
 begin
   declare canti1 int;
   declare canti2 int;
   select count(*) into canti1 from clientes as cli
     join provincias as pro 
     on pro.codigo=cli.codigoprovincia
     where pro.nombre=provincia1;
   select count(*) into canti2 from clientes as cli
     join provincias as pro 
     on pro.codigo=cli.codigoprovincia
     where pro.nombre=provincia2;     
   select canti1,canti2;  
 end //
 delimiter ;
```

Dentro del procedimiento almacenado definimos dos variables locales llamadas 'canti1' y 'canti2' que almacenan en forma temporal la cantidad de clientes que hay en cada una de las dos provincias consultadas.

Si queremos MySQL nos permite declarar las dos variables en la misma línea:
```sql
 declare canti1, canti2 int;
 ```

 Llamamos luego al procedimiento almacenado pasando dos provincias que queremos conocer la cantidad de clientes en forma independiente:
 ```sql
call pa_cantidad_clientes_provincias('Cordoba','Santa Fe');  
 ```

---

## Ejercicio 1
Un video club que alquila películas en video guarda información de sus películas en la 
tabla `peliculas`.

1- Elimine la tabla si existe.

2- Créela con la siguiente estructura:
```sql
create table peliculas (
  codigo smallint unsigned auto_increment,
  titulo varchar(40) not null,
  actor varchar(30),
  duracion tinyint unsigned,
  primary key (codigo)
 );
```
3- Ingrese los siguientes registros para las 3 tablas.
```sql
 insert into peliculas (titulo,actor,duracion)
  values('Elsa y Fred','China Zorrilla',90);
 insert into peliculas (titulo,actor,duracion)
  values('Mision imposible','Tom Cruise',120);
 insert into peliculas (titulo,actor,duracion)
  values('Mision imposible 2','Tom Cruise',180);
 insert into peliculas (titulo,actor,duracion)
  values('Harry Potter y la piedra filosofal','Daniel H.',120);
 insert into peliculas (titulo,actor,duracion)
  values('Harry Potter y la camara secreta','Daniel H.',150);
```

## Punto 4
Guarde en dos variables el valor de duración de la película más larga y el de la más corta:

<details><summary>Mostrar Solución</summary>

```sql
 select @mayorduracion:=max(duracion), @menorduracion:= min(duracion) from peliculas;
```

</details>

## Punto 5
Muestre todos los datos de ambas peliculas; 

<details><summary>Mostrar Solución</summary>

```sql
select * from peliculas
  where duracion=@mayorduracion or
  duracion=@menorduracion;
```

</details>

## Punto 6
Guarde en una variable el nombre del actor de la película de mayor duración:

<details><summary>Mostrar Solución</summary>

```sql
select @actor:=actor
  from peliculas
  where duracion=@mayorduracion;
```
</details>

## Punto 7
Muestre todas las películas en las cuales trabaja el autor almacenado en la variable "@actor":

<details><summary>Mostrar Solución</summary>

```sql
select * from peliculas 
  where actor=@actor;
```
</details>