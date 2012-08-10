$(function() {
  var tabbable = $('#guide-nav');
  var tab_options = {
    spinner: 'Retrieving data...',
    cache: true,
    selected: 0
  }

  tabbable.tabs(tab_options);
});
