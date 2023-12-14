#!/bin/bash

# Muestra todos los comandos que se van ejecutando
set -ex

# Actualizamos los repositorios
apt update

# Actualizamos los paquetes
#apt upgrade -y

# Importamos el archivo de variables .env
source .env

# Borramos las cosas previas al /var/www/html
rm -rf /var/www/html/* 

# Descargamos el codigo fuente de moodle
wget https://github.com/moodle/moodle/archive/refs/tags/v4.3.1.zip -P /var/www/html

# Instalar unzip
apt install unzip -y

# Descargar los archivos de dentro del zip descargado anteriormente
unzip /var/www/html/v4.3.1.zip -d /var/www/html/

# Mover al directorio raíz
mv /var/www/html/moodle-4.3.1/* /var/www/html

# Configuramos el parametro max_input_vars en 5000
sed -i "s/;max_input_vars = 1000/max_input_vars = $max_input_vars/" /etc/php/8.1/apache2/php.ini
sed -i "s/;max_input_vars = 1000/max_input_vars = $max_input_vars/" /etc/php/8.1/cli/php.ini

# Habilitamos el módulo d¡que permite reescribir Urls en Apache
a2enmod rewrite

# Reiniciamos el servicio de apache
systemctl restart apache2

# Copiamos el nuevo archivo .htaccess
cp ../htaccess/.htaccess /var/www/html

# Cambiamos la información de los directorios para que todos puedan escribir
chown -R www-data:www-data /var/www/html

# Eliminamos el directorio moodledata si existía
rm -rf /var/www/moodledata

# Creamos un directorio moodledata que no va a ser accesible a la web 
sudo mkdir /var/www/moodledata

# Le damos permisos de lectura y escitura 
chmod 077 /var/www/moodledata

# Instalamos moodle con cli
sudo -u www-data php /var/www/html/admin/cli/install.php \
    --lang=$MOODLE_LANG \
    --wwwroot=$MOODLE_WWWROOT \
    --dataroot=$MOODLE_DATAROOT \
    --dbtype=$MOODLE_DB_TYPE \
    --dbhost=$MOODLE_DB_HOST \
    --dbname=$MOODLE_DB_NAME \
    --dbuser=$MOODLE_DB_USER \
    --dbpass=$MOODLE_DB_PASS \
    --fullname=$MOODLE_FULLNAME \
    --shortname=$MOODLE_SHORTNAME \
    --summary=$MOODLE_SUMMARY \
    --adminuser=$MOOLE_ADMIN_USER \
    --adminpass=$MOODLE_ADMIN_PASS \
    --adminemail=$MOODLE_ADMIN_EMAIL \
    --non-interactive \
    --agree-license



# Reiniciamos el servicio de apache
systemctl restart apache2