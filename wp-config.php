<?

// Database
define('DB_NAME', 'wp');
define('DB_USER', 'wp');
define('DB_PASSWORD', 'wp');
define('DB_HOST', 'mysql:3306');
define('DB_CHARSET', 'utf8');

// Content Directory
define('WP_CONTENT_DIR', '/var/www/wp-content');

// Debugging
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
@ini_set('display_errors', 1);

// [Salts](https://api.wordpress.org/secret-key/1.1/salt/)
define('AUTH_KEY', '');
define('SECURE_AUTH_KEY', '');
define('LOGGED_IN_KEY', '');
define('NONCE_KEY', '');
define('AUTH_SALT', '');
define('SECURE_AUTH_SALT', '');
define('LOGGED_IN_SALT', '');
define('NONCE_SALT', '');

// Table Prefix
$table_prefix  = 'wp_';

// URL
define('WP_SITEURL', 'http://localhost:8080');
define('WP_HOME', 'http://localhost:8080');

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
