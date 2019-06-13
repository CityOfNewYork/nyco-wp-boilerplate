# NYCO WordPress Docker Boilerplate

At NYC Opportunity, we are utilizing Docker to help us more easily and consistently manage our products, specifically, [ACCESS NYC](https://github.com/CityOfNewYork/ACCESS-NYC) and Growing Up NYC.

This repository contains a Docker image that will install the latest version of WordPress to be served by nginx. It is the Boilerplate for running and maintaining all of our WordPress products and contains scripts for deployment, syncing, configuration, and notifications with all product environments hosted on WP Engine.

## Contents

* [Docker Images](#docker-images)
* [Usage](#usage)
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

- NGinx Alpine
- WordPress PHP FPM Alpine
- MySQL

### Optional Images

- Redis
- PHP My Admin

## Usage

Download a zip of this repository, or clone it.

If you clone the repository, you will need to delete Git to prevent potential conflicts. In your root directory run `rm -rf .git` to remove Git. When you run `git status` you should now get an error message.

The **/wp** directory is where you place your project WordPress installation. The Docker image will pull the latest version of WordPress and mount any files you do not include. You can clone your project directly into the boilerplate root and swap out **/wp** with your project or rename your project to **/wp**, overwriting the **/wp** directory provided for you (see note).

**Note:** In the **/wp** directory provided for you you'll find the [composer.json](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/composer.json) and [wp-config.php](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/wp-config.php) files. Copy the [wp-config.php](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/wp-config.php) file into your project root. Delete the [composer.json](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/composer.json) file if you do not need it.

If you have a database dump to work with, place a *.sql* file in the **/data** directory. There's no need to rename it as the mysql image will look for any *.sql* file and execute it when the image is built. You will need to 'Find and Replace' the site url value in the **.sql** file to match your expected localhost.

Generate your [Salts](https://api.wordpress.org/secret-key/1.1/salt/), copy, and place them in their corresponding fields within the [wp-config.php](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/wp-config.php) file.

If you are working behind a proxy, uncomment associated lines in the main [wordpress-fpm/Dockerfile](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wordpress-fpm/Dockerfile) and enter your proxy in the appropriate areas.

If your site has Composer dependencies and they have not been installed or you are using the default Composer package that comes with this repository, cd into the **/wp** directory (or your project directory) and run...

    composer install

If running `composer install` fails and you have a **composer.phar** file in your root directory, run `php composer.phar i`. If you do not have Composer installed, see the Composer section below.

From the root directory, run

    docker-compose build

to build your images. Then run

    docker-compose up

to start them. You can use the *-d* flag (`docker-compose up -d`) to run in detached mode. After a few moments, you will be able to open up `localhost:8080` to visit your site. To create an interactive shell with the WordPress container, you can run...

    docker-compose exec wordpress sh

## Configuration

The [Bin Scripts](#bin-scripts) use a configuration file in [**/config/bin.cfg**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/config/config.cfg) for interacting with the local WordPress site and remote services.

Config Section    | Description
------------------|-
Colors            | These are the colors used for Slack and other message highlighting. They currently are set to match the NYC Opportunity brand.
Domain            | The production domain, CDN, and path for distributed *.js* files go here.
GitHub            | `GITHUB_URL` The url for the product repository.
Projects          | All of the product environment instance names should be added here.
Rollbar           | The access token for the product's Rollbar account and your local Rollbar username go here.
Slack             | Deployment and syncronisation scripts post to Slack to alert the team on various tasks. Settings for Slack are managed here.
WordPress         | Local WordPress directory configuration. `WP` The directory of the WordPress site. `THEME` The path to the main working theme.

### NYCO WP Config

[**config/config.yml**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/config/config.yml) - This file is used in conjunction with the [NYCO WP Config](https://github.com/cityofnewyork/nyco-wp-config) WordPress plugin for environment configuration. [See that repository](https://github.com/cityofnewyork/nyco-wp-config) for details on integrating with WordPress. If a site uses that plugin it needs to be present in the **wp-content/mu-plugins/config/** directory.

## WP-CLI

WP-CLI is a command line interface for WordPress. It is set up to work with your WordPress installation through this Boilerplate. [Read more about WP-CLI at it's website](https://wp-cli.org/). To use WP-CLI, you need to run...

    docker-compose exec wordpress /bin/wp

before your command. Optionally, create an alias...

    alias docker-wp="docker-compose exec wordpress /bin/wp"

... so you don't have to type out the entire command. There a lot of things you can do with the CLI such as replacing strings in a the WordPress database...

    docker-wp search-replace 'http://production.com' 'http://localhost:8080'

... or add an administrative user.

    docker-wp user create username username@domain.com --role=administrator --send-email

[Refer to the documentation for more commands](https://developer.wordpress.org/cli/commands/).

## Composer

This boilerplate comes with a composer package that you may use to get your site started. To use composer, install it on your machine and run...

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
[Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer)  | Code linting for PHP.

### Security Plugins

Additionally, the Composer Package includes the following plugins for enhancing WordPress security. These augment and complement some of the security measures provided by WordPress and WP Engine, however, using these plugins is by no means a comprehensive solution for securing WordPress websites.

Plugin                                                                                        | Description
----------------------------------------------------------------------------------------------|-
[Google Authenticator](https://wordpress.org/plugins/google-authenticator/)                   | Enables 2-Factor Authentication for WordPress Users.
[Limit Login Attempts Reloaded](https://wordpress.org/plugins/limit-login-attempts-reloaded/) | Limits the number of login attempts a user can have if they use the wrong password or authenticator token.
[WP Security Question](https://wordpress.org/plugins/wp-security-questions/)                  | Enables security question feature on registration, login, and forgot password screens.
[WPS Hide Login](https://wordpress.org/plugins/wps-hide-login/)                               | Lets site adminstrators customize the url of the WordPress admin login screen.

### Scripts

The Composer package comes with scripts that can be run via the command:

    composer run {{ script }}

Script        | Description
--------------|-
`development` | Rebuilds the autoloader including development dependencies.
`production`  | Rebuilds the autoloader omitting development dependencies.
`predeploy`   | Rebuilds the autoloader using the `production` script then runs [PHP Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer) using the `lint` script (described below).
`lint`        | Runs PHP Code Sniffer which will display violations of the standard defined in the [phpcs.xml](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/phpcs.xml) file.
`fix`         | Runs PHP Code Sniffer in fix mode which will attempt to fix violations automatically. It is not necessarily recommended to run this on large scripts because if it fails it will leave a script partially formatted and malformed.
`version`     | Regenerates the **composer.lock** file and rebuilds the autoloader for production.
`deps`        | This is a shorthand for `composer show --tree` for illustrating package dependencies.

## Database

You can look at the database with tools like [Sequel Pro](https://www.sequelpro.com/). The connection host will be `127.0.0.1` and the db username/password/name will be `wp` or whatever you set in your configuration if you changed the config file.

## Bin Scripts

Script source can be found in the [**/bin**](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/) directory. Be sure to fill out the [configuration](#configuration) file before using these scripts.

### Git Push

You can use WP Engine's Git Push deployment to a remote installation by running...

    bin/git-push.sh -i {{ WP Engine install }} -m {{ message (optional) }}

Adding the `-f` flag will perform a force push. You can [read more about WP Engine's Git Push](https://wpengine.com/git/). This will also post a tracked deployment to Rollbar. The `{{ WP Engine install }}` argument should be the same as the git remote repository. Adding remotes is also described in the [WP Engine's Git Push tutorial](https://wpengine.com/git/).

### SSH

You use [WP Engine's SSH Gateway](https://wpengine.com/support/getting-started-ssh-gateway/) to remotely browse an installation's filesystem by running...

    bin/s.sh {{ WP Engine Install }}

### Uploads

You can `rsync` remote **wp-content/uploads** from a WP Engine installation to your local and vise versa by running...

    bin/rsync-uploads.sh {{ WP Engine install }} -d

The `-u` flag will sync local to remote (upload) and `-d` will sync remote to local (download).

### Config

You can rsync the local [config/config.yml](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/config/config.yml) to a remote environment's **wp-content/mu-plugins/config** directory by running...

    bin/rsync-config.sh {{ WP Engine install }}

### Versioning

You can version the repository with the latest release number. This will update the root [composer.json](https://github.com/CityOfNewYork/nyco-wp-docker-boilerplate/blob/master/wp/composer.json) then run the `version` Composer script, which is set by default to regenerate the **composer.lock** file and regenerate the autoloader for production.

It will also update the theme's **style.css**, the theme's **package.json**, and regenerate **package-lock.json** file. Then, it will run an NPM Script named "version" that should be defined in the theme's **package.json** file. This script can run any any process that requires an update to the front-end styles or scripts dependent on the version of the **package.json**.

Finally, it will commit the file changes and tag the repository.

    bin/version.sh {{ Version Number }}

### Rollbar Sourcemaps

We use [Rollbar](https://rollbar.com) for error monitoring. After every new script is deployed we need to supply new sourcemaps to Rollbar. This script will read all of the files in the theme's **assets/js** folder and will attempt to upload sourcemaps for all files with the extension **.min.js**. The script files need to match the pattern **script.hash.min.js**, ex; **main.485af636.min.js**. It will assume there is a sourcemap with the same name and extension **.map**, ex; **main.485af636.min.js.map**. If the instance has a CDN, that will need to be set in the **domain.cfg**, ex; `CDN_INSTANCE` or `CDN_ACCESSNYC`. If there is no CDN, it will assume that the script is hosted on the default instance on WP Engine; `https://instance.wpengine.com` or `https://accessnycstage.wpengine.com`.

    bin/rollbar-sourcemaps.sh {{ WP Engine install }}

# About NYCO

NYC Opportunity is the [New York City Mayor's Office for Economic Opportunity](http://nyc.gov/opportunity). We are committed to sharing open source software that we use in our products. Feel free to ask questions and share feedback. Follow @nycopportunity on [Github](https://github.com/orgs/CityOfNewYork/teams/nycopportunity), [Twitter](https://twitter.com/nycopportunity), [Facebook](https://www.facebook.com/NYCOpportunity/), and [Instagram](https://www.instagram.com/nycopportunity/).
