# Ejercicios de Creación de índices 

## Enunciado 1:
Tenemos la siguiente tabla **clientes** que almacena información sobre los clientes de una empresa.

1- Elimine la tabla "clientes", si existe.
2- Créela con esta estructura:
```sql
 create table clientes (
  documento char (8) not null,
  nombre varchar(30) not null,
  domicilio varchar(30),
  ciudad varchar(20),
  provincia varchar (20),
  telefono varchar(11)
 );
 ```
3- Agregue un índice común por ciudad y provincia.
4- Vea la información de los índices.
5- Agregue un índice único por el campo "documento".

## Enunciado 2:
Una clínica registra las consultas de los pacientes en una tabla llamada **consultas**.

1- Elimine la tabla si existe.
2- Cree la tabla con la siguiente estructura:
```sql
 create table consultas(
  fecha date,
  numero int unsigned,
  documento char(8) not null,
  obrasocial varchar(30),
  medico varchar(30),
 );
 ```
3- Agregue un índice único multicampo (fecha,documento,medico):
4- Agregue un índice común por el campo "medico":
5- Agregue un índice común por el campo "obrasocial":
6- Vea los índices.

## Enunciado 3:
Trabajaremos con la tabla **alumnos** en el cual un instituto de enseñanza guarda los datos de sus alumnos.

1- Elimine la tabla "alumnos" si existe.
2- Cree la tabla:
```sql
 create table alumnos(
  legajo int unsigned auto_increment,
  nombre varchar(30),
  documento char(8) not null,
  domicilio varchar(30),
  ciudad varchar(20),
  provincia varchar(20),
  primary key(legajo)
 );
 ```
3- Vea los índices de la tabla.
4- Agregue un índice común por los campos "ciudad" y "provincia" (que pueden repetirse).
5- Agregue un índice único (no pueden repetirse los valores) por el campo "documento".
6- Visualice los índices.

## Enunciado 4: 
Una clínica registra las consultas de los pacientes en una tabla llamada **consultas**.

1- Elimine la tabla si existe.
2- Cree la tabla con una clave primaria compuesta (fecha y número de consulta):
```sql
 create table consultas(
  fecha date,
  numero int unsigned,
  documento char(8) not null,
  obrasocial varchar(30),
  medico varchar(30),
  primary key(fecha,numero)
 );
 ```
3- Agregue un índice único llamado "i_consulta" compuesto por los campos "documento", "fecha" y "medico".
4- Hay 2 campos por los cuales podemos realizar consultas frecuentemente: "medico" y "obrasocial", cree índices comunes para esos campos.
5- Vea los índices.

## Enunciado 5:
Trabajaremos con la tabla **alumnos** en la cual un instituto de enseñanza guarda los datos de sus 
alumnos.

1- Elimine la tabla "alumnos" si existe.
2- Cree la tabla con los siguientes índices:
```sql
 create table alumnos(
  año year not null,
  numero int unsigned not null,
  nombre varchar(30),
  documento char(8) not null,
  domicilio varchar(30),
  ciudad varchar(20),
  provincia varchar(20),  
  primary key(año,numero),
  unique i_documento (documento),
  index i_ciudadprovincia (ciudad,provincia),
 );
```
3- Vea los índices de la tabla.
4- Elimine el índice único.
5- Elimine el índice común.
6- Vea los índices.

## Enunciado 6:
Una clínica registra las consultas de los pacientes en una tabla llamada **consultas**.

1- Elimine la tabla si existe.
2- Cree la tabla con la siguiente estructura:
```sql
create table consultas(
  fecha date,
  numero int unsigned,
  documento char(8) not null,
  obrasocial varchar(30),
  medico varchar(30),
  primary key(fecha,numero),
  unique i_consulta(documento,fecha,medico),
  index i_medico (medico),
  index i_obrasocial (obrasocial)
 );
```
3- Vea los índices de la tabla.
4- Elimine el índice único:
5- Elimine los índices comumes:
6- Vea los índices:

--- 


<details><summary>Mostrar Solución Enunciado 1 </summary>

```sql
 create index i_ciudadprovincia on clientes (ciudad,provincia);
 show index from clientes;
 create unique index i_documento on clientes (documento);
 ```
</details>


<details><summary>Mostrar Solución Enunciado 2</summary>

```sql
 create unique index i_consulta on consultas (fecha,documento,medico);
 create index i_medico on consultas (medico);
 create index i_obrasocial on consultas (obrasocial);
 show index from consultas;
 ```
</details>

<details><summary>Mostrar Solución Enunciado 3</summary>

```sql
 alter table alumnos
  add index i_ciudadprovincia(ciudad,provincia);
 alter table alumnos
   add unique index i_documento (documento);
 show index from alumnos;
```
</details>

<details><summary>Mostrar Solución Enunciado 4</summary>

```sql
 alter table consultas
  add unique index i_consulta(documento,fecha,medico);
 alter table consultas
  add index i_medico (medico);
 alter table consultas
  add index i_obrasocial (obrasocial);
```
</details>


<details><summary>Mostrar Solución Enunciado 5</summary>

```sql
 show index from alumnos;
 alter table alumnos
  drop index i_documento;
 alter table alumnos
  drop index i_ciudadprovincia;
 show index from alumnos;
```
</details>

<details><summary>Mostrar Solución Enunciado 6</summary>

```sql
 show index from consultas;
 alter table consultas
  drop index i_consulta;
 alter table consultas
  drop index i_medico;
 alter table consultas
  drop index i_obrasocial;
 show index from consultas;
```
</details>
