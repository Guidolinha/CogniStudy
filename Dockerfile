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

# Instala as extensões PHP fundamentais
RUN docker-php-ext-install pdo pdo_mysql mbstring xml bcmath

# Instala o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Define a pasta de trabalho antes de copiar os arquivos
WORKDIR /var/www/html

# Copia os arquivos do projeto para o container
COPY . /var/www/html

# Configurações de ambiente do Composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# ATENÇÃO AQUI: Adicionamos o --no-scripts para o Laravel NÃO tentar rodar código antes da hora
RUN composer install --no-interaction --optimize-autoloader --no-dev --ignore-platform-reqs --no-scripts

# Ajusta permissões das pastas que o Laravel precisa escrever
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

# Porta que o Render vai escutar
EXPOSE 10000

# O comando de inicialização roda o servidor embutido do PHP
CMD ["php", "-S", "0.0.0.0:10000", "-t", "public"]