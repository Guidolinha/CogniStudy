FROM php:8.3-fpm-alpine

# Instala as extensões do PHP que o Laravel precisa e o Composer
RUN apk add --no-cache unzip bzip2 git curl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copia os arquivos do projeto para o servidor
COPY . /var/www/html

WORKDIR /var/www/html

# Configurações de ambiente do Composer e instalação das dependências
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-interaction --optimize-autoloader --no-dev --ignore-platform-reqs --no-scripts

# Ajusta as permissões de escrita fundamentais para o Laravel rodar
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Comando padrão para iniciar o PHP
CMD ["php", "-S", "0.0.0.0:10000", "-t", "public"]
