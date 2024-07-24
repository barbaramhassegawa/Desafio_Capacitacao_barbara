# Imagem oficial do WordPress
FROM wordpress:latest

<<<<<<< HEAD
# Atualizar o cache de imagem 
RUN apt-get update

# Instalação do pacote adicional vim

RUN apt-get install -y vim


# Porta necessária para o WordPress)
EXPOSE 80

# Mantenha o comando de entrada padrão da imagem do WordPress
=======
# Mantem o cache de imagem atualizado
RUN apt-get update

# Instale pacotes adicionais necessários
# Por exemplo, vamos instalar o vim
RUN apt-get install -y vim


# Porta necessária para o WordPress
EXPOSE 80

# Comando de entrada padrão da imagem do WordPress
>>>>>>> ea3aee6 (commit)
CMD ["apache2-foreground"]
