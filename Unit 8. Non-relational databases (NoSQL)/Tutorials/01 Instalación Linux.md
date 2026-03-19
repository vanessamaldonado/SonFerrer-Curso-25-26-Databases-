# Instalación y configuración de MongoDB y Compass en Linux.

Esta guía detalla la instalación de MongoDB Community Edition (versión 8.0/8.2 funcional en repositorios actuales) y MongoDB Compass (versión gratuita) en Ubuntu.

## Borrar configuraciones anteriores:
```bash
sudo rm -f /usr/share/keyrings/mongodb-*.gpg
sudo rm -f /etc/apt/sources.list.d/mongo-org-*.list
```

## 1. Instalación de MongoDB Server (8.x) en Ubuntu

> MongoDB utiliza apt para la gestión de paquetes.

**Paso 1: Importar la clave pública GPG**

```bash
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg
```

**Paso 2: Crear la lista de repositorios**
Dependiendo de tu versión de Ubuntu, crea el archivo de lista:

```bash
echo "deb [ arch=amd64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

**Paso 3: Actualizar e instalar**
Actualiza el índice de paquetes e instala los binarios de MongoDB:

```bash
sudo apt update
sudo apt install -y mongodb-org
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

```bash
wget https://downloads.mongodb.com/compass/mongodb-compass_1.49.4_amd64.deb
sudo apt install ./mongodb-compass_1.49.4_amd64.deb
```

**Paso 2: La instalación de Compass ya se completó (lo puedes verificar ejecutando):**

```bash
mongodb-compass
```
