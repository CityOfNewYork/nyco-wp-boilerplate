<?php

// phpcs:disable
/**
 * Plugin Name: Add Meta Description to Head
 * Description: Adds the description defined in the WordPress Admin settings to the description meta tag in the head for the homepage only.
 * Plugin URI: https://github.com/cityofnewyork/nyco-wp-docker-boilerplate/wp/wp-content/mu-plugins/add-meta-description-to-head.php
 * Author: NYC Opportunity
 * Author URI: nyc.gov/opportunity
 */
// phpcs:enable

add_action('pre_get_document_title', function ($title) {
  // render only on the homepage
  if (is_home()) {
    echo '<meta name="description" content="' . get_bloginfo('description') . '" />' . "\r\n";
    // remove tagline from title tag
    $title = get_bloginfo('name');
  }

  return $title;
}, 10, 1);
