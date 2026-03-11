# Práctica 03 de la unidad 7: Procedures y Funciones

## Enunciado:

Dada la siguiente base de datos de un campeonato de fútbol:

```sql
CREATE DATABASE IF NOT EXISTS campeonato_futbol;
USE campeonato_futbol;

-- Tabla de equipos
CREATE TABLE equipo (
    id_equipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    patrocinador VARCHAR(50),
    color_primera VARCHAR(30),
    color_segunda VARCHAR(30),
    categoria VARCHAR(30)
);

-- Tabla de jugadores
CREATE TABLE jugador (
    id_jugador INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(30) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    edad INT,
    posicion_principal VARCHAR(30),
    id_equipo INT NOT NULL,
    FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo)
);

-- Tabla de partidos
CREATE TABLE partido (
    id_partido INT AUTO_INCREMENT PRIMARY KEY,
    id_equipo_local INT NOT NULL,
    id_equipo_visitante INT NOT NULL,
    goles_local INT,
    goles_visitante INT,
    campo VARCHAR(50),
    arbitro VARCHAR(50),
    incidencias VARCHAR(255),
    FOREIGN KEY (id_equipo_local) REFERENCES equipo(id_equipo),
    FOREIGN KEY (id_equipo_visitante) REFERENCES equipo(id_equipo)
);

USE campeonato_futbol;

INSERT INTO equipo (nombre, patrocinador, color_primera, color_segunda, categoria) VALUES
('Tigres FC', 'Nike', 'Rojo', 'Blanco', 'Juvenil'),
('Leones CF', 'Adidas', 'Azul', 'Negro', 'Juvenil'),
('Halcones UD', 'Puma', 'Verde', 'Amarillo', 'Cadete');

INSERT INTO jugador (dni, nombre, apellidos, edad, posicion_principal, id_equipo) VALUES
('11111111A', 'Ana', 'López García', 18, 'Delantera', 1),
('22222222B', 'Luis', 'Martín Pérez', 19, 'Portero', 1),
('33333333C', 'Marta', 'Sánchez Ruiz', 18, 'Defensa', 2),
('44444444D', 'Pablo', 'Gómez Ruiz', 20, 'Centrocampista', 2),
('55555555E', 'Sara', 'Navarro Gil', 17, 'Delantera', 3);

INSERT INTO partido (id_equipo_local, id_equipo_visitante, goles_local, goles_visitante, campo, arbitro, incidencias) VALUES
(1, 2, 3, 1, 'Campo Municipal', 'Sr. Pérez', NULL),
(2, 3, 2, 2, 'Campo Norte', 'Sr. Gómez', 'Tarjeta roja en el minuto 70'),
(1, 3, 1, 0, 'Campo Sur', 'Srta. Ruiz', NULL);
```

--- 

se pide crear los procedimientos y funciones necesarios para realizar las siguientes operaciones:

**a) Alta de jugador**

Crea un procedimiento almacenado llamado `pcr_alta_jugador` que inserte un nuevo jugador en la tabla jugador.

Parámetros:
- dni
- nombre
- apellidos
- edad
- posicion_principal
- id_equipo

Condiciones: 
- Si el equipo indicado no existe, se deberá lanzar una excepción con: SQLSTATE '45000', mensaje: 'El equipo no existe'

- Si la edad es negativa, se deberá lanzar una excepción con: SQLSTATE '45000', mensaje: 'La edad no puede ser negativa'

- Debes incluir un HANDLER para capturar el error de clave duplicada y mostrar el mensaje: 'El DNI ya existe'

--- 

**b) Alta de equipo**

Crea un procedimiento almacenado llamado `pcr_alta_equipo` que inserte un nuevo equipo en la tabla equipo.

Parámetros:
- nombre
- patrocinador
- color_primera
- color_segunda
- categoria

Condiciones:
- Si el nombre del equipo está vacío, se deberá lanzar una excepción con: SQLSTATE '45000', mensaje: 'El nombre del equipo no puede estar vacío'

---

**c) Registrar resultado de un partido**

Crea un procedimiento almacenado llamado `pcr_registrar_partido` que inserte un nuevo partido en la tabla partido.

Parámetros:
- id_equipo_local
- id_equipo_visitante
- goles_local
- goles_visitante
- campo
- arbitro

Condiciones:

- Si alguno de los dos equipos no existe, se deberá lanzar una excepción con: SQLSTATE '45000', mensaje: 'Uno de los equipos no existe'

- Si los dos equipos son el mismo, se deberá lanzar una excepción con: SQLSTATE '45000', mensaje: 'Un equipo no puede jugar contra sí mismo'

- Si alguno de los goles es negativo, se deberá lanzar una excepción con: SQLSTATE '45000', mensaje: 'Los goles no pueden ser negativos'

---

**d) Eliminar un jugador**

Crea un procedimiento almacenado llamado `pcr_eliminar_jugador` que elimine un jugador a partir de su DNI.

Parámetro: dni

Condiciones: 

- Si el jugador no existe, se deberá lanzar una excepción con: SQLSTATE '45000', mensaje: 'El jugador no existe'

---

**e) Anotar incidencias de un partido**

Crea un procedimiento almacenado llamado `pcr_anotar_incidencias` que actualice el campo incidencias de un partido.

Parámetros:
- id_partido
- incidencias

Condiciones:

- Si el partido no existe, se deberá lanzar una excepción con: SQLSTATE '45000', mensaje: 'El partido no existe'

---

**f) Número de goles de un equipo en un partido**

Crea una función llamada `f_goles_equipo_partido` que reciba:
- id_partido
- id_equipo

y devuelva el número de goles que ese equipo ha marcado en ese partido.

Condiciones:

- Si el partido no existe, deberá devolver -1

- Si el equipo no participó en ese partido, deberá devolver 0

La función debe declararse como
- DETERMINISTIC
- READS SQL DATA

---


**g) Número de goles que un equipo ha marcado a otro**

Crea una función llamada `f_goles_contra_equipo` que reciba:
- id_equipo1
- id_equipo2

y devuelva el número de goles que el primer equipo ha marcado al segundo.

Condiciones:

- Antes de realizar el cálculo, la función debe comprobar que los dos equipos existen

- Si alguno de los dos equipos no existe, deberá devolver -1

La función debe declararse como:
- DETERMINISTIC
- READS SQL DATA

--- 

**h) Evitar que se inserte un partido con el mismo equipo como local y visitante.**

Crea un trigger llamado trg_comprobar_equipos_distintos sobre la tabla partido.
- Debe ejecutarse antes de insertar un partido.
- Debe comprobar que el equipo local y el equipo visitante son distintos.
- Si son el mismo equipo, deberá lanzar una excepción con: SQLSTATE '45000', mensaje: 'Un equipo no puede jugar contra sí mismo'

---

**i) Crear una tabla de historial donde se guarden los partidos registrados**

Dada la tabla:
```sql
CREATE TABLE historial_partido (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_partido INT,
    mensaje VARCHAR(255)
);
```

Crea un trigger llamado `trg_historial_partido` sobre la tabla partido.
- Debe ejecutarse después de insertar un partido.
- Debe guardar en la tabla historial_partido:
  - el id_partido
  - un mensaje con el texto: 'Partido registrado correctamente'

