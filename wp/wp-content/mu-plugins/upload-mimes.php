<?php

// phpcs:disable
/**
 * Plugin Name: Upload Mimes
 * Description: Adds SVGs mime type to Media uploader to enable support for SVG files.
 * Plugin URI: https://github.com/cityofnewyork/nyco-wp-docker-boilerplate/wp/wp-content/mu-plugins/upload-mimes.php
 * Author: NYC Opportunity
 * Author URI: nyc.gov/opportunity
 */
// phpcs:enable

add_filter('upload_mimes', function($mimes) {
  $mimes['svg'] = 'image/svg+xml';

  return $mimes;
});
