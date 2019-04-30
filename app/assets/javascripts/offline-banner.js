var displayOfflineBanner = function() {
  if (navigator.onLine) $('.app-c-govuk-offline-banner').hide();
  else $('.app-c-govuk-offline-banner').show();
};

window.addEventListener('online', displayOfflineBanner);
window.addEventListener('offline', displayOfflineBanner);
displayOfflineBanner();
