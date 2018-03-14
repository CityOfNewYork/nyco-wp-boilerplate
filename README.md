

# Images
- nginx:alpine
- wordpress:php5.6-fpm

This image will install the latest version of WordPress to be served by nginx.


# Use
If you are controlling the versioning of WordPress, place your WordPress core
in the `wp` directory. Otherwise you can drop in only the core files needed for
your site to run. The Docker image will pull the latest version of WordPress
and mount any files you do not include.

Place your development database `.sql` file in the `./data` directory. There's
no need to rename it as the mysql image will look for any `.sql` file and
execute it when the image is built.

Generate your [Salts](https://api.wordpress.org/secret-key/1.1/salt/) and place
them in the `wp-config.php` file. Move the configuration file to the WordPress
directory (by default `./wp`).

If you are working behind a proxy, uncomment lines in the main `Dockerfile` and
enter it in the appropriate areas.

Run `docker-compose build` to build your images then `docker-compose up` to
start them. You can use `docker-compose up -d` to run in detatched mode.

After a few moments, you will be able to open up `localhost:8080` to visit your
site.


# Configuration
`.env` The configuration for `docker-compose.yml`.

`wp.cfg`
* `WP` The directory of the WordPress site.
* `THEME` The path to the main working theme.

`deploy.cfg` Slack message settings for the `bin/deploy.sh`.

If you install WordPress in a directory other than `./wp` you will need to change
the configuration in `.env` and `wp.cfg`.


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

To automate the set up of your local configuration, such as replace urls in
the database or update settings, add WP CLI commands to the `bin/config.sh`
and run them in the new container's shell:

```
docker-compose run wordpress /bin/bash
bin/config.sh
```

# Composer
This boilerplate comes with a composer package that you may use to get your
site started and includes the whoops error handler framework for PHP to start.
If your site already has Composer or you do not want the error handling framework,
delete the wp/composer.json file and remove the `$whoops` set up in the `wp-config.php`.

To use composer, install it on your machine and run `composer update` to install
the vendor package. You may also want to add `/vendor` to your WordPress `.gitignore` file.


# Database
You can look at the database with tools like
[Sequel Pro](https://www.sequelpro.com/). The connection host will be
`127.0.0.1` and the db username/password/name will be `wp` or whatever you set
in your configuration if you change the config file.


# Deployment
You can deploy to a WP Engine environment and alert the team by modifing the
configuration file `deploy.cfg` then running
`bin/deploy.sh -i <WP Engine remote origin> -b <branch> -m <optional message> -f <force push true or false(default)>`.

Be sure review [WP Engine's git push](https://wpengine.com/git/) protocol. You will
need to add your SSH Key to the User Portal. Also, always backup the instance before
you deploy.


# Todo
- [ ] SSL Configuration
- [ ] Automate Composer install
- [ ] Automate WP CLI Configuration runner
