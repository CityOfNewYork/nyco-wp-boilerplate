# NYCO WordPress Docker Boilerplate

This repo contains a Docker image will install the latest version of WordPress
to be served by nginx. It is the Boilerplate for running and maintaining all of
our WordPress products and contains scripts for deployment, syncing,
configuration, and notifications with all product environments hosted on WP
Engine.

## Docker Images

- nginx:alpine

- wordpress:php7.0-fpm

## Use

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

## Configuration

`.env` contains the configuration for `docker-compose.yml`.

`config/colors.cfg`
These are the colors used for Slack and other message highlighting. They currently
are set to match the NYC Opportunity brand.

`config/github.cfg`

- `GITHUB_URL` The url for the product repository.

`config/projects.cfg`
All of the product environment instance names should be added here.

`config/rollbar.cfg`
We use [Rollbar](https://rollbar.com) for error monitoring. The access token for
the products Rollbar account go here.

`config/slack.cfg`
Deployment and syncronisation scripts post to Slack to alert the team on various
tasks. Settings for Slack are managed here.

`config/wp.cfg`

- `WP` The directory of the WordPress site.

- `THEME` The path to the main working theme.

If you install WordPress in a directory other than `./wp` you will need to change
the configuration in `.env` and `wp.cfg`.

## NYCO WP Config

`config/config.yml`
This file is used in conjunction with the [NYCO WP Config](https://github.com/cityofnewyork/nyco-wp-config)
WordPress plugin for environment configuration. Environment variables can be
managed here and uploaded to each environment by running

```
bin/rsync-config.sh -i <WP Engine install>
```

## wp-cli

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

## Composer

This boilerplate comes with a composer package that you may use to get your
site started and includes the [Whoops error handler framework](https://github.com/filp/whoops)
for PHP to start. If your site already has Composer or you do not want the error
handling framework, delete the wp/composer.json file and remove the `$whoops`
set up in the `wp-config.php`.

To use composer, install it on your machine and run `composer update` to install
the vendor package. You may also want to add `/vendor` to your WordPress `.gitignore`
file.

## Database

You can look at the database with tools like
[Sequel Pro](https://www.sequelpro.com/). The connection host will be
`127.0.0.1` and the db username/password/name will be `wp` or whatever you set
in your configuration if you change the config file.

## Deployment

You can deploy to a WP Engine environment and post a message to Slack by modifing
the configuration files then running

```
bin/deploy.sh -i <WP Engine install> -b <branch> -m <message(optional)>
```

## Todo

- [ ] SSL Configuration

- [ ] Rollbar Deployment notification

- [ ] Automate Composer install

# About NYCO

NYC Opportunity is the [New York City Mayor's Office for Economic Opportunity](http://nyc.gov/opportunity).
We are committed to sharing open source software that we use in our products.
Feel free to ask questions and share feedback. Follow @nycopportunity on [Github](https://github.com/orgs/CityOfNewYork/teams/nycopportunity),
[Twitter](https://twitter.com/nycopportunity), [Facebook](https://www.facebook.com/NYCOpportunity/),
and [Instagram](https://www.instagram.com/nycopportunity/).
