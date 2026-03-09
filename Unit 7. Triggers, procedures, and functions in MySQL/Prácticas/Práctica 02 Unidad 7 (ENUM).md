# Práctica 02 de la unidad 7: Triggers

## Ejercicio 1:

Tenemos la siguiente base de datos de un videojuego de carreras está formada por estas tablas:

```sql
CREATE TABLE player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    points INT DEFAULT 0
);

CREATE TABLE race (
    race_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE result (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT,
    race_id INT,
    position INT,
    final_time TIME,
    FOREIGN KEY (player_id) REFERENCES player(player_id),
    FOREIGN KEY (race_id) REFERENCES race(race_id)
);
```

--- 

Escribe las sentencias SQL necesarias para implementar las siguientes funcionalidades:

a) Crea un disparador que, al insertar un nuevo resultado en la tabla `result`, asigne puntos al jugador según su posición en la carrera.

El sistema de puntuación será:
- primer puesto: 10 puntos
- segundo puesto: 7 puntos
- tercer puesto: 5 puntos

--- 

b) Crea un disparador BEFORE INSERT que compruebe que no haya dos jugadores con la misma posición en una misma carrera.

---

c) Crea un disparador que, al eliminar un jugador de la tabla `player`, guarde su nombre y sus puntos en una tabla `player_history`.

---

d) Crea un disparador BEFORE DELETE en race que impida eliminar una carrera si hay registros en `result`.