// Web Push notifications
self.addEventListener("push", async (event) => {
  const data = event.data ? event.data.json() : {};
  const title = data.title || "Readnest";
  const options = {
    body: data.body || "",
    icon: "/icon-192.png",
    badge: "/icon-192.png",
    data: { path: data.path || "/" }
  };
  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener("notificationclick", function (event) {
  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: "window" }).then((clientList) => {
      const path = event.notification.data.path;
      for (let client of clientList) {
        if (new URL(client.url).pathname === path && "focus" in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(path);
      }
    })
  );
});

const CACHE_NAME = "readnest-cache-v1";

// Install : rien à pré-cacher pour le moment, mais on est prêt
self.addEventListener("install", (event) => {
  self.skipWaiting();
  console.log("[ServiceWorker] Installed");
});

// Activate : nettoyage des anciens caches
self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
        })
      )
    )
  );
  self.clients.claim();
  console.log("[ServiceWorker] Activated");
});

// Fetch : stratégie network-first avec fallback sur le cache
self.addEventListener("fetch", (event) => {
  // On ne gère que les requêtes GET
  if (event.request.method !== "GET") return;

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        const responseClone = response.clone();
        caches.open(CACHE_NAME).then((cache) => {
          cache.put(event.request, responseClone);
        });
        return response;
      })
      .catch(() => caches.match(event.request))
  );
});
