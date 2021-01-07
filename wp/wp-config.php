<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wp');

/** MySQL database username */
define('DB_USER', 'wp');

/** MySQL database password */
define('DB_PASSWORD', 'wp');

/** MySQL hostname */
define('DB_HOST', 'mysql:3306');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**
 * Redis Object Cache. Configure the plugin to use the image in our dockerfile.
 *
 * @link https://wordpress.org/plugins/redis-cache/
 */

define('WP_REDIS_HOST', 'redis');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '');
define('SECURE_AUTH_KEY',  '');
define('LOGGED_IN_KEY',    '');
define('NONCE_KEY',        '');
define('AUTH_SALT',        '');
define('SECURE_AUTH_SALT', '');
define('LOGGED_IN_SALT',   '');
define('NONCE_SALT',       '');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WP_SITEURL allows the WordPress address (URL) to be defined. The value
 * defined is the address where your WordPress core files reside.
 *
 * WP_HOME overrides the wp_options table value for home but does not change
 * it in the database. home is the address you want people to type in their
 * browser to reach your WordPress site.
 *
 * @link https://codex.wordpress.org/Changing_The_Site_URL
 */

define('WP_SITEURL', 'http://localhost:8080');

define('WP_HOME', WP_SITEURL);

/**
 * Set our WordPress environment variable
 *
 * @link https://github.com/CityOfNewYork/nyco-wp-config/
 */

define('WP_ENV', 'development'); // Use development for convenience and active development

// define('WP_ENV', 'testing'); // Use testing for emulating configuration for production environments

putenv('WP_ENV=' . WP_ENV);

/**
 * WordPress Query Monitor Plugin Configuration. Enabling the capabilities
 * panel for Query Monitor.
 *
 * @link https://wordpress.org/plugins/query-monitor/
 */

define('QM_ENABLE_CAPS_PANEL', WP_DEBUG);

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 *
 * WP_DEBUG_DISPLAY is another companion to WP_DEBUG that controls whether debug
 * messages are shown inside the HTML of pages or not. The default is ‘true’
 * which shows errors and warnings as they are generated. Setting this to false
 * will hide all errors. This should be used in conjunction with WP_DEBUG_LOG so
 * that errors can be reviewed later.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/#wp_debug_display
 *
 * WP_DEBUG_LOG is a companion to WP_DEBUG that causes all errors to also be
 * saved to a debug.log log file This is useful if you want to review all
 * notices later or need to view notices generated off-screen (e.g. during an
 * AJAX request or wp-cron run).
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/#wp_debug_log
 *
 * SCRIPT_DEBUG is a related constant that will force WordPress to use the “dev”
 * versions of scripts and stylesheets in wp-includes/js, wp-includes/css,
 * wp-admin/js, and wp-admin/css will be loaded instead of the .min.css and
 * .min.js versions.. If you are planning on modifying some of WordPress’
 * built-in JavaScript or Cascading Style Sheets, you should add the following
 * code to your config file:
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/#script_debug
 */

define('WP_DEBUG', true);

define('WP_DEBUG_DISPLAY', WP_DEBUG);

// define('WP_DEBUG_LOG', WP_DEBUG); // wp-content/debug.log

// define('SCRIPT_DEBUG', WP_DEBUG);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
  define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
