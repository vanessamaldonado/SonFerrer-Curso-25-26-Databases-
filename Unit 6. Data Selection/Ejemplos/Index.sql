create database indices;
use indices;

-- index primary
drop table if exists libros;
create table libros(
  codigo int unsigned auto_increment,
  titulo varchar(40) not null,
  autor varchar(30),
  editorial varchar(15),
  primary key(codigo)
 );
show index from libros;

-- index
drop table if exists libros;
create table libros(
  codigo int unsigned auto_increment,
  titulo varchar(40) not null,
  autor varchar(30),
  editorial varchar(15),
  primary key(codigo),
  index i_editorial (editorial)
 );
show index from libros;

-- multiple 
drop table if exists libros;
create table libros(
  codigo int unsigned auto_increment,
  titulo varchar(40) not null,
  autor varchar(30),
  editorial varchar(15),
  primary key(codigo),
  index i_tituloeditorial (titulo,editorial)
 );
 show index from libros;
 
 -- unique index
drop table if exists libros;
create table libros(
  codigo int unsigned auto_increment,
  titulo varchar(40) not null,
  autor varchar(30),
  editorial varchar(15),
  unique i_codigo (codigo),
  unique i_tituloeditorial (titulo,editorial)
);
show index from libros;

-- drop index
drop table if exists libros;
create table libros(
  codigo int unsigned auto_increment,
  titulo varchar(40) not null,
  autor varchar(30),
  editorial varchar(15),
  primary key (codigo),
  index i_editorial (editorial),
  unique i_tituloeditorial (titulo,editorial)
 );
show index from libros;
drop index i_editorial on libros;
drop index i_tituloeditorial on libros;
show index from libros;

-- create index
drop table if exists libros;
create table libros(
  codigo int unsigned auto_increment,
  titulo varchar(40) not null,
  autor varchar(30),
  editorial varchar(15),
  primary key (codigo)
 );
show index from libros;
create index i_editorial on libros (editorial);
show index from libros;
create unique index i_tituloeditorial on libros (titulo,editorial);
show index from libros;

-- alter index
drop table if exists libros;
create table libros(
  codigo int unsigned,
  titulo varchar(40),
  autor varchar(30),
  editorial varchar (20),
  precio decimal(5,2),
  cantidad smallint
 );
 show index from libros;
alter table libros
  add index i_editorial (editorial);
  show index from libros;
alter table libros
  add unique index i_tituloeditorial (titulo,editorial);
show index from libros;

-- drop index
drop table if exists libros;
create table libros(
  codigo int unsigned auto_increment,
  titulo varchar(40) not null,
  autor varchar(30),
  editorial varchar(15),
  primary key(codigo),
  index i_editorial (editorial),
  unique i_tituloeditorial (titulo,editorial)
 );
 show index from libros;
alter table libros
  drop index i_editorial;
  show index from libros;
alter table libros
  drop index i_tituloeditorial;
show index from libros;