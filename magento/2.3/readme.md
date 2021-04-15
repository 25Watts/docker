# Magento 2 con Docker

## Utilizar docker-sync para Mac

Docker aún inicia una máquina virtual y usa su propio sistema de archivos compartidos osxfs, el cual hace muy lenta la comunicación entre nuestro local y Docker.
Para mejorar esto vamos a utilizar docker-sync que genera una forma distinta de sincronizar y mejora la performance notablemente.

1. Instalar [https://docs.docker.com/docker-for-mac/]
2. Instalar [http://docker-sync.io/]
3. Luego utilizamos el archivo docker-compose.mac.yml (mismo que docker-compose.yml pero cambiando el volumen compartido) y docker-sync.yml con la configuración de éste.
4. Y para comenzar a trabajar nos situamos sobre el proyecto y ejecutamos ```docker-sync start```y luego iniciamos el contenedor mediante ```docker-compose -f docker-compose.mac.yml up -d```

Si todo salió bien, debería mejorar notablemente la performance!
