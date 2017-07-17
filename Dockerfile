FROM wordpress:fpm

# Install requirements for wp-cli support
RUN apt-get update \
  && apt-get install -y sudo less mysql-client \
  && rm -rf /var/lib/apt/lists/*

# Install wp-cli
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY bin/wp.sh /bin/wp
RUN chmod +x /bin/wp
RUN chmod +x /bin/wp-cli.phar