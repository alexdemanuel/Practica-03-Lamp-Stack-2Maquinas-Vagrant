#!/bin/bash
apt-get update


#instalacion Apache HTTP Server
apt-get install -y apache2
apt-get install -y php libapache2-mod-php php-mysql
sudo /etc/init.d/apache2 restart

#Clonar repositorio de la apicacion web
apt-get install -y git
cd /tmp
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

#movemos los archivos web del repositorio a la carpeta html para que la muestre al web y le cambiamos los permisos
cp /tmp/iaw-practica-lamp/src/. /var/www/html -R

#modificamos el archivo config.php cambia la linea localhost por la ip que hemos especificado
#sed -i es para modificar el interior de archivos IMPORTANTE
sed -i 's/localhost/192.168.33.11/' /var/www/html/config.php 

chown www-data:www-data * -R

#Eliminamos el index.html para que nos muestre el index.php
rm /var/www/html/index.html 


