#!/bin/bash

# Configuramos el script para que se muestren los comandos que se ejecutan 
set -ex

# Importamos el script de varuables de  entorno 
source .env

# Actualizamos los paquetes
apt update -y

# Instalamos Adminer 

# Creamos el directorio para adminer 
mkdir -p /var/www/html/adminer

# Instalamos la utilidad wget
apt install wget -y 

wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php -P /var/www/html/adminer

# Renombramos el nombre del archivo de Adminer 
mv /var/www/html/adminer/adminer-4.8.1-mysql.php /var/www/html/adminer/index.php

# Modificamos el propietario y el grupo del directorio /var/www/html
chown -R www-data:www-data /var/www/html



