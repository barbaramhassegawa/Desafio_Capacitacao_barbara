#!/bin/bash

# Atualiza o sistema
sudo apt-get update -y
sudo apt-get upgrade -y

# Instala o Docker
sudo apt-get install -y docker.io

# Inicia e habilita o Docker
sudo systemctl start docker
sudo systemctl enable docker

# Instala o Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/2.17.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Cria o arquivo docker-compose.yml
cat <<EOF > /home/${USER}/docker-compose.yml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: GAud4mZby8F3SD6P
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress_data:/var/www/html

  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: GAud4mZby8F3SD6P
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: GAud4mZby8F3SD6P
    volumes:
      - db_data:/var/lib/mysql

volumes:
  wordpress_data:
  db_data:
EOF

# Navega até o diretório do docker-compose e inicia os containers
cd /home/${USER}
sudo docker-compose up -d
