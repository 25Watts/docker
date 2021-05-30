# DOCKER + DOCKER-COMPOSE 3.8

lista de docker y docker-compose configurados para trabajar trabajar de forma individual
## DOKER

### 1 - Instalar el paquete de requisitos previos
``
	sudo apt-get install  curl apt-transport-https ca-certificates software-properties-common
``

### 2 - Agrega los repositorios de Docker

``
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
``

``
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
``

``
	sudo apt update
``

``
	apt-cache policy docker-ce
``

### 3 - Instalar Docker
``
	sudo apt install docker-ce
``

### 4 - Comporbar el estado de Docker
``
	sudo systemctl status docker
``

### 5 - Crear el grupo de usuario Docker.
``
	sudo groupadd docker
``

### 6 - Agregue su usuario al grupo de Docker.
``
	sudo usermod -aG docker {user}
``

## DOCKER-COMPOSE

### 1 - Descargar la versión estable/actual de docker-compose
``
	sudo curl -L "https://github.com/docker/compose/releases/download/{ultima version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
``
#### Referencia de version 
	https://docs.docker.com/compose/install/

### 2 - Permisos
``
	sudo chmod +x /usr/local/bin/docker-compose
``

### 3 - Crear un symbolic link
``
	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
``

### 4 - Ver versión 
``
	docker-compose --version
``

### 5 - Ajustar Permisos
``
	sudo chmod 666 /var/run/docker.sock
``

## LISTA DE COMANDOS

### Manual de Ejecución
1. Posicionarse en la carpeta del docker a ejecutar
``
	cd /repo_dockers
``

| Commands  | Description  |
|---|---|
| docker-compose up -d  | Levantar servicios |
| docker-compose down  | Remover servicios  |
| docker-compose start o stop  | iniciar o detener los servicios  |
| docker-compose exec --user www-data {CONTAINER} bash  | Entrar al promt de un servicio. |
| docker ps  | para ver la lista de contenedores en ejecución.  |
| docker ps -a | para ver la lista de todos los contenedores.  |

### Lista de contenedores

| Nombre  | Description  |
|---|---|
| magento1  | dockerFile y docker-compose del contenedor magento1 |
| magento2  | dockerFile y docker-compose del contenedor magento2  |
| mailhog  | docker-compose del contenedor mailhog |
| mysql  | docker-compose del contenedor mysql  |
| redis  | docker-compose del contenedor redis |

### Comandos útiles

#### Backup DB
```docker exec mysql /usr/bin/mysqldump -u root --password=root DATABASE > backup.sql```

#### Restore DB
```cat backup.sql | docker exec -i mysql /usr/bin/mysql -u root --password=root DATABASE```

# docker-sync

En Mac para que la sincro funcione correctamente entre los archivos docker y locales es necesario
instalar docker-sync

http://docker-sync.io/

Elegir Unison como estrategia de sincronización
https://docker-sync.readthedocs.io/en/latest/advanced/sync-strategies.html

Crear un volumen externo para nuestro proyecto (uno por proyecto), agregando las siguientes líneas a nuestro docker-compose.yml
```sh
volumes:
  apache-sync:
    external: true
```

Y dentro de servicios, apache, volumes editar nuestro volumen de esta manera
```sh
services:
    apache:
        volumes:
            - apache-sync:/var/www/html:nocopy,delegated
```

Y luego sumar nuestro archivo de docker-sync.yml al proyecto

Primero iniciar docker-sync mediante ```docker-sync start```, luego iniciar el contenedor docker

## Configurar Xdebug 3.0.3 Linux

### 1 - Configurar un firewall con UFW
habilitar ufw 

``
	sudo ufw enable
``

Validar que este enable ufw 

``
	sudo ufw status
``

Añadir nueva regla de firewall

``
	sudo ufw allow in from {host.docker.internal}/16 to any port 9003 comment xdebug
``

remplazar el host.docker.internal por el host que se comunica docker, para ver ip ingresar 

``
	ip address
``
Buscar la ip de la red docker

### 2 - Ajustar la config de XDebug en el docker-compose

	environment:
    	XDEBUG_CONFIG: client_host={host.docker.internal} client_port=9003 remote_enable=1 profiler_enable=1

### 3 - Configurar el Vcode y XDebug

	"configurations": [
		{
			"name": "Listen for XDebug",
			"type": "php",
			"request": "launch",
			"port": 9003,
			"pathMappings": {
				"/var/www/html/": "${workspaceFolder}"
			},
			"ignore": [
				"**/vendor/**/*.php"
			],
			"xdebugSettings": {
				"max_children": 10000,
				"max_data": 10000,
				"show_hidden": 1
			}
		}
	]

[link-dockerhub]: https://hub.docker.com/repository/docker/25watts/php

## Configurar Xdebug 3.0.3 MacOs

### 1 - Configurar Host address alias

Download the plist into the correct location
```sh
$ sudo curl -o \
        /Library/LaunchDaemons/org.devilbox.docker_10254_alias.plist \
        https://raw.githubusercontent.com/devilbox/xdebug/master/osx/org.devilbox.docker_10254_alias.plist
```

Enable without reboot
```sh
$ sudo launchctl load /Library/LaunchDaemons/org.devilbox.docker_10254_alias.plist
```

De esta forma configuramos la IP 10.254.254.254 para que sea compartida.

### 2 - Configurar xdebug.client_host en xdebug.ini
Luego debemos ingresar al archivo xdebug.ini y configurar xdebug.client_host con el ip anterior

```sh
xdebug.client_host = 10.254.254.254
```

### 3 - agregar configuración a docker
1- Primero creamos una carpeta .docker/ en nuestro proyecto, en caso de que no exista
2- Creamos el archivo xdebug.ini y copiamos el contenido del archivo original de xdebug ubicado en el repo, y luego cambiamos O agregamos xdebug.client_host = 10.254.254.254
3- Finalmente en nuestro docker-compose.yml dentro del servicio de apache, en volumes vamos declar la siguiente línea para que cargue nuestro archivo en lugar del generado por defecto

```sh
...
services:
    apache:
    ...
        volumes: 
            - .docker/config/xdebug.ini:/usr/local/etc/php/conf.d/xdebug.ini
```