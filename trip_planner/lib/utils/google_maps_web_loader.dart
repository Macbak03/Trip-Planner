// Loads the Google Maps JavaScript API at runtime.
//
// `google_maps_flutter` on web needs `window.google.maps` to exist before a
// map is created. Instead of hard-coding the key in `web/index.html`, we inject
// the script tag from Dart using the key read from `.env`, keeping `.env` the
// single source of truth. On non-web platforms this resolves to a no-op (the
// native Maps SDKs are configured per platform).
export 'google_maps_web_loader_stub.dart'
    if (dart.library.js_interop) 'google_maps_web_loader_web.dart';
