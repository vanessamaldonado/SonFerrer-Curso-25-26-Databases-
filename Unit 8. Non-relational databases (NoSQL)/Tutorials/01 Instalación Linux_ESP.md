# Instalación y configuración de MongoDB y Compass en Linux.

Esta guía detalla la instalación de MongoDB Community Edition (versión 8.0/8.2 funcional en repositorios actuales) y MongoDB Compass (versión gratuita) en Ubuntu.

## 1. Instalación de MongoDB Server (8.x) en Ubuntu

> MongoDB utiliza apt para la gestión de paquetes.

**Paso 1: Importar la clave pública GPG**

```bash
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor
```

**Paso 2: Crear la lista de repositorios**
Dependiendo de tu versión de Ubuntu (ej. 24.04 'noble' o 22.04 'jammy'), crea el archivo de lista:

```bash
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

> (Nota: Si usas Ubuntu 22.04, cambia noble por jammy).

**Paso 3: Actualizar e instalar**
Actualiza el índice de paquetes e instala los binarios de MongoDB:

```bash
sudo apt-get update
sudo apt-get install -y mongodb-org
```

**Paso 4: Iniciar MongoDB**

```bash
sudo systemctl start mongod
sudo systemctl enable mongod
```

**Paso 5: Verificar instalación**

```bash
mongosh --version
# Para comprobar el estado
sudo systemctl status mongod
```

## 2. Instalación de MongoDB Compass

MongoDB Compass es la GUI oficial gratuita.

**Paso 1: Descargar el paquete .deb**
Descarga la versión estable más reciente (ej. v44.x) para Linux desde https://www.mongodb.com/try/download/compass 

También puedes usar wget (verifica el enlace más reciente): 

```bash
wget https://downloads.mongodb.com
```

**Paso 2: Instalar Compass**
Instala el paquete descargado usando `dpkg`

```bash
sudo dpkg -i mongodb-compass_*.deb
# Si hay errores de dependencias, ejecuta:
sudo apt-get install -f
```

**Paso 3: Abrir Compass**
Puedes abrirlo desde el menú de aplicaciones o la terminal:

```bash
mongodb-compass
```