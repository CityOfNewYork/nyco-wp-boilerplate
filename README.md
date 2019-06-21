# NYCO WordPress Docker Boilerplate

At NYC Opportunity, we are utilizing Docker to help us more easily and consistently manage our products, specifically, [ACCESS NYC](https://github.com/CityOfNewYork/ACCESS-NYC) and Growing Up NYC.

This repository contains a Docker image that will install the latest version of WordPress to be served by nginx. It is the Boilerplate for running and maintaining all of our WordPress products and contains scripts for deployment, syncing, configuration, and notifications with all product environments hosted on WP Engine.

## Contents

* [Docker Images](#docker-images)
* [Usage](#usage)
    * [Notes](#notes)
* [Configuration](#configuration)
    * [NYCO WP Config](#nyco-wp-config)
* [WP-CLI](#wp-cli)
* [Composer](#composer)
    * [Developer Tools](#developer-tools)
    * [Security Plugins](#security-plugins)
    * [Scripts](#scripts)
* [Database](#database)
* [Bin Scripts](#bin-scripts)
  * [Git Push](#git-push)
  * [SSH](#ssh)
  * [Uploads](#uploads)
  * [Config](#config)
  * [Versioning](#versioning)
  * [Rollbar Sourcemaps](#rollbar-sourcemaps)

## Docker Images

- [nginx](https://hub.docker.com/_/nginx/) Alpine
- [WordPress](https://hub.docker.com/_/wordpress) PHP FPM Alpine
- [MySQL](https://hub.docker.com/_/mysql)

### Optional Images

- [redis](https://hub.docker.com/_/redis)
- [phpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)

## Usage

Below is simplified set of steps for getting started. Look at the [notes for special details](#notes).

**$1** Download a zip of this repository, or clone it.

**$2** Place or clone any WordPress site in the **[/wp](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/)** directory.

**$3** *Optional*. If you have a database dump to work with, place any **.sql** file in the [**/data**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/data/) directory. See [notes below for details on seeding the database](#notes).

**$4** *Optional*. Generate your [Salts](https://api.wordpress.org/secret-key/1.1/salt/), copy, and paste them in their corresponding fields in the [wp-config.php](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/wp-config.php) file.

**$5** `cd` into the **[/wp](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/)** directory (or your project directory) and run...

    composer install

**$6** `cd` back into the root directory and run

    docker-compose build

to build your images. Then run

    docker-compose up

to start them. After a few moments, you will be able to open up `localhost:8080` to visit your site.

### Notes

* **Cloning**: If you clone this repository, you may want to delete Git to prevent potential conflicts. In your root directory run `rm -rf .git` to remove Git. When you run `git status` you should now get an error message.

* **Mounting files**: The Docker image will pull the latest version of WordPress and mount any files to the WordPress container not included in the **[/wp](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/)** when running `docker-compose build` so you could have only the **/wp-content** directory in your project if you always want to work with the latest version of WordPress. The [**docker-compose.yml**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/docker-compose.yml) file includes commented out lines that will also achieve the same thing for mounting certain files to the WordPress container.

* **Bootstrapping**: In the [**/wp**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/) directory provided you'll find sample [**composer.json**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/composer.json), [**phpcs.xml**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/phpcs.xml), [**.gitignore**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/.gitignore), [**wp-config.php**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/wp-config.php) files to help bootstrap a new WordPress project. You may delete, replace, or modify any boilerplate files in the [**/wp**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/) directory to meet your project's needs.

* **/wp directory**: You can clone a WordPress site directly into the boilerplate root and delete the [**/wp**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/) directory. You will need to update the [**/config/bin.cfg**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/config/bin.cfg) `WP` setting and the instances of **./wp** in the [**docker-compose.yml**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/docker-compose.yml) file.

* **Database Seeding**: The name for the **.sql** dump does not matter as the mysql image will look for any **.sql** file in the [**/data**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/data/) and execute it on the database defined in the [**docker-compose.yml**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/docker-compose.yml) file. You will may need to 'Find and Replace' the site url value in the **.sql** file to match your expected host (the default expected host is `http://localhost:8080`). This can be done manually before import in any text editing program or after using the [WP-CLI](#wp-cli). If there is no SQL file present when the image is created it will create an empty database which you can import data into using the [WP-CLI](#wp-cli), [Sequel Pro](https://www.sequelpro.com/), or *phpMyAdmin*.

* **Proxy**: If you are working behind a proxy, uncomment associated lines in the main [**wordpress-fpm/Dockerfile**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wordpress-fpm/Dockerfile) and enter your proxy in the appropriate areas.

* **WP Engine Sites**: If have copied an existing WP Engine WordPress site from a backup point, it will have it's own **/wp-config.php** file and some "drop in" plugins in the **/wp-content** directory and "must use" **wp-content/must-use** directory included.

* **Composer**: If running `composer install` fails and you have a **composer.phar** file in your root directory, run `php composer.phar i`. If you do not have Composer installed, see the [Get Composer](https://getcomposer.org/).

* **Optional Images**: To use optional images, uncomment them in the [**docker-compose.yml**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/docker-compose.yml) file.

* **Docker**: You can use the `-d` flag (`docker-compose up -d`) to run in detached mode.

* **Docker**: To create an interactive shell with the WordPress container, you can run `docker-compose exec wordpress sh`.

## Configuration

The [Bin Scripts](#bin-scripts) use a configuration file in [**/config/bin.cfg**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/config/config.cfg) for interacting with the local WordPress site and remote services.

Config Section    | Description
------------------|-
Colors            | These are the colors used for Slack and other message highlighting. They currently are set to match the NYC Opportunity brand.
Domain            | The production domain and CDN for the WP Engine installation go here.
WordPress         | WordPress directory configuration including the `WP` path, theme directory name, minified *.js* directory path, and matching pattern for minified *.js* files.
GitHub            | `GITHUB_URL` The url for the product repository.
Projects          | All of the product environment instance names should be added here.
Rollbar           | The access token for the product's [Rollbar](https://rollbar.com) account and your local Rollbar username go here.
Slack             | Deployment and synchronization scripts post to Slack to alert the team on various tasks. Settings for Slack are managed here.

### NYCO WP Config

[**config/config.yml**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/config/config.yml) - This file is used in conjunction with the [NYCO WP Config](https://github.com/cityofnewyork/nyco-wp-config) WordPress plugin for environment configuration. [See that repository](https://github.com/cityofnewyork/nyco-wp-config) for details on integrating with WordPress. If a site uses that plugin it needs to be present in the **wp-content/mu-plugins/config/** directory.

## WP-CLI

WP-CLI is a command line interface for WordPress. It is set up to work with your WordPress installation through this Boilerplate. [Read more about WP-CLI at it's website](https://wp-cli.org/). To use WP-CLI, you need to run...

    docker-compose exec wordpress /bin/wp

before your command. Optionally, create an alias...

    alias dcwp="docker-compose exec wordpress /bin/wp"

... so you don't have to type out the entire command. There a lot of things you can do with the CLI such as import a database...

    dcwp db import database.sql

.. replace strings in a the database...

    dcwp search-replace 'https://production.com' 'http://localhost:8080'

... and add a local administrative user:

    dcwp user create username username@domain.com --role=administrator --user_pass=wp

[Refer to the documentation for more commands](https://developer.wordpress.org/cli/commands/).

## Composer

This boilerplate comes with a composer package that you may use to manage php packages and plugins. To use composer, [install it](https://getcomposer.org/) on your machine and run...

    composer update

... to install the vendor package (or `php composer.phar i` depending on your setup). You may also want to add **/vendor** to your WordPress **.gitignore** file, if it hasn't been already.

### Developer Tools

The following packages are included for local development.

Developer Packages                                            | Description
--------------------------------------------------------------|-
[Whoops](https://github.com/filp/whoops)                      | Much nicer error log for PHP.
[WPS](https://github.com/Rarst/wps)                           | Whoops plugin for WordPress.
[Query Monitor](https://wordpress.org/plugins/query-monitor/) | A developer tools panel plugin for WordPress.
[Redis Cache](https://wordpress.org/plugins/redis-cache/)     | A persistent object cache backend plugin powered by Redis. Using Object Caching is optional but it is recommended for site speed.
[WP Crontrol](https://wordpress.org/plugins/wp-crontrol/)     | Lets you view and control what’s happening in the WP-Cron system.
[Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer)  | Code linting for PHP.

### Security Plugins

Additionally, the Composer Package includes the following plugins for enhancing WordPress security. These augment and complement some of the security measures provided by WordPress and WP Engine, however, using these plugins is by no means a comprehensive solution for securing WordPress websites.

Plugin                                                                                        | Description
----------------------------------------------------------------------------------------------|-
[Google Authenticator](https://wordpress.org/plugins/google-authenticator/)                   | Enables 2-Factor Authentication for WordPress Users.
[Limit Login Attempts Reloaded](https://wordpress.org/plugins/limit-login-attempts-reloaded/) | Limits the number of login attempts a user can have if they use the wrong password or authenticator token.
[WP Security Question](https://wordpress.org/plugins/wp-security-questions/)                  | Enables security question feature on registration, login, and forgot password screens.
[WPS Hide Login](https://wordpress.org/plugins/wps-hide-login/)                               | Lets site adminstrators customize the url of the WordPress admin login screen.

Additionally, the Composer.json includes a package for checking plugins against the [WPScan Vunerability Database](https://wpvulndb.com/). Details in [Scripts](#scripts).

### Scripts

The Composer package comes with scripts that can be run via the command:

    composer run {{ script }}

Script        | Description
--------------|-
`development` | Rebuilds the autoloader including development dependencies.
`production`  | Rebuilds the autoloader omitting development dependencies.
`predeploy`   | Rebuilds the autoloader using the `development` script for the code checking tasks, runs [PHP Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer) using the `lint` script (described below), then runs [WordPress Vunerability Check](https://github.com/umutphp/wp-vulnerability-check) using the `wpscan` script (described below), then rebuilds the autoloader using the `production` script.
`lint`        | Runs PHP Code Sniffer which will display violations of the standard defined in the [phpcs.xml](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/phpcs.xml) file.
`fix`         | Runs PHP Code Sniffer in fix mode which will attempt to fix violations automatically. It is not necessarily recommended to run this on large scripts because if it fails it will leave a script partially formatted and malformed.
`wpscan`      | Runs WordPress Vunerability Check on the plugin directory. It will display information of vunerable plugins in the [WPScan Vunerability Database](https://wpvulndb.com/). This script requires a token to be set in the [WPScan config file](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/wpscan.yml). Tokens can be acquired by creating a [WPScan account](https://wpvulndb.com/users/sign_up). Since this file will contain a token, it should not be committed to your project's repository. Uncomment the line in the included [**.gitignore**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/.gitignore).
`version`     | Regenerates the **composer.lock** file and rebuilds the autoloader for production.
`deps`        | This is a shorthand for `composer show --tree` for illustrating package dependencies.

## Database

You can look at the database with tools like [Sequel Pro](https://www.sequelpro.com/). The connection host will be `127.0.0.1` and the db username/password/name will be `wp` or whatever you set in your configuration if you changed the config file.

## Bin Scripts

Script source can be found in the [**/bin**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/bin) directory. Be sure to fill out the [configuration](#configuration) file before using these scripts.

### Git Push

You can use push a deployment to a remote WP Engine installation by running...

    bin/git-push.sh {{ WP Engine install }} -m {{ Slack message (optional) }} -b {{ branch (optional) }} -f {{ true (optional) }}

If you have git push permissions set up and [configured](#configuration) with Slack and Rollbar correctly, this will post a message to the team that a deployment is being made and when it is complete, push to the appropriate WP Engine installation, and post a deployment to Rollbar for tracking. Adding the `-f` flag will perform a forced git push.

The `{{ WP Engine install }}` argument should be the same as the git remote repository for the WP Engine installation. Use ...

    git remote add {{ WP Engine install }} git@git.wpengine.com:production/{{ WP Engine install }}.git

... when adding remotes. The Git Push service and adding remotes is also described in further detail in [WP Engine's Git Push tutorial](https://wpengine.com/git/).

### SSH

You use [WP Engine's SSH Gateway](https://wpengine.com/support/getting-started-ssh-gateway/) to remotely browse an installation's filesystem by running...

    bin/s.sh {{ WP Engine install }}

### Uploads

You can `rsync` remote **wp-content/uploads** from a WP Engine installation to your local and vise versa by running...

    bin/rsync-uploads.sh {{ WP Engine install }} -d

The `-u` flag will sync local to remote (upload) and `-d` will sync remote to local (download).

### Config

You can rsync the local [**config/config.yml**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/config/config.yml) to a remote environment's **wp-content/mu-plugins/config** directory by running...

    bin/rsync-config.sh {{ WP Engine install }}

### Versioning

You can version the repository with the latest release number. This will update the root [composer.json](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/composer.json) then run the `version` Composer script, which is set by default to regenerate the **composer.lock** file and regenerate the autoloader for production.

It will also update the theme's **style.css**, the theme's **package.json**, and regenerate **package-lock.json** file. Then, it will run an NPM Script named "version" that should be defined in the theme's **package.json** file. This script can run any any process that requires an update to the front-end styles or scripts dependent on the version of the **package.json**.

Finally, it will commit the file changes and tag the repository.

    bin/version.sh {{ semantic version number }}

### Rollbar Sourcemaps

We use [Rollbar](https://rollbar.com) for error monitoring. After every new script is deployed we need to supply new sourcemaps to Rollbar. This script will read all of the files in the theme's **assets/js** folder and will attempt to upload sourcemaps for all files with the extension **.js**. The script files need to match the pattern **{{ script }}.{{ hash }}.js**, ex; **main.485af636.js**. It will assume there is a sourcemap with the same name and extension **.map**, ex; **main.485af636.js.map**. The theme and paths to minified scripts can be modified in the [configuration](#configuration).

    bin/rollbar-sourcemaps.sh {{ WP Engine install }}

If the WP Engine install is using the CDN feature, that will need to be set in the [configuration](#configuration), ex; `CDN_{{ WP ENGINE INSTALL }}` or `CDN_ACCESSNYC`. If there is no CDN, it will assume that the script is hosted on the default instance on WP Engine; `https://{{ WP Engine install }}.wpengine.com` or `https://accessnycstage.wpengine.com`.

# About NYCO

NYC Opportunity is the [New York City Mayor's Office for Economic Opportunity](http://nyc.gov/opportunity). We are committed to sharing open source software that we use in our products. Feel free to ask questions and share feedback. Follow @nycopportunity on [Github](https://github.com/orgs/CityOfNewYork/teams/nycopportunity), [Twitter](https://twitter.com/nycopportunity), [Facebook](https://www.facebook.com/NYCOpportunity/), and [Instagram](https://www.instagram.com/nycopportunity/).
