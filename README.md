# NYCO WordPress Boilerplate

At NYC Opportunity, we are utilizing Docker to help us more easily and consistently manage our products, specifically, [ACCESS NYC](https://github.com/CityOfNewYork/ACCESS-NYC), [Growing Up NYC](https://github.com/CityOfNewYork/growingupnyc), [Working NYC](https://github.com/CityOfNewYork/working-nyc), and more.

This repository contains a Docker image that will install the latest version of WordPress to be served by nginx. It is the Boilerplate for running and maintaining all of our WordPress products and contains scripts for deployment, syncing, configuration, and notifications with all product environments hosted on WP Engine.

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

```shell
git clone https://github.com/CityOfNewYork/nyco-wp-boilerplate.git your-project-name && cd your-project-name
```

**$2** Run the `bin/boilerplate` command, select `[2] Update your Wordpress Project` then `[1] Yes` in the prompt to proceed. This will hide the `.git` directory but save it for updating later (see [Dual Project Development](#dual-project-development) for more details).

**$3** Move your files into the **[/wp](wp/)** starter directory. *Optionally*, clone or place a WordPress site in the current directory (if doing this see the [**/wp directory** note](#notes) below).

**$4** *Optional* but important if you have a database dump to work with. Place any **.sql** file in the [**/data**](data/) directory. See [notes below for details on seeding the database](#notes).

**$5** Run

```shell
docker-compose build
```

to build your images. Then run

```shell
docker-compose up
```

to start them. After a few moments, you will be able to open up `localhost:8080` to visit your site.

### Notes

* **Generate your [Salts](https://api.wordpress.org/secret-key/1.1/salt/)** then copy and paste them in their corresponding fields in the [wp-config.php](wp/wp-config.php) file.

* **Mounting files**: The Docker image will pull the latest version of WordPress and mount any files to the WordPress container not included in the **[/wp](wp/)** when running `docker-compose build` so you could have only the **/wp-content** directory in your project if you always want to work with the latest version of WordPress. The [**docker-compose.yml**](docker-compose.yml) file includes commented out lines that will also achieve the same thing for mounting certain files to the WordPress container.

* **Bootstrapping**: In the [**/wp**](wp/) directory provided you'll find sample [**composer.json**](wp/composer.json), [**phpcs.xml**](wp/phpcs.xml), [**.gitignore**](wp/.gitignore), [**wp-config.php**](wp/wp-config.php) files to help bootstrap a new WordPress project. You may delete, replace, or modify any boilerplate files in the [**/wp**](wp/) directory to meet your project's needs.

* **/wp directory**: You can clone a WordPress site directly into the boilerplate root and delete the [**/wp**](wp/) directory. You will need to update the [**/config/bin.cfg**](config/bin.cfg) `WP` setting and the instances of **./wp** in the [**docker-compose.yml**](docker-compose.yml) file.

* **Database Seeding**: The name for the **.sql** dump does not matter as the mysql image will look for any **.sql** file in the [**/data**](data/) directory and execute it on the database defined in the [**docker-compose.yml**](docker-compose.yml) file. You will need to 'Find and Replace' the site url value in the **.sql** file to match your expected host (the default expected host is `http://localhost:8080`). This can be done manually before import in any text editing program or after using the [WP-CLI](#wp-cli). If there is no SQL file present when the image is created it will create an empty database which you can import data into using the [WP-CLI](#wp-cli), [Sequel Pro](https://www.sequelpro.com/), or *phpMyAdmin*.

* **Database Reset**: To reset the database you can remove the service container `docker-compose rm mysql`, then, remove the volume `docker volume rm {{ volume name }}`. To look up the volume name use `docker volume ls`.

* **Proxy**: If you are working behind a proxy, uncomment associated lines in the main [**wordpress-fpm/Dockerfile**](wordpress-fpm/Dockerfile) and enter your proxy in the appropriate areas.

* **WP Engine Sites**: If copying an existing WP Engine WordPress site from a backup point, it will have it's own **/wp-config.php** file and some "drop in" plugins in the **/wp-content** directory and "must use" **wp-content/must-use** directory included.

* **Composer**: If running `composer install` fails and you have a **composer.phar** file in your root directory, run `php composer.phar i`. If you do not have Composer installed, see [Get Composer](https://getcomposer.org/).

* **Optional Images**: To use optional images, uncomment them in the [**docker-compose.yml**](docker-compose.yml) file.

* **Docker**: You can use the `-d` flag (`docker-compose up -d`) to run in detached mode.

* **Docker**: To create an interactive shell with the WordPress container, you can run `docker-compose exec wordpress sh`.

## Configuration

The [Bin Scripts](#bin-scripts) use a configuration file in [**/config/bin.cfg**](config/bin.cfg) for interacting with the local WordPress site and remote services.

Config&nbsp;Blocks | Description
-------------------|-
Colors             | These are the colors used for Slack and other message highlighting. They currently are set to match the NYC Opportunity brand. Used by the [push](#push) command.
Domain             | The production domain and CDN for the WP Engine installation go here. Used by the [sourcemaps](#sourcemaps) command.
WordPress          | WordPress directory configuration including the `WP` path, theme directory name, minified *.js* directory path, and matching pattern for minified *.js* files. Used by [sourcemaps](#sourcemaps) and other [commands](#commands).
GitHub             | `GITHUB_URL` The url for the product repository. Used by the [push](#push) command.
Projects           | All of the product environment remote names should be added here. Used by the [menu](#menu) command.
Rollbar            | The access token for the a [Rollbar](https://rollbar.com) account and local Rollbar username go here. Used by the [push](#push) and [sourcemaps](#sourcemaps) commands.
Slack              | Deployment and synchronization scripts post to Slack to alert the team on various tasks. Used by various [commands](#commands).
S3&nbsp;Uploads    | The name of an S3 bucket where uploads may be stored. Only needed if using the [uploads](#uploads) command.
WP Engine API      | Commands that use the [WP Engine API](https://wpengineapi.com/) require API credentials to be [generated in your user profile](https://my.wpengine.com/api_access) and set to the variables in this block.

### NYCO WP Config

[**config/config.yml**](config/config.yml) - This file is used in conjunction with the [NYCO WP Config](https://github.com/cityofnewyork/nyco-wp-config) WordPress plugin for environment configuration. [See that repository](https://github.com/cityofnewyork/nyco-wp-config) for details on integrating with WordPress. If a site uses that plugin it needs to be present in the **wp-content/mu-plugins/config/** directory.

## WP-CLI

WP-CLI is a command line interface for WordPress. It is set up to work with your WordPress installation through this Boilerplate. [Read more about WP-CLI at it's website](https://wp-cli.org/). To use WP-CLI commands, you need to run...

```shell
docker-compose exec wordpress /bin/wp {{ command }}
```

... in place of `wp {{ command }}` to run one off commands on the container. Optionally, create an alias...

```shell
alias dcwp="docker-compose exec wordpress /bin/wp"
```

... so you don't have to type out `docker-compose exec`. **Optionally**, shell into the container to run commands directly in the container.

```shell
docker-compose exec wordpress sh
```

Then commands can be run using the normal CLI;

```shell
wp {{ command }}
```

### Uses

There a lot of things you can do with the CLI such as import a database...

```shell
wp db import database.sql
```

... replace strings in a the database...

```shell
wp search-replace 'https://production.com' 'http://localhost:8080'
```

... and add a local administrative user:

```shell
wp user create username username@domain.com --role=administrator --user_pass=wp
```

[Refer to the documentation for more commands](https://developer.wordpress.org/cli/commands/).

## Composer

This boilerplate comes with a root composer package that you may use to manage php packages and plugins. To use composer, [install it](https://getcomposer.org/) on your machine and run...

```shell
composer update
```

... to install the vendor package (or `php composer.phar i` depending on your setup). You may also want to add **/vendor** to your WordPress **.gitignore** file, if it hasn't been already.

### Required Plugins and Packages

The root Composer package requires the following packages and plugins. Plugins for enhancing WordPress security are denoted by `*`. These enhance some of the security measures provided by WordPress and WP Engine, however, using plugins alone is not a comprehensive solution for securing WordPress websites. Refer to the [security section](#security) for more details.

Composer Packages                                                                                                   | Type                      | Description
--------------------------------------------------------------------------------------------------------------------|---------------------------|-
[Duplicate&nbsp;Post](https://wordpress.org/plugins/duplicate-post/)                                                | Plugin                    | Enables the duplication of posts and custom post types.
[NYCO WP Config](https://packagist.org/packages/nyco/wp-config)                                                     | Must&nbsp;Use&nbsp;Plugin | Determines php constants set on runtime based on specific environments. The plugin will pull from an object of variables set in the [mu-plugins/config/config.yml](wp/wp-content/mu-plugins/config/config.yml) file and set the appropriate group to constants that can be accessed by site functions, templates, and plugins. It will also autoload an environment-specific php file from the [mu-plugins/config/](wp/wp-content/mu-plugins/config/). <br><br> To pull in the appropriate settings, set the `WP_ENV` constant in the **wp-config.php** file of each environment. For example; `define('WP_ENV', 'development');` will load the default secrets at the root level of the **config.yml** file and the `development:` block as well as autoload the [**development.php**](wp/wp-content/mu-plugins/config/development.php) file. <br><br>Default constants are loaded in the root of the config.yml file and the [**default.php**](wp/wp-content/mu-plugins/config/default.php) configuration file is always loaded (the [Composer autoloader](https://getcomposer.org/doc/01-basic-usage.md#autoloading) is required here).
[NYCO WP Assets](https://packagist.org/packages/nyco/wp-assets)                                                     | Must&nbsp;Use&nbsp;Plugin | Provides helper functions for enqueuing JavaScript and stylesheet assets and integrations defined in the [mu-plugins/config/integrations.yml](wp/wp-content/mu-plugins/config/integrations.yml) file.
[S3&nbsp;Uploads](https://github.com/humanmade/S3-Uploads)                                                          | Plugin                    | A lightweight plugin for storing uploads on Amazon S3 instead of the local filesystem. Note, this requires an [AWS S3 bucket](https://aws.amazon.com/s3/).
[Timber](https://www.upstatement.com/timber/)                                                                       | Vendor                    | Integrates the Twig Template Engine and more for easier theme development.
*&nbsp;[Aryo&nbsp;Activity Log](https://wordpress.org/plugins/aryo-activity-log/)                                   | Plugin                    | * Tracks and displays user activity in a dedicated log page.
*&nbsp;[Google&nbsp;Authenticator](https://wordpress.org/plugins/google-authenticator/)                             | Plugin                    | * Enables 2-Factor Authentication for WordPress Users.
*&nbsp;[Limit&nbsp;Login&nbsp;Attempts&nbsp;Reloaded](https://wordpress.org/plugins/limit-login-attempts-reloaded/) | Plugin                    | * Limits the number of login attempts a user can have if they use the wrong password or authenticator token.
*&nbsp;[LoggedIn](https://wordpress.org/plugins/loggedin/)                                                          | Plugin                    | * Allows the setting for number of active logins a user can have.
*&nbsp;[WP&nbsp;Security&nbsp;Questions](https://wordpress.org/plugins/wp-security-questions/)                      | Plugin                    | * Enables security question feature on registration, login, and forgot password screens.
*&nbsp;[WPS&nbsp;Hide Login](https://wordpress.org/plugins/wps-hide-login/)                                         | Plugin                    | * Lets site administrators customize the url of the WordPress admin login screen.
*&nbsp;[WPScan](https://wordpress.org/plugins/wpscan/)                                                              | Plugin                    | * Identifies security issues of WordPress plugins installed against the [WPScan Vulnerability Database](https://wpvulndb.com/).
*&nbsp;[Defender](https://wordpress.org/plugins/defender-security)                                                  | Plugin                    | * Provides a selection of security measures such as hiding the default **/wp-login.php** path for logging into the cms, enabling two-factor authentication, setting security headers, and more. This plugin provides a good all-in-one solution and UI for modifying security features for site administrators, however, most of the features it provides can be hard-coded with plugins described above and [Must Use Plugins](#must-use-plugins).
**Require Dev**                                                                                                     |                           | The following packages are included for local development and purposes in the `require-dev` block.
[Code&nbsp;Sniffer](https://github.com/squizlabs/PHP_CodeSniffer)                                                   | Vendor                    | Code linting for PHP.
[Whoops](https://github.com/filp/whoops)                                                                            | Vendor                    | Much nicer error log for PHP.
[Query&nbsp;Monitor](https://wordpress.org/plugins/query-monitor/)                                                  | Plugin                    | Creates a developer tools panel for WordPress Admins.
[Redis&nbsp;Cache](https://wordpress.org/plugins/redis-cache/)                                                      | Plugin                    | A persistent object cache powered by Redis. Using Object Caching is optional but it is recommended for site speed.
[WordPress&nbsp;Auto&nbsp;Login](https://wordpress.org/plugins/wp-auto-login/)                                      | Plugin                    | Creates a quick login link for local development. **Important**, this is ignored by the site's **.gitignore** so it doesn't get added to a live environment.
[WP&nbsp;Crontrol](https://wordpress.org/plugins/wp-crontrol/)                                                      | Plugin                    | Lets you view and control what’s happening in the WP-Cron system.

### Using Composer

* [Installer Paths](#installer-paths)
* [/vendor and git](#vendor-and-git)
* [Autoloader](#autoloader)
* [Requiring Packages](#requiring-packages)
* [Updating packages](#updating-packages)
* [Composer scripts](#composer-scripts)

#### Installer Paths

Composer will install packages in one of three directory locations in the site depending on the type of package it is.

* **/vendor**; by default, Composer will install packages here. These may include helper libraries or SDKs used for php programming.

Packages have the [Composer Library Installer](https://github.com/composer/installers) included as a dependency are able to reroute their installation to directories alternative to the **./vendor** directory. This is to support different php based application frameworks. For WordPress, there are four possible directories ([see the Composer Library Installer documentation for details](https://github.com/composer/installers#current-supported-package-types)), however, for the purposes of this site most packages are installed the two following directories:

* **/wp-content/plugins**; packages that are WordPress plugins are installed in the WordPress plugin directory.
* **/wp-content/mu-plugins**; packages that are Must Use WordPress plugins are installed in the Must Use plugin directory.

#### /vendor and git

Normally, **/vendor** packages wouldn't be checked in to version control. They are installed on the server level in each environment. However, this site is deployed to WP Engine which does not support Composer so the packages need to be checked in and deployed to the site using git. By default **/vendor** packages are not tracked by the repository. If a composer package is required by production it needs to be included in the repository so it can be deployed to WP Engine. The [**.gitignore**](.gitignore) manually includes tracked repositories using the `!` prefix. This does not apply to WordPress plugins.

```
# Composer #
############
/vendor/*             # Exclude all /vendor packages
!/vendor/autoload.php # Include the autoloader
!/vendor/altorouter   # example package inclusion
...
```

#### Autoloader

The [autoloader](https://getcomposer.org/doc/01-basic-usage.md#autoloading) is what includes PHP package files in the application. It works by requiring package php files when the classnames they include are invoked. The autoloader needs to be required in every application before Composer packages can be run. The site loads requires the autoloader in [/wp-content/mu-plugins/config/default.php](wp-content/mu-plugins/config/default.php). This only applies to packages in the **/vendor** directory. WordPress Plugins and Must Use Plugins are not autoloaded.

```php
<?php

require_once ABSPATH . '/vendor/autoload.php';
```

##### Development build

Different types of autoloaders can be [generated](https://getcomposer.org/doc/03-cli.md#dump-autoload-dumpautoload-). The [**composer.json**](composer.json) includes scripts that will generate a "development" autoloader that requires packages defined in the `require` and `require-dev` json blocks (including [whoops](https://filp.github.io/whoops/)).

```shell
composer run development
```

##### Production build

The "production" autoloader will only require packages in the `require` json block. **Once you are done developing and before deployment generate the production autoloader which will remove development dependencies in the autoloader**.

```shell
composer run production
```

#### Requiring Packages

The command to install new packages is `composer require`. See the [Composer docs for more details on the CLI](https://getcomposer.org/doc/03-cli.md#require). Packages can be installed from [Packagist](https://packagist.org/) or [WordPress Packagist](https://wpackagist.org/). To require a package run:

```shell
composer require {{ vendor }}/{{ package }}:{{ version constraint }}
```

For example:

```shell
composer require timber/timber:^1.18
```

... will require the **Timber** package and install the latest minor version, greater than `1.18` and less than `2.0.0`. The caret designates the version range. Version constraints can be read about in more detail in the [Composer documentation](https://getcomposer.org/doc/articles/versions.md).

#### Updating Packages

The command to update packages is [`composer update`](https://getcomposer.org/doc/03-cli.md#update-u). Running it will install packages based on their version constraint in the [**composer.json**](composer.json) file. Individual packages can be updated by specifying the package name.

```shell
composer update {{ vendor }}/{{ package }}
```

For example:

```shell
composer update timber/timber
```

#### Composer scripts

The Composer package includes scripts that can be run via the command:

```shell
composer run {{ script }}
```

Script        | Description
--------------|-
`development` | Rebuilds the autoloader including development dependencies.
`production`  | Rebuilds the autoloader omitting development dependencies.
`predeploy`   | Rebuilds the autoloader using the `production` script then runs [PHP Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer) using the `lint` script (described below).
`lint`        | Runs PHP Code Sniffer which will display violations of the standard defined in the [phpcs.xml](wp/phpcs.xml) file.
`fix`         | Runs PHP Code Sniffer in fix mode which will attempt to fix violations automatically. It is not necessarily recommended to run this on large scripts because if it fails it will leave a script partially formatted and malformed.
`version`     | Regenerates the **composer.lock** file and rebuilds the autoloader for production.
`deps`        | This is a shorthand for `composer show --tree` for illustrating package dependencies.

## Git Hooks

This repository includes a [Git Hook directory](wp/.githooks/pre-push). To utilize git hooks they need to be configured in the repository by running the following command:

```shell
git config core.hooksPath .githooks
```

Below is a description of the available Git Hooks.

Hook       | Description
-----------|-
`pre-push` | Runs the Composer `predeploy` script. See [composer scripts](#composer-scripts).

## Dependabot

This repository includes a [GitHub Dependabot configuration](wp/.github/dependabot.yml) to watch production Composer and NPM dependencies for secure updates.

## Database

You can look at the database with tools like [Sequel Pro](https://www.sequelpro.com/). The connection host will be `127.0.0.1` and the db username/password/name will be `wp` or whatever you set in your configuration if you changed the config file.

## Bin Scripts

Script source can be found in the [**/bin**](bin) directory. Be sure to fill out the [configuration](#configuration) file before using these scripts.

```shell
bin/{{ script }} {{ args (if any) }}
```

### Bin Alias

Create an alias command for running a Boilerplate project bin script from any directory.

```shell
bp {{ script }} {{ args (if any) }}
```

Examples:

```shell
bp ssh {{ instance }}
```

or

```shell
bp backup {{ instance }}
```

To set it up.

1. Change "bp" in the [**bin/bp**](bin/bp) file to your project's shorthand (so it doesn't conflict with other projects). The alias name `bp`, the alias function reference `_bp`, and the function name `_bp`.
1. If you are using Z Shell (zsh) as your default terminal then uncomment the zsh compatible `BP_BIN` source export.
1. Run `. bin/bp` to add the alias and try it out.
1. Source `. ~/path/to/project/bin/bp` in your profile to have it added whenever your create a new terminal session.

Then you can use your alias for your project in place of `bin/` for each script below.

### Scripts

* [Boilerplate](#boilerplate) `boilerplate`
* [Menu](#menu) `menu`
* [Checklist](#checklist) `checklist`
* [Backup](#backup) `backup`
* [Push](#push) `push`
* [Pull](#pull) `pull`
* [Purge](#purge) `purge`
* [SSH](#ssh) `ssh`
* [rsync](#rsync) `rsync`
* [Uploads](#uploads) `uploads`
* [Config](#config) `config`
* [Version](#version) `version`
* [Publish](#publish) `publish`
* [Sourcemaps](#sourcemaps) `sourcemaps`

### Boilerplate

```shell
bin/boilerplate
```

Switch between development on your WordPress site or this boilerplate project. This will allow you to fetch the latest changes to the boilerplate or contribute! To run this executable, enter the following at the root of this project:

Based on your selection, the git tracking for the project that you were not working on will be placed in the `temp/bp/` for the boilerplate or `temp/wp/` for WordPress.

---

### Menu

```shell
bin/menu
```

With `bin/menu`, you will be given the option to do the following actions:

`#`   | Action | Description
------|--------|-
`[0]` | Deploy | Deploy your local branch to a remote environment; calls [`bin/push`](#push)
`[1]` | Sync   | Sync your uploads to/from a remote; calls [`bin/uploads`](#uploads) or [`bin/config`](#config) based on selection
`[2]` | Update | Upgrade the entire WordPress core to a specified version detailed in the root [**composer.json**](composer.json)
`[3]` | Lint   | Runs PHP linting using the native syntax checker `php -l {{ file }}`. The [**wp/composer.json**](wp/composer.json) also uses [PHP Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer) with a custom [XML](wp/phpcs.xml) specification. See [Composer scripts](#composer-scripts) for more details.

Make your selections based on the values in the square brackets.

---

### Checklist

```shell
bin/checklist
```

This will pull up a deployment checklist with sample commands to help guide developers through deployments. Accepts a semantic version number and installation name to pre-populate the sample commands with information about the deployment.

```shell
bin/checklist {{ version }} {{ installation }}
```

```shell
bin/checklist 1.0.0 installation
```

---

### Backup

```shell
bin/backup {{ remote }}
```

Use the [WP Engine API](https://wpengineapi.com/) to request a backup point for a remote WP Engine installation. The command accepts the installation name as the only argument.

```shell
bin/backup mysitetest
```

This command uses the [jq](https://stedolan.github.io/jq/) package to parse the response from the API. It can be installed via Homebrew using the command `brew install jq`. WP Engine API credentials must also be set in the config for this command to work.

---

### Push

```shell
bin/push {{ remote }} -b {{ branch (optional) }} -m {{ message (optional) }} -f {{ true (optional) }}
```

Push a local Git branch to a remote origin. Most instances of running the command will look like the following:

```shell
bin/push mysitetest
```

This will push changes from the `env/mysitetest` branch to the remote remote origin `mysitetest`. The `{{ remote }}` argument should be the same as the git remote repository for a WP Engine installation. Use ...

```shell
git remote add {{ remote }} git@git.wpengine.com:production/{{ remote }}.git
```

... when adding remotes before using the command. The WP Engine Git Push service and adding remotes is also described in further detail in [WP Engine's Git Push tutorial](https://wpengine.com/git/).

There are a few integrations that the command will trigger if they are [configured](#configuration).

* Post a message to a [Slack](#https://slack.com/) channel that a deployment is being made and when it is completed.
* Push a deployment for tracking in [Rollbar](https://rollbar.com).

Setting the `-f` flag to `true` will perform a forced git push.

---

### Pull

```shell
bin/pull {{ remote }}
```

Pulls a remote instance's **master** branch to the current local branch. It will use the `--no-rebase` merge strategy (creating a merge commit) and prefer changes from the remote instance.

---

### Purge

```shell
bin/purge {{ remote }}
```

Use the [WP Engine API](https://wpengineapi.com/) to purge the object cache of a remote WP Engine installation. The command accepts the installation name as the only argument.

```shell
bin/purge mysitetest
```

This command uses the [jq](https://stedolan.github.io/jq/) package to parse the response from the API. It can be installed via Homebrew using the command `brew install jq`. WP Engine API credentials must also be set in the config for this command to work.

---

### SSH

```shell
bin/ssh {{ remote }}
```

Use [WP Engine's SSH Gateway](https://wpengine.com/support/getting-started-ssh-gateway/) to remotely navigate an installation's filesystem.

---

### rsync

```shell
bin/rsync {{ remote }} {{ file }} {{ -u or -d }}
```

`rsync` remote files from a WP Engine installation to your local and vise versa. The `-u` flag will sync local to remote (upload) and `-d` will sync remote to local (download).

---

### S3 Uploads

```shell
bin/uploads {{ -u or -d }}
```

If using a plugin such as [S3-Uploads](https://github.com/humanmade/S3-Uploads) to offload your media library to a static S3 bucket, you can use the S3 Uploads command to sync uploads (up or down) to a specified bucket. The script assumes you are using a single bucket for all of your installations.

The `-u` flag will sync local to remote (upload) and `-d` will sync remote to local (download). The `uploads` script uses the [AWS CLI](https://aws.amazon.com/cli/) which must be installed on your computer. Additionally, you may need to configure [authenticating with a session token](https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/) if your AWS account requires users to use MFA. There are several [scripts](https://medium.com/@bixlerm/aws-mfa-bash-script-f59e2b33093c ) to help with this.

---

### Config

```shell
bin/config {{ remote }} {{ -u or -d }}
```

`rsync` the local [**config/config.yml**](config/config.yml) to a remote environment's **wp-content/mu-plugins/config** directory.

The `-u` flag will sync local to remote (upload) and `-d` will sync remote to local (download).

---

### Version

```shell
bin/version {{ semantic version number }}
```

Version the repository with the latest release number. This will update the root [composer.json](wp/composer.json) then run the `version` Composer script, which is set by default to regenerate the **composer.lock** file and regenerate the autoloader for production.

It will also update the theme's **style.css**, the theme's **package.json**, and regenerate **package-lock.json** file. Then, it will run an NPM Script named "version" that should be defined in the theme's **package.json** file. This script can run any any process that requires an update to the front-end styles or scripts dependent on the version of the **package.json**.

Finally, it will commit the file changes and tag the repository.

---

### Publish

```shell
bin/publish
```

Publishing will push committed changes or publish the current branch to the origin repository as well as publish all local tags that do not exist on origin. This can be used to publish newly created versions after the [versioning script](#versioning).

---

### Sourcemaps

```shell
bin/sourcemaps {{ remote }}
```

We use [Rollbar](https://rollbar.com) for error monitoring. After every new script is deployed we need to supply new sourcemaps to Rollbar to identify the source of errors. This script will read all of the files in the theme's **assets/js** folder and will attempt to upload sourcemaps for all files with the extension **.js**. The script files need to match the pattern **{{ script }}.{{ hash }}.js**, ex; **main.485af636.js**. It will assume there is a sourcemap with the same name and extension **.map**, ex; **main.485af636.js.map**. The theme and paths to minified scripts can be modified in the [configuration](#configuration).

If the WP Engine install is using the CDN feature, that will need to be set in the [configuration](#configuration), ex; `CDN_{{ REMOTE }}` or `CDN_ACCESSNYC`. If there is no CDN, it will assume that the script is hosted on the default instance on WP Engine; `https://{{ remote }}.wpengine.com` or `https://accessnycstage.wpengine.com`.

# WordPress Filesystem Guide

Below is a recommended filesystem for NYCO WordPress Boilerplate sites. Directory and file names that are not WordPress core files may vary per project.

* [Root](#root)
* [Must Use Plugins](#must-use-plugins)
* [Theme](#theme)

## Root

The root of the WordPress site is reserved for repository/core files, composer.json, and some site/developer configurations. It should not contain static assets such as favicons, xml sitemaps, or robots.txt files (of which can be configured by the theme and plugins).

* WordPress Core files
* WordPress Config
* Git and GitHub configuration
* Composer Root
* Composer Scripts configuration
* Readme, security, license and other policies

An important note about the **.htaccess** file which is not included here. This should only include the default rewrite module for permalinks. [WP Engine does not support the .htaccess file as of PHP 7.4](https://wpengine.com/support/htaccess-deprecation/). Custom redirects and hiding files must be done on the server level.

<div><pre>
├ 📁 .githooks         - Hooks to run when committing, pushing, etc. This directory needs to be configured in the repo configuration by running; git config core.hooksPath .githooks
  └ 📄 <a href='wp/.githooks/pre-push'>pre-push</a>          - Runs the Composer predeploy script before pushing to the remote repository.
├ 📁 .github           - GitHub configurations.
  └ 📄 <a href='wp/.github/dependabot.yml'>dependabot.yml</a>    - <a href="https://docs.github.com/en/free-pro-team@latest/github/administering-a-repository/keeping-your-dependencies-updated-automatically">Dependabot</a> configuration.
├ 📁 vendor            - Composer packages will be installed here.
├ 📁 wp-admin          - WordPress Core directory.
├ 📁 wp-content        - Must use plugins, themes, uploads, etc.
├ 📁 wp-includes       - WordPress Core directory.
├ 📄 <a href='wp/.gitignore'>.gitignore</a>        - Git file ignores and includes.
├ 📄 <a href='wp/composer.json'>composer.json</a>     - Root composer package containing required packages, plugins, and Composer scripts. See <a href="https://getcomposer.org/doc/04-schema.md">composer.json schema</a> docs and <a href="#composer">Composer</a> guide.
├ 📄 composer.lock     - Composer lock package that defines the required versions.
├ 📄 <a href='wp/phpcs.xml'>phpcs.xml</a>         - NYCO PHP Code Sniffer configuration. PSR2 with two spaces, braces on same line.
├ 📄 README.md         - Site readme file.
├ 📄 <a href='wp/SECURITY.md'>SECURITY.md</a>       - Site security policy.
├ 📄 LICENSE           - Site open source license.
├ 📄 <a href='wp/wp-config.php'>wp-config.php</a>     - Database, salts, debug settings. Note, this should not be checked into a project's repository. The 📄 wp-config.php file in the local project will differ from the one in a remote environment.
└ 📄 ...
</div></pre>

## Must Use Plugins

<div><pre>
- 📂 wp-content
  ├ 📂 mu-plugins
    ├ 📁 ...
    └ 📄 ...
  ├ 📁 ...
  └ 📄 ...
</div></pre>

[Must Use Plugins](https://codex.wordpress.org/Must_Use_Plugins) can be used to handle most of the custom configuration for the WordPress site including [registering custom post types](https://developer.wordpress.org/plugins/post-types/registering-custom-post-types), [registering WordPress REST API routes](https://developer.wordpress.org/rest-api/extending-the-rest-api/routes-and-endpoints/), configuring plugin settings, and other functionality for major features of the site. Most WordPress code bases tend to keep these in the [theme](#theme) which is better suited for styling the front-end and passing context to view templates.

* Custom Post Type Registration
* WordPress REST API Route Registration
* Constant Definition (using the [NYCO WordPress Config plugin](https://github.com/cityofnewyork/nyco-wp-config) or other). Note, some constants need to be defined in the root 📄 **wp-config.php** file.
* Integration Configuration such as Google Analytics, Tag Manager (event tracking), and Optimize (A/B testing). The [NYCO WordPress Assets plugin](https://github.com/cityofnewyork/nyco-wp-assets) can manage the configuration of integrations.
* Plugin Configuration
* Additional Logic and Custom Functionality

This repository includes some [Must Use Plugins](wp/wp-content/mu-plugins/) to provide support for security concerns (denoted by `*`) and plugin/site configuration. They can be customized for any installation.

Plugin                                                                                                              | Description
--------------------------------------------------------------------------------------------------------------------|-
[@config](wp/wp-content/mu-plugins/@config.php)                                                                     | Instantiates [NYCO WP Config](https://packagist.org/packages/nyco/wp-config). The `@` symbol in the file name ensures this plugin is instantiated before everything else as it contains constant settings that may be relevant to other plugins.
[Add&nbsp;meta&nbsp;description&nbsp;to&nbsp;head](wp/wp-content/mu-plugins/add-meta-description-to-head.php)       | Adds the description defined in the WordPress Admin settings to the description meta tag in the head for the homepage only.
[Clean&nbsp;up&nbsp;head](wp/wp-content/mu-plugins/clean-up-head.php)                                               | Remove unnecessary scripts, styles, and tags from the default WordPress head tag.
[Robots.txt](wp/wp-content/mu-plugins/robots-txt.php)                                                               | Modifies the default output of WordPress' robots.txt based on the WordPress Search Engine Visibility Settings (Settings > Reading).
[Timber](wp/wp-content/mu-plugins/timber.php)                                                                       | Instantiates [Timber](https://timber.github.io/docs/getting-started/setup/#via-github-for-developers) for a more pleasant theme development experience.
[Upload&nbsp;Mimes](wp/wp-content/mu-plugins/upload-mimes.php)                                                      | Adds the SVG mime type to enable support for SVG files in the media uploader.
[WP&nbsp;Assets](wp/wp-content/mu-plugins/wp-assets.php)                                                            | Instantiates [NYCO WP Assets](https://packagist.org/packages/nyco/wp-assets).
[WP&nbsp;Assets Integrations](wp/wp-content/mu-plugins/wp-assets-integrations.php)                                  | Add an Advanced Custom Fields option page for toggling NYCO WordPress Assets integrations.
*&nbsp;[Auto&nbsp;update&nbsp;options](wp/wp-content/mu-plugins/auto-update-options.php)                            | * Disables ping-back flag, pings, comments, closes comments for old posts, notifies if there are new comments, and disables user registration.
*&nbsp;[Close&nbsp;attachment comments&nbsp;and&nbsp;pings](wp/wp-content/mu-plugins/close-attachment-comments.php) | * Disable future comments and ping status (spam) for attachments as there is no way to close comments in admin settings. For previously uploaded attachments the wp cli can be used to close them (examples are included in the source of this plugin).
*&nbsp;[Configure&nbsp;core&nbsp;sitemaps](wp/wp-content/mu-plugins/core-sitemaps.php)                              | * Configuration for the [WordPress sitemaps feature](https://make.wordpress.org/core/2020/07/22/new-xml-sitemaps-functionality-in-wordpress-5-5/). Filters out users, taxonomies, and other post types that do not have page views. Note, prior to WordPress 5.5 this was not available to WordPress natively.
*&nbsp;[Disable&nbsp;XML-RPC](wp/wp-content/mu-plugins/disable-xmlrpc.php)                                          | * [Disable XML-RPC methods](https://kinsta.com/blog/wordpress-xml-rpc/) that require authentication.
*&nbsp;[Nonce&nbsp;Life](wp/wp-content/mu-plugins/nonce-life.php)                                                   | * Changing the default [WordPress nonce lifetime](https://codex.wordpress.org/WordPress_Nonces#Modifying_the_nonce_system) from 1 day to 30 minutes.
*&nbsp;[REST&nbsp;Endpoints](wp/wp-content/mu-plugins/rest-endpoints.php)                                           | * Explicitly disables [WordPress REST API user endpoints](https://developer.wordpress.org/rest-api/reference/users/).
*&nbsp;[WP&nbsp;Headers](wp/wp-content/mu-plugins/wp-headers.php)                                                   | * This plugin enables sending security headers to the client. The headers are configured by defining php [constants described below](#wp-header-constants).

### WP Header Constants

Configuration for the WP Headers Must Use Plugin included in this repository.

Constant                          | Type      | Default Value                           | Description
----------------------------------|-----------|-----------------------------------------|-
`WP_HEADERS_DNS_PREFETCH_CONTROL` | *string*  | `undefined`                             | Set to `'on'` for [`X-DNS-Prefetch-Control`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-DNS-Prefetch-Control).
`WP_HEADERS_SAMEORIGIN`           | *boolean* | `undefined`                             | `true` sets [`X-Frame-Options`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options) to `SAMEORIGIN`.
`WP_HEADERS_NOSNIFF`              | *boolean* | `undefined`                             | `true` sets [`X-Content-Type-Options`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options) to `nosniff`.
**CSP Header Policy Constants**   |           |                                         | [Content Security Policies](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP). Each of the constants below build up into the single custom content security policy.
`WP_HEADERS_CSP_DEFAULT`          | *string*  | `'self'`                                | [Default directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/default-src) for unspecified policies.
`WP_HEADERS_CSP_STYLE`            | *string*  | `'self'`                                | [Stylesheet source directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/style-src).
`WP_HEADERS_CSP_FONT`             | *string*  | `'self'`                                | [Font source directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/font-src).
`WP_HEADERS_CSP_IMG`              | *string*  | `'self'`                                | [Image source directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/img-src).
`WP_HEADERS_CSP_SCRIPT`           | *string*  | `'self' 'nonce-{{ CSP_SCRIPT_NONCE }}'` | [JavaScript source directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/script-src). A nonce will be created and a `script_loader_tag` filter will append the nonce to scripts that are registered and enqueued. The nonce will also be set to the constant `CSP_SCRIPT_NONCE` that can be added to permit inline `<script>` tags in templates.
`WP_HEADERS_CSP_CONNECT`          | *string*  | `'self'`                                | [JavaScript URL loading directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/connect-src).
`WP_HEADERS_CSP_FRAME`            | *string*  | `'none'`                                | [iFrame source directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-src).
`WP_HEADERS_CSP_OBJECT`           | *string*  | `'none'`                                | [Object, embed, and applet directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/object-src).
`WP_HEADERS_CSP_REPORTING`        | *string*  | `undefined`                             | Sets the [reporting directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/report-to) to an endpoint for debugging the policy and violations. Sets both the `report-to` and `report-uri` for compatibility. Note, the endpoint that processes the response needs to be created.
`WP_HEADERS_CSP_SEND`             | *boolean* | `undefined`                             | Setting `false` will prevent the CSP header policy from being sent.

## Theme

<div><pre>
- 📂 wp-content
  ├ 📂 themes
    └ 📂 theme
      ├ 📁 ...
      └ 📄 ...
  ├ 📁 ...
  └ 📄 ...
</div></pre>

The theme for the site contains all of the php functions, templates, styling, and scripts relevant the front-end templates. This is the only WordPress theme that is compatible with the WordPress site.

* View Controllers
* View Templates
* View Assets and Source
* Gutenberg Blocks
* Shortcodes
* Template functions and tags

<div><pre>
├ 📁 acf-json          - <a href="https://www.advancedcustomfields.com/resources/local-json/">Advanced Custom Fields JSON</a> files for syncing custom fields between environments.
├ 📁 assets            - The source for image, style, and script files live in the 📂 src directory and are compiled to the 📂 assets directory. This is done with NPM Scripts in 📄 package.json file and 📁 node_scripts directory.
├ 📁 blocks            - Custom <a href="https://developer.wordpress.org/block-editor/developers/">Gutenberg Block</a> source.
├ 📁 lib               - Theme functions, filters, and other helpers that assist in rendering views (includes).
├ 📁 node_modules      - Node modules will be installed here if using NPM to manage dependencies.
├ 📁 node_scripts      - Custom node scripts required to manage assets.
├ 📁 shortcodes        - Theme <a href="https://codex.wordpress.org/Shortcode">shortcodes</a> available to content administrators.
├ 📁 timber-posts      - Site and Post Type classes that <a href="https://timber.github.io/docs/guides/extending-timber/">extend Timber posts</a> and provide processed data to views.
  ├ 📄 Site.php        - Timber site class extension to add properties to <a href="https://timber.github.io/docs/reference/timber-site/">Timber/Site</a>.
  ├ 📄 Post.php        - Timber post class extension.
  └ 📄 ...
├ 📂 src               - Asset source.
  ├ 📁 scss              - Sass source, if required.
    ├ 📄 _main.scss        - Main Sass entry-point.
    ├ 📄 ar.scss           - Arabic font variable setting.
    ├ 📄 light.scss        - Light color mode variable setting.
    ├ 📄 dark.scss         - Dark color mode variable setting.
    ├ 📄 latin.scss        - Latin font face variable setting.
    ├ 📄 ltr.scss          - Left-to-right variable setting.
    ├ 📄 rtl.scss          - Right-to-left variable setting.
    ├ 📄 ko.scss           - Korean font face variable setting.
    ├ 📄 ur.scss           - Urdu font face variable setting.
    ├ 📄 zh-hant.scss      - Chinese font face variable setting.
    └ 📄 ...
  └ 📁 js                - JavaScript source.
    ├ 📁 modules           - Supporting ES modules.
    ├ 📄 main.js           - Main JavaScript entry-point.
    ├ 📄 search.js         - The Search view JavaScript (if required).
    ├ 📄 single.js         - The Single view JavaScript (if required).
    └ 📄 ...
├ 📂 views             - View templates are generally organized on a component level and by site feature, including <a href="https://twig.symfony.com/">Twig</a>, <a href="https://vuejs.org/v2/guide/single-file-components.html">Vue.js</a>, <a href="https://reactjs.org/docs/introducing-jsx.html">JSX</a>, and/or jst (pre-compiled js templates) files.
  ├ 📁 components        - Component pattern templates.
  ├ 📁 elements          - Element pattern templates.
  ├ 📁 emails            - Email view templates (if required).
  ├ 📁 objects           - Object pattern templates.
  ├ 📁 partials          - Misc. view template partials.
  ├ 📄 base.twig         - The base template, extended by view templates.
  ├ 📄 search.twig       - The search view template.
  ├ 📄 singular.twig     - The single view template.
  └ 📄 ...
├ 📄 archive.php       - Archive view controller. Context for the view is added here.
├ 📄 footer.php        - This may be required to prevent plugins from using the wp_footer() function to render output.
├ 📄 functions.php     - Main PHP entry point. Includes files from 📁 blocks, 📁 lib, and 📁 shortcodes.
├ 📄 header.php        - This may be required to prevent plugins from using the wp_header() function to render output.
├ 📄 index.php         - Index view controller. Context for the view is added here.
├ 📄 search.php        - Search view controller. Context for the view is added here.
├ 📄 singular.php      - Single view controller. Context for the view is added here.
├ 📄 .nvmrc            - If a specific node version is required, this file can specify the version. More details can be found in the <a href="https://github.com/nvm-sh/nvm#nvmrc">Node Version Manager docs</a>.
├ 📄 package.json      - Contains required front-end packages for the theme.
├ 📄 package-lock.json - Keep the package lock file along with the theme.
├ 📄 manifest.json     - A <a href="https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json">manifest.json</a> file for progressive web applications.
├ 📄 style.css         - Theme meta data; name, version, author, etc.
├ 📄 editor-style.css  - Editor styles. <a href="https://developer.wordpress.org/block-editor/developers/themes/theme-support/#editor-styles">Theme support needs to be added and the stylesheet must be instantiated</a>.
├ 📄 wp-admin-bar.css  - WP Admin Bar styles (if any). This stylesheet needs to be registered and enqueued for admin views.
└ 📄 ...
</pre></div>

<!-- # Environments

TEST
STAGING
PRODUCTION -->

# Security

Refer to this [free security whitepaper](https://wordpress.org/about/security/) from WordPress.org to become more familiar with the security components and best practices of the WordPress Core software. Additionally, the [Open Web Application Security Project](https://www.owasp.org/index.php/About_The_Open_Web_Application_Security_Project) (OWASP) provides [guidelines for implementing security for WordPress sites](https://www.owasp.org/index.php/OWASP_Wordpress_Security_Implementation_Guideline) that includes free and open source resources instead of commercial ones. Some of the practices mentioned are included in this boilerplate through plugins and documentation while others should be implemented on a case by case basis.

---

![The Mayor's Office for Economic Opportunity](NYCMOEO_SecondaryBlue256px.png)

[The Mayor's Office for Economic Opportunity](http://nyc.gov/opportunity) (NYC Opportunity) is committed to sharing open source software that we use in our products. Feel free to ask questions and share feedback. **Interested in contributing?** See our open positions on [buildwithnyc.github.io](http://buildwithnyc.github.io/). Follow our team on [Github](https://github.com/orgs/CityOfNewYork/teams/nycopportunity) (if you are part of the [@cityofnewyork](https://github.com/CityOfNewYork/) organization) or [browse our work on Github](https://github.com/search?q=nycopportunity).
