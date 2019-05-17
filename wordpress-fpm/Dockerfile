FROM wordpress:php7.2-fpm-alpine

# If you are working behind a proxy, uncomment and enter proxy here;
# ENV http_proxy <proxy here>
# ENV https_proxy <proxy here>

# Install requirements for wp-cli support
RUN apk add --no-cache --update \
  sudo \
  mysql-client

# Install wp-cli
# If you are working behind a proxy, uncomment 13, enter proxy, then comment out line 15;
# RUN curl -x <proxy here> -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY bin/wp.sh /bin/wp
RUN chmod +x /bin/wp
RUN chmod +x /bin/wp-cli.phar
