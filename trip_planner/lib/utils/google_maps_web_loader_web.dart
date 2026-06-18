import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Injects the Google Maps JavaScript API `<script>` into the page at runtime
/// using [apiKey] (from `.env`). Completes once the script has loaded so the
/// caller can `await` it before the first map is built. Safe to call more than
/// once (e.g. hot restart) and never throws — a load failure simply resolves so
/// app startup isn't blocked.
Future<void> loadGoogleMapsJsApi(String apiKey) async {
  if (apiKey.isEmpty) return;
  // Already injected (hot restart) — nothing to do.
  if (web.document.getElementById('google-maps-js') != null) return;

  final completer = Completer<void>();
  final script =
      web.document.createElement('script') as web.HTMLScriptElement
        ..id = 'google-maps-js'
        ..src = 'https://maps.googleapis.com/maps/api/js?key=$apiKey'
        ..async = true
        ..defer = true;

  void done(web.Event _) {
    if (!completer.isCompleted) completer.complete();
  }

  // Resolve on success and on error alike — a missing script shouldn't block
  // app startup (the map simply won't render).
  script.addEventListener('load', done.toJS);
  script.addEventListener('error', done.toJS);
  web.document.head!.appendChild(script);
  return completer.future;
}
