#!/bin/bash

# Configuramos el script para que se muestren los comandos que se ejecutan 
set -ex

# Importamos el script de varuables de  entorno 
source .env

# Actualizamos los paquetes
apt update -y

#Instalamos los modulos de php necesarios para phpMyAdmin.
sudo apt install php-mbstring php-zip php-json php-gd php-fpm php-xml -y

#Despues de la inctalacion es necesario reinicoar el servicio de apache
systemctl restart apache2

# Instalamos la utilidad wget
apt install wget -y 

#Eliminamos descargas previas de phpMyAdmin
rm -rf /tmp/phpMyAdmin-5.2.1-all-languages.zip

# Eliminamos instalaciones previad de phpMyAdmin
rm -rf /var/www/html/phpmyadmin

# Descargamos el codigo fuente de phpMyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip -P /tmp

#Instalamos la utilidad unzip 
apt install unzip -y

# Descomprimimos el codigo fuente de phpMyAdmin en /var/www/html
unzip -u /tmp/phpMyAdmin-5.2.1-all-languages.zip -d /var/www/html

# Renombramos el directorio de phpMyAdmin
mv /var/www/html/phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin

# Actualizamos los permisos del directorio /var/www/html
chown -R www-data:www-data /var/www/html

# Creamos un archivo de configuracion a partir del archivo e ejemplo
cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

# Generamos la variable blowfish_secret 
RANDOM_VALUE=`openssl rand -hex 16`

# Modificamos la variable blowfish_secret
sed -i "s/\(\$cfg\['blowfish_secret'\] =\).*/\1 '$RANDOM_VALUE';/" /var/www/html/phpmyadmin/config.inc.php

#creamos un directorio temporal para phpmyadmin
mkdir -p /var/www/html/phpmyadmin/tmp/

# Actualizamos los permisos del directorio /var/www/html
chown -R www-data:www-data /var/www/html


