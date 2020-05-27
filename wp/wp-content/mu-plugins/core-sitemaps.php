<?php

// phpcs:disable
/**
 * Plugin Name: Configure Core Sitemaps
 * Description: Configuration for the proposed WordPress core plugin for simple sitemaps. Filters out users, taxonomies, and other post types that do not have page views.
 * Plugin URI: https://github.com/cityofnewyork/nyco-wp-docker-boilerplate/wp/wp-content/mu-plugins/core-sitemaps.php
 * Author: NYC Opportunity
 * Author URI: nyc.gov/opportunity
 */
// phpcs:enable

/**
 * Filters the list of registered sitemap providers.
 *
 * @param array $providers Array of Core_Sitemap_Provider objects.
 */
add_filter('core_sitemaps_register_providers', function($providers) {
  unset($providers['users']);

  return $providers;
});

/**
 * Filter the list of post object sub types available within the sitemap.
 *
 * @param array $post_types List of registered object sub types.
 */
add_filter('core_sitemaps_post_types', function($post_types) {
  // unset($post_types['post']);

  return $post_types;
});
