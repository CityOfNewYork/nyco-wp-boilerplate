<?php

// phpcs:disable
/**
 * Plugin Name: Clean Up Head
 * Description: Remove unecessary scripts, styles, and tags from the default WordPress head tag.
 * Plugin URI: https://github.com/cityofnewyork/nyco-wp-docker-boilerplate/wp/wp-content/mu-plugins/clean-up-head.php
 * Author: NYC Opportunity
 * Author URI: nyc.gov/opportunity
 */
// phpcs:enable

add_action('init', function() {
  remove_action('wp_head', 'rsd_link');
  remove_action('wp_head', 'wlwmanifest_link');
  remove_action('wp_head', 'index_rel_link');
  remove_action('wp_head', 'wp_generator');
  remove_action('wp_head', 'print_emoji_detection_script', 7);
  remove_action('wp_head', 'se_global_head');
  remove_action('admin_print_scripts', 'print_emoji_detection_script');
  remove_action('wp_print_styles', 'print_emoji_styles');
  remove_action('admin_print_styles', 'print_emoji_styles');
  remove_filter('the_content_feed', 'wp_staticize_emoji');
  remove_filter('comment_text_rss', 'wp_staticize_emoji');
  remove_filter('wp_mail', 'wp_staticize_emoji_for_email');
});
