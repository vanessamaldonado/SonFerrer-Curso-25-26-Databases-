# Ejercicios de MongoDB: Operaciones de Modificación sobre Ciudades

**Contexto:**

Partiendo de la colección de `ciudades`, que contiene documentos con el siguiente formato:

```json
{
    "name": "Nombre de la ciudad",
    "country": "Código de país (2 letras)",
    "timezone": "Zona horaria",
    "population": número ,
    "location": {
        "longitude": número ,
        "latitude": número
     }
}
```

## Ejercicio 1: Operaciones updateOne y updateMany

1. Añadir a “Buenos Aires” el campo capital al valor cierto.
2. Aumentar en 1000 la población de todas las ciudades de Argentina (AR)
3. Aumentar un 5 % la población de ciudades con más de 1,000,000 habitantes
4. Establecer que ninguna ciudad tenga menos de 1000 habitantes
5. Cambiar el campo name a nombre en toda la colección
6. Eliminar el campo timezone de las ciudades de Andorra (AD)
7. Actualizar ciudades con población entre 50,000 y 100,000 para añadir categoria, con el valor
"media".
8. Actualizar la ciudad de Mendoza para cambiar sus coordenadas a longitud -68.81667 y latitud
-32.88333.
9. Para ciudades que empiezan por `San`, añadir el campo `tiene_santo` al valor cierto.
10. Usar $currentDate para añadir un campo actualizado_en, con la fecha actual, a las ciudades
de España. NOTA: En caso de que no exista ninguna ciudad española, añadir alguna.

## Ejercicio 2: Operaciones con Arrays

**PREPARACIÓN**: Ejecuta esto primero:
```javascript
db.ciudades .updateMany(
 {country: "AR"},
 {$set: { atracciones : ["centro", "museo"]}}
 )
```

1. Añadir parque a atracciones de Córdoba, en Argentina
2. Añadir, con una sola llamada a la función correspondiente, los valores “teatro“ y “restaurante” a
atracciones de la ciudad de “Rosario”.
3. Añadir el valor 'centro` a atracciones de nombre `Mendoza` (solo si no existe).
4. Quitar museo de atracciones en todas las ciudades argentinas
5. Quitar centro y parque de atracciones de “Buenos Aires”, mediante una sola llamada a función
6. Añadir un campo codigos_postales con valor [5000] a “Córdoba”, de Argentina, y luego quitar
el primer elemento.


## Ejercicio 3: insert y delete

1. Añadir una ciudad que se llame “Barcelona” en Argentina, con una población de un millón y
medio de habitantes
2. Añadir 2 ciudades de un país ficticio “Inventado”
3. Eliminar la ciudad “Lab-Sar”
4. Eliminar todas las ciudades del país “Inventado”
5. Reemplazar completamente el documento de “Ushuaia” con otros valores
