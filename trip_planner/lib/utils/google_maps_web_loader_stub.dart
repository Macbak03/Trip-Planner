/// No-op fallback for non-web platforms: the native Google Maps SDKs are
/// configured per platform (AndroidManifest / AppDelegate), so there is no
/// JavaScript API to load here.
Future<void> loadGoogleMapsJsApi(String apiKey) async {}
