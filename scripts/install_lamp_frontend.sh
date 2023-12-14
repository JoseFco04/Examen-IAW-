#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -ex

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes
#apt upgrade -y

#Instalamos el servidor web Apache
apt install apache2 -y

# Instalamos php con sus paquetes y extensiones
apt install php php-mysql libapache2-mod-php php-xml php-mbstring php-curl php-zip php-gd php-intl php-soap -y

# Copiamos el archivo conf de apache 
cp ../config/000-default.conf /etc/apache2/sites-available

#Reiniciamos el servicio de Apache
systemctl restart apache2

# Copiamos el archivo de php 
cp ../php/index.php /var/www/html

#Modificamos el propietario y el grupo del directorio /var/www/html
chown -R www-data:www-data /var/www/html