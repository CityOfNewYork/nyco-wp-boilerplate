FROM wordpress:php7.4-fpm-alpine

# If you are working behind a proxy, uncomment the next block and replace {{ proxy }} with your proxy
# ENV PROXY {{ proxy }}
# ENV http_proxy $PROXY
# ENV https_proxy $PROXY

# Location of the WP CLI executable
ENV WP_CLI_PHAR https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Install requirements for wp-cli
RUN apk add --no-cache --update sudo mysql-client

# Install wp-cli and add executable permissions. If you are working behind a proxy, swap lines to curl using the proxy.
RUN curl -o /bin/wp-cli.phar $WP_CLI_PHAR
# RUN curl -x $PROXY -o /bin/wp-cli.phar $WP_CLI_PHAR

COPY bin/wp /bin/wp
RUN chmod +x /bin/wp
RUN chmod +x /bin/wp-cli.phar
