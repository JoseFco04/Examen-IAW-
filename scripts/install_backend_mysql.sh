#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -ex

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes
#apt upgrade -y

# Importamos el archivo .env 
source .env

#Instalamos el gestor de bases de datos MySQL
apt install mysql-server -y

# Configuramos mysql para que solo acepte conexiones desde la Ip privada
sed -i "s/127.0.0.1/$MYSQL_PRIVATE_IP/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos el servicio de mysql
systemctl restart mysql

# Creamos la base de datos y el usuario de la base de datos 
mysql -u root <<< "DROP DATABASE IF EXISTS $MOODLE_DB_NAME"
mysql -u root <<< "CREATE DATABASE $MOODLE_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $MOODLE_DB_USER@'$IP_CLIENTE_MYSQL'"
mysql -u root <<< "CREATE USER $MOODLE_DB_USER@'$IP_CLIENTE_MYSQL' IDENTIFIED BY '$MOODLE_DB_PASS'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $MOODLE_DB_NAME.* TO $MOODLE_DB_USER@'$IP_CLIENTE_MYSQL'"
# Eliminamos si existe alguna base de datos previa de phpMyadmin
mysql -u root <<< "DROP DATABASE IF EXISTS $PMA_DB"
mysql -u root <<< "CREATE DATABASE $PMA_DB"
# Creamos el usuario para la base de datos y le asignamos privolegios 
mysql -u root <<< "DROP USER IF EXISTS $PMA_USER@'$IP_CLIENTE_MYSQL'"
mysql -u root <<< "CREATE USER $PMA_USER@'$IP_CLIENTE_MYSQL' IDENTIFIED BY '$PMA_PASS'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PMA_DB.* TO $PMA_USER@'$IP_CLIENTE_MYSQL'"

