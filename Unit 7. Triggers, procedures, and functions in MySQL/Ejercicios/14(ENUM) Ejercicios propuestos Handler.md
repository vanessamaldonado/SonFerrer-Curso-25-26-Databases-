# Ejercicios propuestos de Handlers

Haremos uso de la base de datos `Circo`.

## Ejercicio 1: 
Crea un procedimiento de nombre `animales_Delete` que dado el nombre de un animal, lo borre. Antes tendrá que borrar todas las tablas relacionadas. 

En el caso de que el animal tenga menos de 2 años no estará permitido borrarlo y lanzará una excepción (recordar que el código de error para excepciones definidas por el usuario es el 45000) con el texto: *No es posible dar de baja a animales con menos de dos años*. 

En el caso de que el animal no exista, deberá lanzar una excepción con el texto *'Ese animal no existe'* y un ErrorCode 1643.

---

## Ejercicio 2:
Crea un procedimiento de nombre `animales_addArtista` al que se le pase el nombre de un animal y el nif de un artista y asigne el cuidador al animal. 

Deberá comprobar que el animal y el artista existen. En caso de que no, deberá lanzar una excepción con el ErrorCode 1643 y texto *'El animal no existe'* o *'El artista no existe'*.

En el caso de que ya exista ese artista con ese animal el propio Mysql lanzará una excepción de clave primaria duplicada.

---

### Ejercicio 3
Crea un procedimiento de nombre `animales_add` que añade un nuevo animal. En caso de intentar dar de alta un animal con el mismo nombre, captura la excepción y haz que el procedimiento devuelva (con un select) -1. En caso de que el alta sea correcta, que devuelva 0.

En el caso de que el nombre de la pista o de la atracción no exista, captura la excepción y devuelve el valor -2.

Trabaja con nombres de excepciones en vez de con los números asociados. Crea las siguientes excepciones: *ex_claveDuplicada*, *ex_pista_atracc_no_existe*

Para saber el número de excepción que tienes que capturar, provoca el fallo y anota el número.

Si provocamos los errores podemos comprobar que:
- Error 1062: Clave primaria duplicada
- Error 1452: Error de clave foránea.

Como el procedimiento sólo va a tener una orden INSERT, no hace falta hacer que salga del mismo al producirse la excepción.

---

## Ejercicio 4: 
Crea un procedimiento de nombre `artistas_add` que añade un nuevo artista. Se debe comprobar si el nif exista. Esta comprobación se hará capturando la excepción correspondiente. En caso de error, se mandará en un parámetro de salida el valor -1. Si todo está correcto se mandará el valor 0.

Crea un nombre de excepción: `ex_artista_duplicado.`

Junto a los datos del artista se debe enviar el nombre de un animal (debe estar previamente dado de alta) que va a cuidar el artista.

Se debe llamar al método `animales_addArtista` (creado previamente) y capturar la posible excepción que lance dicho método empleando el SQLSTATE. Si el animal no existe debe de enviar en el parámetro de salida el valor -2.

Crea un nombre de excepción: `ex_animal_no_existe.`
Cualquier excepción que se produzca debe hacer que se salga del procedimiento.

Llama al método y comprueba el valor del parámetro de salida en cada caso.

---