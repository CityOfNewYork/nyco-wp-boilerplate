# Images
- nginx:alpine
- wordpress:fpm
- mysql:5.7

This image will install the latest version of Wordpress to be served by nginx.

# Use
If you are controlling the versioning of Wordpress, place your Wordpress core
in the `wp` directory. Otherwise you can drop in only the core files needed for
your site to run. The Docker image will pull the latest version of Wordpress
and mount any files you do not include.

Place your development database `.sql` file in the `./data` directory. There's
no need to rename it as the mysql image will look for any `.sql` file and
execute it when the image is built.

Generate your [Salts](https://api.wordpress.org/secret-key/1.1/salt/) and place
them in the `wp-config.php` file. Move the configuration file to the Wordpress
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
* `WP` The directory of the Wordpress site.
* `THEME` The path to the main working theme.

`sftp.cfg` SFTP Settings for getting the uploads directory with `bin/get-uploads.sh` (to be tested).

`deploy.cfg` Slack message settings for the `bin/deploy.sh`.

If you install Wordpress in a directory other than `./wp` you will need to change
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
- [ ] Test the get uploads script
- [ ] ~~Configure `wp-config.php` to use `.env` variables~~
- [x] Set up `wp-cli` to manage users and plugins on initilization of the wordpress image
- [x] The nginx image doesn't seem to work on the first initialization but when
      restart it will. Need to debug

