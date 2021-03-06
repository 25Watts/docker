# DOCKER + DOCKER-COMPOSE 3.5

lista de docker y docker-compose configurados para trabajar trabajar de forma individual

### Manual de ejecución
1. Posicionarse en la carpeta del docker a ejecutar

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