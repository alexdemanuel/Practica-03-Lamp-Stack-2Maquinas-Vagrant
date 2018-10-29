#!/bin/bash
apt-get update
apt-get install -y debconf-utils

#seleccionamos la contraseña para root
DB_ROOT_PASSWD=123456
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"
#instalamos mysql
apt-get install -y mysql-server

# Esto entra la achivo mysqld.cnf y reemplaza 127.0.0.1 por 0.0.0.0 para que todos se puedan conectar a esta base de datos
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
/etc/init.d/mysql restart

#Clonar repositorio de la apicacion web
apt-get install -y git
cd /tmp
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

#Ejecutar script de la base de datos
mysql -u root -p$DB_ROOT_PASSWD < /tmp/iaw-practica-lamp/dbdatabase.sql 



