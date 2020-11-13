# NYCO WordPress Boilerplate

At NYC Opportunity, we are utilizing Docker to help us more easily and consistently manage our products, specifically, [ACCESS NYC](https://github.com/CityOfNewYork/ACCESS-NYC), [Growing Up NYC](https://growingupnyc.cityofnewyork.us/), and more.

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
    * [Plugins](#plugins)
    * [Security Plugins](#security-plugins)
    * [Must Use Plugins](#must-use-plugins)
    * [Scripts](#scripts)
* [Database](#database)
* [Bin Scripts](#bin-scripts)
  * [Menu](#menu)
  * [Push](#push)
  * [Pull](#pull)
  * [SSH](#ssh)
  * [Rsync](#rsync)
  * [S3 Uploads](#s3-uploads)
  * [Config](#config)
  * [Versioning](#versioning)
  * [Publishing](#publishing)
  * [Sourcemaps](#sourcemaps)
  * [Dual Project Development](#dual-project-development)
* [Security](#security)

## Docker Images

- [nginx](https://hub.docker.com/_/nginx/) Alpine
- [WordPress](https://hub.docker.com/_/wordpress) PHP FPM Alpine
- [MySQL](https://hub.docker.com/_/mysql)

### Optional Images

- [redis](https://hub.docker.com/_/redis)
- [phpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)

## Usage

Below is simplified set of steps for getting started. Look at the [notes for special details](#notes).

**$1** Download a zip of this repository, or clone it to a new project directory.

    $ git clone https://github.com/CityOfNewYork/nyco-wp-boilerplate.git your-project-name && cd your-project-name

**$2** Run the `bin/boilerplate` command, select `[2] Update your Wordpress Project` then `[1] Yes` in the prompt to proceed. This will hide the `.git` directory but save it for updating later (see [Dual Project Development](#dual-project-development) for more details).

**$3** Move your files into the **[/wp](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/)** starter directory. *Optionally*, clone or place a WordPress site in the current directory (if doing this see the [**/wp directory** note](#notes) below).

**$4** *Optional* but important if you have a database dump to work with. Place any **.sql** file in the [**/data**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/data/) directory. See [notes below for details on seeding the database](#notes).

**$5** Run

    $ docker-compose build

to build your images. Then run

    $ docker-compose up

to start them. After a few moments, you will be able to open up `localhost:8080` to visit your site.

### Notes

* **Generate your [Salts](https://api.wordpress.org/secret-key/1.1/salt/)** then copy and paste them in their corresponding fields in the [wp-config.php](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/wp-config.php) file.

* **Mounting files**: The Docker image will pull the latest version of WordPress and mount any files to the WordPress container not included in the **[/wp](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/)** when running `docker-compose build` so you could have only the **/wp-content** directory in your project if you always want to work with the latest version of WordPress. The [**docker-compose.yml**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/docker-compose.yml) file includes commented out lines that will also achieve the same thing for mounting certain files to the WordPress container.

* **Bootstrapping**: In the [**/wp**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/) directory provided you'll find sample [**composer.json**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/composer.json), [**phpcs.xml**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/phpcs.xml), [**.gitignore**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/.gitignore), [**wp-config.php**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/wp-config.php) files to help bootstrap a new WordPress project. You may delete, replace, or modify any boilerplate files in the [**/wp**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/) directory to meet your project's needs.

* **/wp directory**: You can clone a WordPress site directly into the boilerplate root and delete the [**/wp**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/) directory. You will need to update the [**/config/bin.cfg**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/config/bin.cfg) `WP` setting and the instances of **./wp** in the [**docker-compose.yml**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/docker-compose.yml) file.

* **Database Seeding**: The name for the **.sql** dump does not matter as the mysql image will look for any **.sql** file in the [**/data**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/data/) directory and execute it on the database defined in the [**docker-compose.yml**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/docker-compose.yml) file. You will need to 'Find and Replace' the site url value in the **.sql** file to match your expected host (the default expected host is `http://localhost:8080`). This can be done manually before import in any text editing program or after using the [WP-CLI](#wp-cli). If there is no SQL file present when the image is created it will create an empty database which you can import data into using the [WP-CLI](#wp-cli), [Sequel Pro](https://www.sequelpro.com/), or *phpMyAdmin*.

* **Proxy**: If you are working behind a proxy, uncomment associated lines in the main [**wordpress-fpm/Dockerfile**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wordpress-fpm/Dockerfile) and enter your proxy in the appropriate areas.

* **WP Engine Sites**: If copying an existing WP Engine WordPress site from a backup point, it will have it's own **/wp-config.php** file and some "drop in" plugins in the **/wp-content** directory and "must use" **wp-content/must-use** directory included.

* **Composer**: If running `composer install` fails and you have a **composer.phar** file in your root directory, run `php composer.phar i`. If you do not have Composer installed, see [Get Composer](https://getcomposer.org/).

* **Optional Images**: To use optional images, uncomment them in the [**docker-compose.yml**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/docker-compose.yml) file.

* **Docker**: You can use the `-d` flag (`docker-compose up -d`) to run in detached mode.

* **Docker**: To create an interactive shell with the WordPress container, you can run `docker-compose exec wordpress sh`.

## Configuration

The [Bin Scripts](#bin-scripts) use a configuration file in [**/config/bin.cfg**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/config/config.cfg) for interacting with the local WordPress site and remote services.

Config Section  | Description
----------------|-
Colors          | These are the colors used for Slack and other message highlighting. They currently are set to match the NYC Opportunity brand.
Domain          | The production domain and CDN for the WP Engine installation go here.
WordPress       | WordPress directory configuration including the `WP` path, theme directory name, minified *.js* directory path, and matching pattern for minified *.js* files.
GitHub          | `GITHUB_URL` The url for the product repository.
Projects        | All of the product environment instance names should be added here.
Rollbar         | The access token for the product's [Rollbar](https://rollbar.com) account and your local Rollbar username go here.
Slack           | Deployment and synchronization scripts post to Slack to alert the team on various tasks. Settings for Slack are managed here.
S3&nbsp;Uploads | The name of an S3 bucket where uploads may be stored. Only needed if using a media offloader plugin such as [S3-Uploads](https://github.com/humanmade/S3-Uploads).

### NYCO WP Config

[**config/config.yml**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/config/config.yml) - This file is used in conjunction with the [NYCO WP Config](https://github.com/cityofnewyork/nyco-wp-config) WordPress plugin for environment configuration. [See that repository](https://github.com/cityofnewyork/nyco-wp-config) for details on integrating with WordPress. If a site uses that plugin it needs to be present in the **wp-content/mu-plugins/config/** directory.

## WP-CLI

WP-CLI is a command line interface for WordPress. It is set up to work with your WordPress installation through this Boilerplate. [Read more about WP-CLI at it's website](https://wp-cli.org/). To use WP-CLI commands, you need to run...

    $ docker-compose exec wordpress /bin/wp {{ command }}

... in place of `wp {{ command }}` to run one off commands on the container. Optionally, create an alias...

    alias dcwp="docker-compose exec wordpress /bin/wp"

... so you don't have to type out `docker-compose exec`. **Optionally**, shell into the container to run commands directly in the container.

    $ docker-compose exec wordpress sh

Then commands can be run using the normal CLI;

    $ wp {{ command }}

### Uses

There a lot of things you can do with the CLI such as import a database...

    $ wp db import database.sql

... replace strings in a the database...

    $ wp search-replace 'https://production.com' 'http://localhost:8080'

... and add a local administrative user:

    $ wp user create username username@domain.com --role=administrator --user_pass=wp

[Refer to the documentation for more commands](https://developer.wordpress.org/cli/commands/).

## Composer

This boilerplate comes with a composer package that you may use to manage php packages and plugins. To use composer, [install it](https://getcomposer.org/) on your machine and run...

    composer update

... to install the vendor package (or `php composer.phar i` depending on your setup). You may also want to add **/vendor** to your WordPress **.gitignore** file, if it hasn't been already.

### Developer Tools

The following packages are included for local development and plugin management.

Developer Packages                                                                | Description
----------------------------------------------------------------------------------|-
[Timber](https://www.upstatement.com/timber/)                                     | Integrates the Twig Template Engine and more for easier theme developmet.
[WPML Installer](https://github.com/Enelogic/wpml-installer)                      | Installer for WordPress Multilingual Plugin.
[ACF Pro Installer](https://github.com/philippbaschke/acf-pro-installer)          | Installer for Advanced Custom Fields Pro.
[Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer)                      | Code linting for PHP.
[WordPress Vunerability Check](https://github.com/umutphp/wp-vulnerability-check) | A command line tool to identify the security issues of WordPress plugins installed against the [WPScan Vunerability Database](https://wpvulndb.com/).
[Whoops](https://github.com/filp/whoops)                                          | Much nicer error log for PHP.
[Query Monitor](https://wordpress.org/plugins/query-monitor/)                     | WordPress Plugin. Creates a developer tools panel for WordPress Admins.
[Redis Cache](https://wordpress.org/plugins/redis-cache/)                         | WordPress Plugin. A persistent object cache powered by Redis. Using Object Caching is optional but it is recommended for site speed.
[WordPress Auto Login](https://wordpress.org/plugins/wp-auto-login/)              | WordPress Plugin. Creates a quick login link for local development (this is ignored by the site's .gitignore so it doesn't get added to a live environment).
[WP Crontrol](https://wordpress.org/plugins/wp-crontrol/)                         | WordPress Plugin. Lets you view and control what’s happening in the WP-Cron system.

### Plugins

The Composer Package includes the following plugins for enhancing WordPress functionality.

Plugin                                                                       | Description
-----------------------------------------------------------------------------|-
[Core&nbsp;Sitemaps](https://wordpress.org/plugins/core-sitemaps/)           | Proposed feature plugin for integrating basic sitemaps into WordPress Core. The boilerplate includes a MU Plugin file for configuration.
[Duplicate&nbsp;Post](https://wordpress.org/plugins/duplicate-post/)         | Enables the duplicating of posts
[WordPress&nbsp;Auto Updates](https://wordpress.org/plugins/wp-autoupdates/) | Proposed feature plugin for auto-updating plugins. Best used in a testing environment.

### Security Plugins

Additionally, the Composer Package includes the following plugins for enhancing WordPress security. These augment and complement some of the security measures provided by WordPress and WP Engine, however, using these plugins is by no means a comprehensive solution for securing WordPress websites.

Plugin                                                                                                  | Description
--------------------------------------------------------------------------------------------------------|-
[Aryo&nbsp;Activity Log](https://wordpress.org/plugins/aryo-activity-log/)                              | Tracks user activity in a dedicated log page.
[Google&nbsp;Authenticator](https://wordpress.org/plugins/google-authenticator/)                        | Enables 2-Factor Authentication for WordPress Users.
[Limit&nbsp;Login Attempts&nbsp;Reloaded](https://wordpress.org/plugins/limit-login-attempts-reloaded/) | Limits the number of login attempts a user can have if they use the wrong password or authenticator token.
[LoggedIn](https://wordpress.org/plugins/loggedin/)                                                     | Allows the setting for number of active logins a user can have.
[WP&nbsp;Security Questions](https://wordpress.org/plugins/wp-security-questions/)                      | Enables security question feature on registration, login, and forgot password screens.
[WPS&nbsp;Hide Login](https://wordpress.org/plugins/wps-hide-login/)                                    | Lets site adminstrators customize the url of the WordPress admin login screen.

Additionally, the Composer.json includes a package for checking plugins against the [WPScan Vunerability Database](https://wpvulndb.com/). Details in [Scripts](#scripts).

### Must Use Plugins

These Must Use plugins provide baseline support for some security concerns, plugin and site configuration. They can be customized for any installation.

Plugin                                                                                                                       | Description
-----------------------------------------------------------------------------------------------------------------------------|-
[Add&nbsp;Meta Description&nbsp;to&nbsp;Head](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/)        | Adds the description defined in the WordPress Admin settings to the description meta tag in the head for the homepage only.
[Automatically Update&nbsp;Options](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/)        | Disables pingback flag, pings, comments, closes comments for old posts, notifies if there are new comments, and disables user registration.
[Clean&nbsp;Up&nbsp;Head](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/)                       | Remove unecessary scripts, styles, and tags from the default WordPress head tag.
[Close&nbsp;Attachment Comments&nbsp;and&nbsp;Pings](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/) | Disable future comments and ping status (spam) for attachments as there is no way to close comments in admin settings. For previously uploaded attachments the wp cli can be used to close them (examples are included in the source of this plugin).
[Configure&nbsp;Core Sitemaps](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/)             | Configuration for the proposed WordPress core plugin for simple sitemaps. Filters out users, taxonomies, and other post types that do not have page views.
[Disable&nbsp;XML-RPC](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/)                     | [Disable XML-RPC methods](https://kinsta.com/blog/wordpress-xml-rpc/) that require authentication.
[Nonce&nbsp;Life](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/)                          | Changing the default [WordPress nonce lifetime](https://codex.wordpress.org/WordPress_Nonces#Modifying_the_nonce_system) from 1 day to 30 minutes.
[Disable&nbsp;User REST&nbsp;Endpoints](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/)              | Explicitly disables WordPress REST API endpoints related to users.
[Robots.txt](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/)                          | Modifies the default output of WordPress' robots.txt based on the Search Engine Visibility Settings (Settings > Reading).
[Timber](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/)                              | Instantiate and configure Timber
[Upload Mimes](https://github.com/cityofnewyork/nyco-wp-boilerplate/wp/wp-content/mu-plugins/)                        | Adds SVGs mime type to Media uploader to enable support for SVG files.

### Scripts

The Composer package comes with scripts that can be run via the command:

    composer run {{ script }}

Script        | Description
--------------|-
`development` | Rebuilds the autoloader including development dependencies.
`production`  | Rebuilds the autoloader omitting development dependencies.
`predeploy`   | Rebuilds the autoloader using the `development` script for the code checking tasks, runs [PHP Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer) using the `lint` script (described below), then runs [WordPress Vunerability Check](https://github.com/umutphp/wp-vulnerability-check) using the `wpscan` script (described below), then rebuilds the autoloader using the `production` script.
`lint`        | Runs PHP Code Sniffer which will display violations of the standard defined in the [phpcs.xml](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/phpcs.xml) file.
`fix`         | Runs PHP Code Sniffer in fix mode which will attempt to fix violations automatically. It is not necessarily recommended to run this on large scripts because if it fails it will leave a script partially formatted and malformed.
`wpscan`      | Runs WordPress Vunerability Check on the plugin directory. It will display information of vunerable plugins in the [WPScan Vunerability Database](https://wpvulndb.com/). This script requires a token to be set in the [WPScan config file](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/wpscan.yml). Tokens can be acquired by creating a [WPScan account](https://wpvulndb.com/users/sign_up). Since this file will contain a token, it should not be committed to your project's repository. Uncomment the line in the included [**.gitignore**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/.gitignore).
`version`     | Regenerates the **composer.lock** file and rebuilds the autoloader for production.
`deps`        | This is a shorthand for `composer show --tree` for illustrating package dependencies.

## Database

You can look at the database with tools like [Sequel Pro](https://www.sequelpro.com/). The connection host will be `127.0.0.1` and the db username/password/name will be `wp` or whatever you set in your configuration if you changed the config file.

## Bin Scripts

Script source can be found in the [**/bin**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/bin) directory. Be sure to fill out the [configuration](#configuration) file before using these scripts.

### Menu

With `bin/menu`, you will be given the option to do the following actions:

Action | Description
-------|-
Deploy | Deploy your local branch to a remote environment; calls [Push](#push)
Sync   | Sync your uploads to/from a remote; calls [Uploads](#uploads) or [Config](#config) based on selection
Update | Upgrade the entire Wordpress core to a specified version detailed in the root composer.json
Lint   | Runs PHP linting using the native syntax checker `php -l {{ file }}`.

To run the executable, at the root of the boilerplate, enter the following:

    $ bin/menu

Make your selections based on the values in the square brackets.

### Push

You can push a deployment to a remote WP Engine installation by running...

    $ bin/push {{ WP Engine install }} -m {{ Slack message (optional) }} -b {{ branch (optional) }} -f {{ true (optional) }}

If you have git push permissions set up and [configured](#configuration) with Slack and Rollbar correctly, this will post a message to the team that a deployment is being made and when it is complete, push to the appropriate WP Engine installation, and post a deployment to Rollbar for tracking. Adding the `-f` flag will perform a forced git push.

The `{{ WP Engine install }}` argument should be the same as the git remote repository for the WP Engine installation. Use ...

    $ git remote add {{ WP Engine install }} git@git.wpengine.com:production/{{ WP Engine install }}.git

... when adding remotes. The Git Push service and adding remotes is also described in further detail in [WP Engine's Git Push tutorial](https://wpengine.com/git/).

### Pull

    $ bin/pull {{ WP Engine install }}

Pulls a remote instance **master** into the local branch.

### SSH

You use [WP Engine's SSH Gateway](https://wpengine.com/support/getting-started-ssh-gateway/) to remotely browse an installation's filesystem by running...

    $ bin/ssh {{ WP Engine install }}

### Rsync

You can `rsync` remote files from a WP Engine installation to your local and vise versa by running...

    $ bin/rsync {{ WP Engine install }} {{ file }} -d

The `-u` flag will sync local to remote (upload) and `-d` will sync remote to local (download).

### S3 Uploads

If using a plugin such as [S3-Uploads](https://github.com/humanmade/S3-Uploads) to offload your media library to a static S3 bucket, you can use the S3 Uploads command to sync uploads (up or down) to a specified bucket. The script assumes you are using a single bucket for all of your installations...

    $ bin/s3-uploads -d

The `s3-uploads` script uses the [AWS CLI](https://aws.amazon.com/cli/) which must be installed on your computer. Additionally, you may need to configure [authenticating with a session token](https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/) if your AWS account requires users to use MFA. There are several [scripts](https://medium.com/@bixlerm/aws-mfa-bash-script-f59e2b33093c ) to help with this.

### Config

You can rsync the local [**config/config.yml**](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/config/config.yml) to a remote environment's **wp-content/mu-plugins/config** directory by running...

    $ bin/config {{ WP Engine install }}

### Versioning

You can version the repository with the latest release number. This will update the root [composer.json](https://github.com/CityOfNewYork/nyco-wp-boilerplate/blob/master/wp/composer.json) then run the `version` Composer script, which is set by default to regenerate the **composer.lock** file and regenerate the autoloader for production.

It will also update the theme's **style.css**, the theme's **package.json**, and regenerate **package-lock.json** file. Then, it will run an NPM Script named "version" that should be defined in the theme's **package.json** file. This script can run any any process that requires an update to the front-end styles or scripts dependent on the version of the **package.json**.

Finally, it will commit the file changes and tag the repository.

    $ bin/version {{ semantic version number }}

### Publishing

Publishing will push committed changes or publish the current branch to the origin repository as well as publish all local tags that do not exist on origin. This can be used to publish newly created versions after the [versioning script](#versioning).

    $ bin/publish

### Sourcemaps

We use [Rollbar](https://rollbar.com) for error monitoring. After every new script is deployed we need to supply new sourcemaps to Rollbar. This script will read all of the files in the theme's **assets/js** folder and will attempt to upload sourcemaps for all files with the extension **.js**. The script files need to match the pattern **{{ script }}.{{ hash }}.js**, ex; **main.485af636.js**. It will assume there is a sourcemap with the same name and extension **.map**, ex; **main.485af636.js.map**. The theme and paths to minified scripts can be modified in the [configuration](#configuration).

    $ bin/sourcemaps {{ WP Engine install }}

If the WP Engine install is using the CDN feature, that will need to be set in the [configuration](#configuration), ex; `CDN_{{ WP ENGINE INSTALL }}` or `CDN_ACCESSNYC`. If there is no CDN, it will assume that the script is hosted on the default instance on WP Engine; `https://{{ WP Engine install }}.wpengine.com` or `https://accessnycstage.wpengine.com`.

### Dual Project Development

With `bin/boilerplate`, you are able to switch between development on your WordPress site or this boilerplate project. This will allow you to fetch the latest changes to the boilerplate or contribute! To run this executable, enter the following at the root of this project:

    $ bin/boilerplate

Based on your selection, the git tracking for the project that you were not working on will be placed in the `temp/bp/` for the boilerplate or `temp/wp/` for WordPress.

# Security

Refer to this [free security whitepaper](https://wordpress.org/about/security/) from WordPress.org to become more familiar with the security components and best practices of the WordPress Core software. Additionally, the [Open Web Application Security Project](https://www.owasp.org/index.php/About_The_Open_Web_Application_Security_Project) (OWASP) provides [guidelines for implementing security for WordPress sites](https://www.owasp.org/index.php/OWASP_Wordpress_Security_Implementation_Guideline) that includes free and open source resources instead of commercial ones. Some of the practices mentioned are included in this boilerplate through [plugins](#security-plugins) and documentation while others should be implemented on a case by case basis.

---

![The Mayor's Office for Economic Opportunity](NYCMOEO_SecondaryBlue256px.png)

[The Mayor's Office for Economic Opportunity](http://nyc.gov/opportunity) (NYC Opportunity) is committed to sharing open source software that we use in our products. Feel free to ask questions and share feedback. **Interested in contributing?** See our open positions on [buildwithnyc.github.io](http://buildwithnyc.github.io/). Follow our team on [Github](https://github.com/orgs/CityOfNewYork/teams/nycopportunity) (if you are part of the [@cityofnewyork](https://github.com/CityOfNewYork/) organization) or [browse our work on Github](https://github.com/search?q=nycopportunity).
