# Lab 04:  DELETE en MongoDB

## Parte 1: deleteOne()

1. Eliminar un cliente por ID CL15.
2. Eliminar un cliente por email "old@example.com".
3. Eliminar un cliente con nombre "Raúl Castro" y sin puntos_fidelidad.
4. Eliminar un cliente que tenga "PayPal" como método de pago.
5. Eliminar un cliente que viva en "Madrid".
6. Eliminar un cliente con puntos_fidelidad igual a 500.
7. Eliminar un cliente con estatus "inactivo" y sin teléfono.
8. Eliminar un cliente con preferencias vacías.
9. Eliminar un cliente con nombre "William Suh" y ciudad "Guadalajara".
10. Eliminar un cliente que tenga definido el campo direccion.

## Parte 2: deleteMany()

1. Eliminar todos los clientes con estatus "inactivo".
2. Eliminar todos los clientes con puntos_fidelidad menor a 100.
3. Eliminar todos los clientes sin teléfono.
4. Eliminar todos los clientes que no tengan preferencias.
5. Eliminar todos los clientes que vivan en “Guadalajara” o “Querétaro”
6. Eliminar todos los clientes que no tengan historial_acceso.
7. Eliminar todos los clientes cuyo array preferencias.categorias_favoritas esté vacío.
8. Eliminar todos los clientes que vivan en "Querétaro" y tengan estatus "activo".
9. Eliminar todos los clientes que tengan campo direccion.ciudad igual a "Barcelona".
10. Eliminar todos los clientes de la colección (reset).

## Casos adicionales. Usando operadores lógicos

1. Eliminar un cliente que tenga más de una categoría favorita y estatus "activo".
2. Eliminar un cliente con puntos_fidelidad entre 200 y 500 y ciudad "Guadalajara".
3. Eliminar un cliente que tenga "tecnologia" o "hogar" en su array de categorías favoritas.
4. Eliminar un cliente que no tenga puntos_fidelidad o no tenga teléfono.
5. Eliminar un cliente con confirmación de escritura replicada en 2 nodos y estatus "activo".
6. Eliminar un cliente que tenga un método de pago tipo "tarjeta_credito" y número "3456".
7. Eliminar un cliente sin teléfono y sin historial_acceso.
8. Eliminar un cliente con puntos_fidelidad menor a 200 o mayor a 800.
9. Eliminar un cliente que viva en "Puebla" y tenga estatus "activo".
10. Eliminar un cliente que tenga definido el campo direccion y sin teléfono.


<details><summary>Show DELETE Solutions</summary>

