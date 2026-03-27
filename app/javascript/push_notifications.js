const PushNotifications = {
  async init() {
    if (!("serviceWorker" in navigator) || !("PushManager" in window)) return;

    const btn = document.getElementById("push-toggle-btn");
    if (!btn) return;

    const registration = await navigator.serviceWorker.ready;
    const subscription = await registration.pushManager.getSubscription();

    this.updateButton(btn, !!subscription);
    btn.addEventListener("click", () => this.toggle(btn, registration));
  },

  async toggle(btn, registration) {
    const subscription = await registration.pushManager.getSubscription();
    if (subscription) {
      await this.unsubscribe(btn, subscription);
    } else {
      await this.subscribe(btn, registration);
    }
  },

  async subscribe(btn, registration) {
    const permission = await Notification.requestPermission();
    if (permission !== "granted") return;

    const vapidPublicKey = document.querySelector('meta[name="vapid-public-key"]')?.content;
    if (!vapidPublicKey) return;

    const subscription = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: this.urlBase64ToUint8Array(vapidPublicKey)
    });

    await fetch("/push_subscriptions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify(subscription.toJSON())
    });

    this.updateButton(btn, true);
  },

  async unsubscribe(btn, subscription) {
    await fetch("/push_subscriptions", {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ endpoint: subscription.endpoint })
    });

    await subscription.unsubscribe();
    this.updateButton(btn, false);
  },

  updateButton(btn, subscribed) {
    btn.querySelector("i").className = subscribed ? "bi bi-bell-fill me-2" : "bi bi-bell-slash me-2";
    const label = document.getElementById("push-toggle-label");
    if (label) label.textContent = subscribed ? "Désactiver les notifications" : "Activer les notifications";
  },

  urlBase64ToUint8Array(base64String) {
    const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
    const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
    const rawData = window.atob(base64);
    return Uint8Array.from([...rawData].map((c) => c.charCodeAt(0)));
  }
};

document.addEventListener("turbo:load", () => PushNotifications.init());
