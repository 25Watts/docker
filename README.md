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

# Mutagen (disponible únicamente en Magento2 de momento)

En Mac para que la sincro funcione correctamente entre los archivos docker y locales es necesario
instalar mutagen
```sh
brew install mutagen-io/mutagen/mutagen
```

Y finalmente ejecutar el siguiente comando para iniciar la sincro
```sh
mutagen sync create -c mutagen.yml \
    --label="magento2" \
    ./ docker://www-data@magento2_apache_1/var/www/html
```

Luego de que se detiene el contenedor es necesario detener la sincro
```sh
mutagen sync terminate --label-selector "magento2"
```