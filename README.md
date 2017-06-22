# Images
- nginx:alpine
- wordpress:fpm
- mysql:5.7

This image will install the latest version of Wordpress to be served by nginx.

# Use
Place your Wordpress site in the `wp` directory. Place your development database
`.sql` file in the `/data` directory. There's no need to rename it as the mysql
image will look for any `.sql` file and execute it when the image is built.

Generate your [Salts](https://api.wordpress.org/secret-key/1.1/salt/) and place
them in the `wp-config.php` file.

Run `docker-compose build` to build your images then `docker-compose up` to
start them. You can use `docker-compose up -d` to run in detatched mode.

After a few moments, you will be able to open up `localhost:8080` to visit your
site.

# Configuration
If you would like to configure the variables, you can do so in the
`docker-compose.yml` and the `wp-config.php` file. Be sure to make sure the
database configuration is the same in both.

# wp-cli
To use `wp-cli`, run `docker-compose exec wordpress /bin/wp` before your
command. Optionally, create an alias `alias docker-wp="docker-compose exec wordpress /bin/wp"`
so you don't have to type out the entire command.

You can use `wp-cli` to replace strings in the database...
```
docker-wp search-replace 'http://production.com' 'http://localhost:8080'
```

... and add an administrative user.
```
docker-wp user create username username@domain.com --role=administrator --send-email
```

# Database
You can look at the database with tools like
[Sequel Pro](https://www.sequelpro.com/). The connection host will be
`127.0.0.1` and the db username/password/name will be `wp` or whatever you set
in your configuration if you change the config file.

# Todo
- [ ] Configure `wp-config.php` to use `.env` variables
- [x] Set up `wp-cli` to manage users and plugins on initilization of the wordpress image
- [ ] SSL Configuration

