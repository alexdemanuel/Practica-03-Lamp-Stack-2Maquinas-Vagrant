# Practica-03-Lamp-Stack-2Maquinas-Vagrant

# Creación de la máquina con vagrant

- Inicializamos vagrant que nos creara un archivo `Vagrantfile`.

```bash
 vagrant init
 ```

- Accedemos al archivo `Vagrantfile` y ponemos lo siguiente en su interior:

```bash
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
     
    # Apache HTTP Server
    config.vm.define "web" do |app|
      app.vm.hostname = "web"
      app.vm.network "private_network", ip: "192.168.33.10"
      app.vm.provision "shell", path: "provision-for-apache.sh"
    end
  
    # MySQL Server
    config.vm.define "db" do |app|
      app.vm.hostname = "db"
      app.vm.network "private_network", ip: "192.168.33.11"
      app.vm.provision "shell", path: "provision-for-mysql.sh"
    end

end
```

## Creación del archivo `provision-for-apache.sh` para hacer el *provision*

**Donde meteremos los comandos para instalar las utilidades que necesitemos para la maquina de apache**

- Actualizamos los repositorios.
```bash
apt-get update
```

- Instalacion Apache HTTP Server
```bash
apt-get install -y apache2
apt-get install -y php libapache2-mod-php php-mysql
sudo /etc/init.d/apache2 restart
```
- Clonamos repositorio de la apicacion web

```bash
apt-get install -y git
cd /tmp
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
```
- Movemos los archivos web del repositorio a la carpeta html para que la muestre al web y le cambiamos los permisos

```bash
cp /tmp/iaw-practica-lamp/src/. /var/www/html -R
```

- Modificamos el archivo config.php cambia la linea localhost por la ip que hemos especificado

```bash
sed -i 's/localhost/192.168.33.11/' /var/www/html/config.php 

chown www-data:www-data * -R
```

- Eliminamos el index.html para que nos muestre el index.php

```bash
rm /var/www/html/index.html 
```

## Creación del archivo `provision-for-mysql.sh` para hacer el *provision*

- Instalamos las utilidades 

```bash
apt-get update
apt-get install -y debconf-utils
```

- Seleccionamos la contraseña para root

```bash
DB_ROOT_PASSWD=123456
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"
```

- Instalamos el servidor de MYSQL

```bash
apt-get install -y mysql-server
```

 - Entra en el archivo de configuracion de MYSQL y reemplaza 127.0.0.1 por 0.0.0.0 para que todos se puedan conectar a esta base de datos

```bash
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
/etc/init.d/mysql restart
```

- Clonar repositorio de la apicacion web

```bash
apt-get install -y git
cd /tmp
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
```

- Ejecutar script de la base de datos

```bash
mysql -u root -p$DB_ROOT_PASSWD < /tmp/iaw-practica-lamp/db/database.sql 
```

**$DB_ROOT_PASSW es una variable que se utiliza para entrar a MySQL. La variable esta especificada arriba donde se indica cual sera la contraseña del usuario root**
