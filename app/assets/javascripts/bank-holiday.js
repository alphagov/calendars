$(function() {
var $container = $('article .inner');

if ($container.find('.js-tabs').length) {
  $container.tabs();
}
});