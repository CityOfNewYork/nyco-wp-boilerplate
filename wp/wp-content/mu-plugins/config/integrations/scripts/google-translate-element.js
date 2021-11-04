/**
 * Optionally, use the NYCO Patterns Scripts Translate Element script.
 * @url https://github.com/CityOfNewYork/patterns-scripts/tree/main/src/google-translate-element
 */

/**
 * Sample initializer for Google Translate Element
 */
function googleTranslateElementInit() {
  new google.translate.TranslateElement({
    pageLanguage: 'en',
    includedLanguages: 'es,ru,ko,ar,ht,zh-CN,fr,pl,ur,bn',
    autoDisplay: false
  }, 'js-google-translate');
}