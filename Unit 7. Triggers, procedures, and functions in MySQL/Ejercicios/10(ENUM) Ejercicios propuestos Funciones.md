# **Ejercicios propuestos Funciones**
Haremos uso de la BD `Circo`.

### **Ejercicio 1:**
Crea una función de nombre `utilidades_getMesEnLetra` a la que se le pase un número y devuelva el nombre del mes. En caso de que el número no se corresponda con ningún mes, debe devolver null.

Fijarse que esta función es determinista.
Llama a la función directamente y guarda el resultado en una variable de sesión.
Llama a la función para que muestre los meses en letra en los que se celebró la atracción 'El gran felino'.
Llama a la función para que muestre las atracciones que se celebraron en ABRIL (busca por la cadena ABRIL) (recuerda hacer uso de COLLATE).
Nota: Indicar que Mysql ya dispone de dicha función, a la que se le pasa una fecha y devuelve el mes en forma de cadena: monthname()

### **Ejercicio 2:**
Crea una función de nombre `animales_getEstadoPorAnhos` que devuelva la cadena:

Si tipo = León
    - anhos < 2: 'JOVEN'
    - anhos >=2 y <=5: 'MADURO'
    - anhos > 5: 'VIEJO'
Cualquier otro tipo:
    - anhos < 1: 'JOVEN'
    - anhos >=1 y <=3: 'MADURO'
    - anhos > 3: 'VIEJO'

Llama a la función para mostrar el estado por años de cada uno de los animales del CIRCO.

## **Ejercicio 3:**
Crea una función de nombre `pistas_getDiferenciaAforo` al que se le pase el nuevo aforo de una pista y devuelva la diferencia entre el aforo nuevo y el aforo anterior.

- Si la diferencia < 100 debe devolver la cadena 'PEQUEÑA menor que 100'
- Si la diferencia está entre 100 y 500 debe devolver la cadena 'REGULAR entre 100 y 500'
- Si la diferencia > 500 debe devolver la cadena 'ABISMAL mayor que 500'. Por ejemplo: PISTA1, 150 => Si la pista tiene actualmente un aforo de 100, debe devolver 150-100 = 50 => PEQUEÑA menor que 100
- Si la pista no existe debe devolver null.

Acordaos de añadir los modificadores adecuados a la creación de la función.

Muestra los datos de todas las pistas junto la diferencia del aforo empleando la función anterior y enviando un aforo de 600.

Muestra las pistas que tengan una diferencia ABISMAL (busca la cadena con la función INSTR con un aforo propuesto de 1000.

### **Ejercicio 4:**
Crea una función de nombre ´pistas_getNumAtracciones´ que dada una pista devuelva el número de veces que se celebró una atracción en dicha pista.

Llama a dicha función por cada una de las pistas.

### **Ejercicio 5:**
Crea una función de nombre `atracciones_getListEntreFechas` que devuelva el número de atracciones que se celebraron entre dos fechas dadas.

Se debe comprobar que las fechas tienen el formato correcto y que primero se envía la fecha menor. En caso contrario debe devolver el valor -1.

### **Ejercicio 6:**
Crea una función de nombre `artistas_getNumAnimales` al que se le pase el nif de un artista y devuelva a cuantos animales cuida.

En caso de que no exista el artista debe devolver -1.
Llama a la función y haz que muestre a cuantos animales cuidan cada uno de los artistas.
Guarda en una variable de sesión a cuantos animales cuida el artista con nif 22222222B y muestra su valor.
Muestra los artistas que cuidan a 2 o más animales empleando la función.

### **Ejercicio 7:**
Crea una función de nombre `utilidades_getEstacionPorMes` que en función del mes que se le envíe como dato, devuelva la estación en la que se encuentre.

Llama a dicha función con el valor 7 y guarda el resultado en una variable de sesión. Muestra su valor.
Muestra las atracciones que empezaran en PRIMAVERA (tabla ATRACCIONES).
Muestra las ganancias por estación.
