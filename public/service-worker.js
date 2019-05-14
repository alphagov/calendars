// https://deanhume.com/create-a-really-really-simple-offline-page-using-service-workers/
'use strict';

var cacheVersion = 1;
var currentCache = {
  offline: 'govuk-calendar-cache-' + cacheVersion
};
var offlineUrls = [
  '/bank-holidays',
  '/when-do-the-clocks-change'
];

self.addEventListener('install', function(event) {
  self.skipWaiting();
  event.waitUntil(
    caches.open(currentCache.offline).then(function(cache) {
      return cache.addAll(offlineUrls);
    })
  );
});

self.addEventListener('activate', activateEvent => {
  // Optional: Get a list of all the current open windows/tabs under
  // our service worker's control, and force them to reload.
  // This can "unbreak" any open windows/tabs as soon as the new
  // service worker activates, rather than users having to manually reload.
  self.clients.matchAll({ type: 'window' }).then(function(windowClients) {
    windowClients.forEach(function(windowClient) {
      windowClient.navigate(windowClient.url);
    });
  });
});

self.addEventListener('fetch', function(event) {
  // request.mode = navigate isn't supported in all browsers
  // so include a check for Accept: text/html header.
  if (event.request.mode === 'navigate' || (event.request.method === 'GET' && event.request.headers.get('accept').includes('text/html'))) {
    event.respondWith(
      fetch(event.request.url).catch(function(error) {
        // Return the cached page if it exists
        return caches.match(event.request.url);
      })
    );
  } else {
    // Respond with everything else if we can
    event.respondWith(caches.match(event.request)
      .then(function(response) {
        return response || fetch(event.request);
      })
    );
  }
});
