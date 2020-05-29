<?php

// phpcs:disable
/**
 * Plugin Name: Disable User REST Endpoints
 * Description: Explicitly disables WordPress REST API endpoints related to users.
 * Plugin URI: https://github.com/cityofnewyork/nyco-wp-docker-boilerplate/wp/wp-content/mu-plugins/rest-endpoints.php
 * Author: NYC Opportunity
 * Author URI: nyc.gov/opportunity
 */
// phpcs:enable

add_filter('rest_endpoints', function($endpoints) {
  $disable = [
    '/wp/v2/users',
    '/wp/v2/users/me',
    '/wp/v2/users/(?P<id>[\d]+)',
    '/acf/v3/users',
    '/acf/v3/users/(?P<id>[\\d]+)/?(?P<field>[\\w\\-\\_]+)?'
  ];

  foreach ($disable as $key => $endpoint) {
    if (isset($endpoints[$endpoint])) {
      unset($endpoints[$endpoint]);
    }
  }

  return $endpoints;
});
