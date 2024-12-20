# Use PHP with Apache as the base image
FROM php:8.2-apache

# Install git
RUN apt-get update && apt-get install -y git unzip

# Install necessary dependencies for PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install zip gd

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set the Apache document root (optional, just to be explicit)
ENV APACHE_DOCUMENT_ROOT /var/www/html

# Ensure that Apache is configured to allow .htaccess (for mod_rewrite)
RUN echo '<Directory /var/www/html>' >> /etc/apache2/apache2.conf \
    && echo '    AllowOverride All' >> /etc/apache2/apache2.conf \
    && echo '</Directory>' >> /etc/apache2/apache2.conf

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*