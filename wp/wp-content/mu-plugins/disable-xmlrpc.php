<?php

// phpcs:disable
/**
 * Plugin Name: Disable XML-RPC
 * Description: Disable XML-RPC methods that require authentication. @link https://kinsta.com/blog/wordpress-xml-rpc/
 * Plugin URI: https://github.com/cityofnewyork/nyco-wp-docker-boilerplate/wp/wp-content/mu-plugins/disable-xmlrpc.php
 * Author: NYC Opportunity
 * Author URI: nyc.gov/opportunity
 */
// phpcs:enable

add_filter('xmlrpc_enabled', '__return_false');
