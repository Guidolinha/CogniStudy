FROM php:8.3-cli-alpine

# Instala dependências do sistema e ferramentas para compilar extensões do PHP
RUN apk add --no-cache \
    unzip \
    bzip2 \
    git \
    curl \
    libpq-dev \
    libxml2-dev \
    oniguruma-dev \
    $PHPIZE_DEPS

# Instala as extensões PHP essenciais que o Laravel e o Symfony exigem para não dar erro de sintaxe
RUN docker-php-ext-install pdo pdo_mysql mbstring xml bcmath

# Instala o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copia os arquivos do seu projeto para dentro do container
COPY . /var/www/html

# Define a pasta de trabalho
WORKDIR /var/www/html

# Configurações de ambiente do Composer e instalação limpa das dependências
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-interaction --optimize-autoloader --no-dev --ignore-platform-reqs

# Ajusta as permissões para o Alpine Linux (no Alpine o usuário padrão é root, mas damos permissão geral)
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

# Avisa o Render que vamos usar a porta 10000
EXPOSE 10000

# Comando para iniciar o servidor embutido do Laravel focado na pasta public
CMD ["php", "-S", "0.0.0.0:10000", "-t", "public"]