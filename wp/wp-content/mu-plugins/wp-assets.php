<?php

// phpcs:disable
/**
 * Plugin Name: NYCO WordPress Assets
 * Description: A developer plugin with helpers for managing assets in WordPress. It can be used to enqueue stylesheets with hashed names as well as configure integrations such as Google Analytics, Rollbar, etc.
 * Author: NYC Opportunity
 */
// phpcs:enable

require_once plugin_dir_path(__FILE__) . '/wp-assets/WpAssets.php';
require_once plugin_dir_path(__FILE__) . '/wp-assets/EnqueueInline.php';
require_once plugin_dir_path(__FILE__) . '/wp-assets/query-monitor/WpAssetsAddOn.php';

/**
 * Set instance of WpAssets to the global scope
 */

$GLOBALS['wp_assets'] = new NYCO\WpAssets();

/**
 * Initialize Query Monitor Add On
 */

new NYCO\QueryMonitor\WpAssetsAddOn($GLOBALS['wp_assets']);

/**
 * Add the following to your functions.php or to individual theme template
 * view files to enqueue the Google Integration Suite.
 *
 * add_action('wp_enqueue_scripts', function() {
 *   enqueue_inline('data-layer');
 *   enqueue_inline('google-optimize');
 *   enqueue_inline('google-analytics');
 *   enqueue_inline('google-tag-manager');
 *   enqueue_inline('google-translate-element');
 * });
 */

 /**
 * Manual DNS prefetch and preconnect headers that are not added through
 * enqueueing functions above.
 *
 * @link https://developer.mozilla.org/en-US/docs/Web/Performance/dns-prefetch
 *
 * add_filter('wp_resource_hints', function($urls, $relation_type) {
 *   switch ($relation_type) {
 *     case 'dns-prefetch':
 *       $urls = array_merge($urls, [
 *         '//www.google-analytics.com',
 *         '//translate.googleapis.com'
 *       ]);

 *       break;
 *   }

 *   return $urls;
 * }, 10, 2);
 *
 * @author NYC Opportunity
 */
