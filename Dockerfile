FROM wordpress:fpm

# # Define Wordrpess root
# ENV WP_ROOT /var/www/html

# # Add our wp-config file with environment variables
# COPY wp-config.php $WP_ROOT
# RUN chown -R www-data:www-data $WP_ROOT && chmod 640 $WP_ROOT/wp-config.php

# Install wp-cli
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY bin/wp.sh /bin/wp
RUN chmod +x /bin/wp
RUN chmod +x /bin/wp-cli.phar