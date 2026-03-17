# Instalación y configuración de MongoDB y Compass en Window.

En este tutorial, aprenderá a instalar el software, ya realizar la primera configuración para la conexión con la instancia local de MongoDB, mediante el software MongoDB Compass. También verá cómo guardar esta conexión, para no tener que configurarla cada vez que la necesite.

## Instalación de MongoDB y MongoDB Compass

Para instalar MongoDB, descargue el ejecutable de la última versión desde la página oficial: [www.mongodb.com/es/products/self-managed/community-edition](https://www.mongodb.com/es/products/self-managed/community-edition).

Descargue la versión MongoDB Community Edition, cuyo instalador ya incluye, tal y como hemos comentado, MongoDB Compass.

![mongo](./assets/mongo01.png)

Tal y como muestra la figura anterior, se ha escogido para descargar la versión más reciente de MongoDB Community Server para Windows x64 ( 64 bits). Concretamente, el paquete de instalación es de tipo MSI .

Dependiendo del sistema operativo, deberá descargar un paquete de instalación u otro. Descargue el MongoDB Community Server y guárdelo en una ubicación de fácil acceso (por ejemplo, el escritorio).

Haciendo doble clic en el instalador descargado se inicia el asistente de configuración de la instalación. 


En primer término le aparecerá el cuadro de diálogo que puede ver en la figura anterior, en el que se le indica que ésta comenzará si hace clic en 'next'.

![mongo](./assets/mongo02.png)

Si hace clic en el botón 'Completa', se instalarán todas las funciones del programa. Si desea seleccionar qué funciones desea instalar y dónde se instalarán, seleccione el botón Personalizada. Sin embargo, esta opción sólo se recomienda para usuarios avanzados, y le recomendamos por tanto que elija la completa.

![mongo](./assets/mongo03.png)

Instalará MongoDB como servicio de red. La diferencia con instalarlo como usuario local o de dominio es que no requerirá que especifique un nombre de cuenta y una contraseña, ya que utilizará una cuenta de servicio integrada de Windows.

![mongo](./assets/mongo04.png)

Vigile, tal y como se muestra en la figura anterior, que esté marcada la casilla de selección “Instala MongoDB Compass”, y haga clic en el botón 'Siguiente'. Si así lo hace, el asistente de configuración también instalará MongoDB Compass con la versión Community.

![mongo](./assets/mongo05.png)

Haga clic en el botón Instalar ( Install ) para iniciar la instalación.

Una vez que la instalación haya terminado, haga clic en el botón 'Finalizar' para salir del asistente de configuración. Probablemente se le pedirá que reinicie su máquina, de forma que se puedan aplicar los cambios realizados durante la instalación del software.