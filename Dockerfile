FROM wordpress:fpm

# Install system wide packages
# RUN apk add --no-cache curl bash

# Define Wordrpess root
ENV WP_ROOT /var/www/html

# Add our wp-config file with environment variables
COPY wp-config.php $WP_ROOT
RUN chown -R www-data:www-data $WP_ROOT && chmod 640 $WP_ROOT/wp-config.php

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp