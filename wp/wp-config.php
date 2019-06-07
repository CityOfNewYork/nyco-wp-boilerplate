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
 */

define('WP_DEBUG', true);

define('WP_DEBUG_DISPLAY', WP_DEBUG);

/**
 * Autoload Composer dependencies
 */

require_once __DIR__ . '/vendor/autoload.php';

/**
 * Whoops PHP Error Handler
 * @link https://github.com/filp/whoops
 */

if (true === WP_DEBUG) {
  $whoops = new \Whoops\Run;
  $whoops->pushHandler(new \Whoops\Handler\PrettyPageHandler);
  $whoops->register();
}

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
 * Redis Object Cache
 * @link https://wordpress.org/plugins/redis-cache/
 * Configure the plugin to use the image in our dockerfile.
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
 */

putenv('WP_ENV=development');

$_ENV['WP_ENV'] = getenv('WP_ENV');

define('WP_ENV', getenv('WP_ENV'));

/**
 * WordPress Query Monitor Plugin Configuration
 * @link https://wordpress.org/plugins/query-monitor/
 *
 * Enabling the capabilities panel for Query Monitor
 */

define('QM_ENABLE_CAPS_PANEL', WP_DEBUG);

/**
 * Log errors
 * @link https://wordpress.org/support/article/debugging-in-wordpress/#wp_debug_log
 */

define('WP_DEBUG_LOG', WP_DEBUG); // wp-content/debug.log

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
  define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
