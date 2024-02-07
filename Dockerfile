## php-fpm 8.2 nginx
FROM nginx:latest

# Install necessary packages and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip\
    gnupg2 \
    vim \
    lsb-release \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add PHP repository and install PHP (same as before)
RUN curl -fsSL https://packages.sury.org/php/apt.gpg | apt-key add - \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update && apt-get install -y \
    wget \
    libaio1 libaio-dev\
    php8.2 \
    php8.2-fpm \
    php8.2-zip \
    php8.2-gd \
    php8.2-xml \
    php8.2-mbstring \
    php8.2 php-pear \ 
    php8.2-cli \
    php8.2-common \ 
    php8.2-curl \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-xmlrpc \
    php8.2-dev \
    php8.2-gd \
    php8.2-intl \
    php8.2-gmagick \
    php8.2-yaml\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installation composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


## Install SSL certifiate
#RUN mkdir -p /etc/nginx/certs && \openssl genrsa -out /etc/nginx/certs/localhost.key 2048 && openssl req -new -x509 -key /etc/nginx/certs/localhost.key -out /etc/nginx/certs/localhost.crt -days 365 -subj '/CN=localhost'

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy PHP-FPM configuration
COPY .docker/nginx/php-fpm.conf /etc/php/8.2/fpm/php-fpm.conf
# Copy code source
COPY ./app /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Expose ports
EXPOSE 80 443

# Start PHP-FPM and Nginx
CMD service php8.2-fpm start && nginx -g 'daemon off;'
