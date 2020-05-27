<?php

// phpcs:disable
/**
 * Plugin Name: Close Attachment Comments and Pings
 * Description: Disable future comments and ping status (spam) for attachments as there is no way to close comments in admin settings. For previously uploaded attachments the wp cli can be used to close them (examples are included in the source of this plugin).
 * Plugin URI: https://github.com/cityofnewyork/nyco-wp-docker-boilerplate/wp/wp-content/mu-plugins/close-attachment-comments.php
 * Author: NYC Opportunity
 * Author URI: nyc.gov/opportunity
 *
 * To close previously uploaded attachments the wp cli can be used.
 * wp post list --post_type=attachment --format=ids | xargs wp post update --comment_status=closed
 * wp post list --post_type=attachment --format=ids | xargs wp post update --ping_status=closed
 */
// phpcs:enable

add_filter('wp_insert_post_data', function($data) {
  if ($data['post_type'] === 'attachment') {
    $data['comment_status'] = 'closed';
    $data['ping_status'] = 'closed';
  }

  return $data;
});
