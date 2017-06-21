<?

// Database
define('DB_NAME', getenv('DB_NAME'));
define('DB_USER', getenv('DB_USER'));
define('DB_PASSWORD', getenv('DB_PASSWORD'));
define('DB_HOST', getenv('DB_HOST'));
define('DB_CHARSET', getenv('DB_CHARSET'));

// Content Directory
define('WP_CONTENT_DIR', getenv('WP_CONTENT_DIR'));

// Debugging
define('WP_DEBUG', getenv('WP_DEBUG'));
define('WP_DEBUG_LOG', getenv('WP_DEBUG_LOG'));
define('WP_DEBUG_DISPLAY', getenv('WP_DEBUG_DISPLAY'));
@ini_set('display_errors', getenv('DISPLAY_ERRORS'));

// Salts
define('AUTH_KEY', getenv('AUTH_KEY'));
define('SECURE_AUTH_KEY', getenv('SECURE_AUTH_KEY'));
define('LOGGED_IN_KEY', getenv('LOGGED_IN_KEY'));
define('NONCE_KEY', getenv('NONCE_KEY'));
define('AUTH_SALT', getenv('AUTH_SALT'));
define('SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT'));
define('LOGGED_IN_SALT', getenv('LOGGED_IN_SALT'));
define('NONCE_SALT', getenv('NONCE_SALT'));

// Table Prefix
$table_prefix  = getenv('TABLE_PREFIX') ?: 'wp_';

// Site URL
if (!defined('WP_SITEURL'))
  define('WP_SITEURL', 'http://' . $_SERVER['SERVER_NAME'] . ':' . $_SERVER['SERVER_PORT']);

if (!defined('WP_HOME'))
  define('WP_HOME', 'http://' . $_SERVER['SERVER_NAME'] . ':' . $_SERVER['SERVER_PORT']);

// Absolute path to the WordPress directory
if (!defined('ABSPATH'))
  define('ABSPATH', dirname(__FILE__) . '/');

// Sets up WordPress vars and included files
require_once(ABSPATH . 'wp-settings.php');