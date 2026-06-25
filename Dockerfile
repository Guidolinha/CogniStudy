FROM richarvey/nginx-php-fpm:php83

# Copia os arquivos do projeto para o servidor
COPY . /var/www/html

# Configurações de ambiente do container
ENV COOKIE_SECURE=false
ENV WEBROOT=/var/www/html/public
ENV COMPOSER_ALLOW_SUPERUSER=1

# Instala as dependências do Laravel lá dentro sem rodar scripts locais
RUN composer install --no-interaction --optimize-autoloader --no-dev --ignore-platform-reqs --no-scripts

# Ajusta as permissões de escrita das pastas do Laravel
RUN chown -R textalk:www-data /var/www/html/storage /var/www/html/bootstrap/cache
