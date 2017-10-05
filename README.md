This branch contains the sample docker-compose.yml and wp-config file to setup a Wordpress Docker Environment.

## Requirements:
* Docker installed with Docker Compose
* Make the edits in wp-config.php and docker-compose.yml where there is <user-to-set>

## What this does:
* Builds the MySQL image and container
* Builds the Wordpress image and container
* Builds the phpMyAdmin image and container

## To Run:
1. Copy these files and directories into the root of your project. 
2. Edit the `docker-compose.yml` with your desired passwords and volumes that you would like Docker to retain.
3. Export a copy of the SQL file that you would like Docker to load up when the environment is started.
4. In the terminal, use `docker-compose up`.

## Navigate to Pages
* To load up your site in a browser, navigate to your machine's IP and the port you defined under `wordpress` in the `docker-compose.yml`. You can find your machine's IP using `docker-machine ip default`. Example: http://<ip-address>:8000.
* To load up your phpMyAdmin in a browser, navigate to your machine's IP and the port you defined under `phpmyadmin` in the `docker-compose.yml`. You can find your machine's IP using `docker-machine ip default`. Example: http://<ip-address>:8181


# Proposal
This [tutorial](https://codeable.io/wordpress-developers-intro-docker/) introduces
the reasoning for using Docker really well;

> So what is that Docker brings to the table? One thing: consistency. It guarantees
> the environment will be identical no matter where you run it; Locally, on 50 different
> computers, in a CI (continuous integration) environment or in production - it will
> work exactly the same, because it will use the same environment and code.

There are more specific details on that page but the basic proposal is this; utilizing
Docker will help us more professionally manage our products.

Here is a [Google Doc](https://docs.google.com/document/d/1tOjk_6aBxLurST5QDz-dV00yezt5i-cBbSAM6kf-W8U/edit)
where we can work on creating a consitent Wordpress Docker boilerplate that will
work with our agency's products. Specifically AccesNYC and Growing Up NYC.

Eventually, we can replace this readme with documentation on how to set up our products
generally so we have an agreement on the kind of configuration that is best suited
for each product.
