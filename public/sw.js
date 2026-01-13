const CACHE_NAME = "web-sb-cache-v1";

// Install: Cache initial resources
self.addEventListener("install", (event) => {
  console.log("SW: Installing and caching initial resources");
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(["/"]);
    })
  );
  self.skipWaiting();
});

// Fetch: Cache everything on the fly
self.addEventListener("fetch", (event) => {
  console.log("SW: Fetching", event.request.url);
  event.respondWith(
    caches.match(event.request).then((response) => {
      if (response) {
        console.log("SW: Serving from cache", event.request.url);
        return response;
      }
      // Return cached version or fetch and cache
      return (
        response ||
        fetch(event.request)
          .then((response) => {
            if (response.status === 200) {
              console.log("SW: Caching", event.request.url);
              // Clone the response to cache it
              const responseClone = response.clone();
              caches.open(CACHE_NAME).then((cache) => {
                cache.put(event.request, responseClone);
              });
            }
            return response;
          })
          .catch(() => {
            console.log("SW: Offline, serving from cache or fallback", event.request.url);
            // If offline, try cache, fallback to home for HTML or 503 for others
            const cached = caches.match(event.request);
            if (cached) return cached;
            if (event.request.headers.get("accept").includes("text/html")) {
              return caches.match("/") || new Response("Offline - Home Page", { status: 503 });
            }
            return new Response("Offline", { status: 503 });
          })
      );
    })
  );
});

// Activate: Clean up old caches
self.addEventListener("activate", (event) => {
  console.log("SW: Activating and cleaning old caches");
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log("SW: Deleting old cache", cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  self.clients.claim();
});
