FROM php:8.3-cli-alpine

# Instala dependências do sistema obrigatórias
RUN apk add --no-cache \
    unzip \
    bzip2 \
    git \
    curl \
    libpq-dev \
    libxml2-dev \
    oniguruma-dev \
    $PHPIZE_DEPS

# Instala as extensões PHP fundamentais que o Laravel e o Symfony exigem
RUN docker-php-ext-install pdo pdo_mysql mbstring xml bcmath

# Instala o Composer globalmente dentro do container
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Define a pasta de trabalho antes de copiar os arquivos
WORKDIR /var/www/html

# Copia todos os arquivos do seu projeto para o container
COPY . /var/www/html

# Configurações de ambiente para o Composer rodar como root no container
ENV COMPOSER_ALLOW_SUPERUSER=1

# Limpa qualquer resquício de cache do composer antes de instalar
RUN composer clear-cache

# Instala as dependências puros sem rodar scripts que possam travar o build
RUN composer install --no-interaction --optimize-autoloader --no-dev --no-scripts

# Ajusta as permissões de escrita para o Alpine Linux nas pastas do Laravel
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

# Avisa o Render que o container vai usar a porta 10000
EXPOSE 10000

# Inicia o servidor embutido do PHP apontando para a pasta public do Laravel
CMD ["php", "-S", "0.0.0.0:10000", "-t", "public"]