```javascript
// Parte 1: deleteOne()

//1 Eliminar un cliente por ID CL15
db.clientes.deleteOne({ _id: "CL15" })

//2 Eliminar un cliente por email "old@example.com"
db.clientes.deleteOne({ email: "old@example.com" })

//3 Eliminar un cliente con nombre "Raúl Castro" y sin puntos_fidelidad
db.clientes.deleteOne({ nombre: "Raúl Castro", puntos_fidelidad: { $exists: false } })

//4 Eliminar un cliente que tenga "PayPal" como método de pago
db.clientes.deleteOne({ "metodos_pago.tipo": "PayPal" })

//5 Eliminar un cliente que viva en "Madrid"
db.clientes.deleteOne({ ciudad: "Madrid" })

//6 Eliminar un cliente con puntos_fidelidad igual a 500
db.clientes.deleteOne({ puntos_fidelidad: 500 })

//7 Eliminar un cliente con estatus "inactivo" y sin teléfono
db.clientes.deleteOne({ estatus: "inactivo", telefono: { $exists: false } })

//8 Eliminar un cliente con preferencias vacías
db.clientes.deleteOne({ "preferencias.categorias_favoritas": { $size: 0 } })

//9 Eliminar un cliente con nombre "William Suh" y ciudad "Guadalajara"
db.clientes.deleteOne({ nombre: "William Suh", ciudad: "Guadalajara" })

//10 Eliminar un cliente que tenga definido el campo direccion
db.clientes.deleteOne({ direccion: { $exists: true } })

//Parte 2: deleteMany()
//1 Eliminar todos los clientes con estatus "inactivo"
db.clientes.deleteMany({ estatus: "inactivo" })

//2 Eliminar todos los clientes con puntos_fidelidad menor a 100
db.clientes.deleteMany({ puntos_fidelidad: { $lt: 100 } })

//3 Eliminar todos los clientes sin teléfono
db.clientes.deleteMany({ telefono: null })

//4 Eliminar todos los clientes que no tengan preferencias
db.clientes.deleteMany({ preferencias: { $exists: false } })

//5 Eliminar todos los clientes que vivan en “Guadalajara” o “Querétaro”
db.clientes.deleteMany({ ciudad: { $in: ["Guadalajara", "Querétaro"] } })

//6 Eliminar todos los clientes que no tengan historial_acceso
db.clientes.deleteMany({ historial_acceso: { $exists: false } })

//7 Eliminar todos los clientes cuyo array preferencias.categorias_favoritas esté vacío
db.clientes.deleteMany({ "preferencias.categorias_favoritas": { $size: 0 } })

//8 Eliminar todos los clientes que vivan en "Querétaro" y tengan estatus "activo"
db.clientes.deleteMany({ ciudad: "Querétaro", estatus: "activo" })

//9 Eliminar todos los clientes que tengan campo direccion.ciudad igual a "Barcelona"
db.clientes.deleteMany({ "direccion.ciudad": "Barcelona" })

//10 Eliminar todos los clientes de la colección
db.clientes.deleteMany({})

//Casos adicionales – usando operadores lógicos
//1 Eliminar un cliente que tenga más de una categoría favorita y estatus "activo"
db.clientes.deleteOne({ 
  $and: [
    { "preferencias.categorias_favoritas.1": { $exists: true } },
    { estatus: "activo" }
  ]
})

//2 Eliminar un cliente con puntos_fidelidad entre 200 y 500 y ciudad "Guadalajara"
db.clientes.deleteOne({ 
  $and: [
    { puntos_fidelidad: { $gte: 200, $lte: 500 } },
    { ciudad: "Guadalajara" }
  ]
})

//3 Eliminar un cliente que tenga "tecnologia" o "hogar" en su array de categorías favoritas
db.clientes.deleteOne({ 
  $or: [
    { "preferencias.categorias_favoritas": "tecnologia" },
    { "preferencias.categorias_favoritas": "hogar" }
  ]
})

//4 Eliminar un cliente que no tenga puntos_fidelidad o no tenga teléfono
db.clientes.deleteOne({ 
  $or: [
    { puntos_fidelidad: { $exists: false } },
    { telefono: { $exists: false } }
  ]
})

//5 Eliminar un cliente con confirmación de escritura replicada en 2 nodos y estatus "activo"
db.clientes.deleteOne({ estatus: "activo" }, { writeConcern: { w: 2, wtimeout: 5000 } })

//6 Eliminar un cliente que tenga un método de pago tipo "tarjeta_credito" y número "3456"
db.clientes.deleteOne({ 
  $and: [
    { metodos_pago: { $elemMatch: { tipo: "tarjeta_credito", numero: "3456" } } }
  ]
})

//7 Eliminar un cliente sin teléfono y sin historial_acceso
db.clientes.deleteOne({ 
  $and: [
    { telefono: { $exists: false } },
    { historial_acceso: { $exists: false } }
  ]
})

//8 Eliminar un cliente con puntos_fidelidad menor a 200 o mayor a 800
db.clientes.deleteOne({ 
  $or: [
    { puntos_fidelidad: { $lt: 200 } },
    { puntos_fidelidad: { $gt: 800 } }
  ]
})

//9 Eliminar un cliente que viva en "Puebla" y tenga estatus "activo"
db.clientes.deleteOne({ 
  $and: [
    { ciudad: "Puebla" },
    { estatus: "activo" }
  ]
})

//10 Eliminar un cliente que tenga definido el campo direccion y sin teléfono
db.clientes.deleteOne({ 
  $and: [
    { direccion: { $exists: true } },
    { telefono: { $exists: false } }
  ]
})
```
</details>