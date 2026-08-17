/// Central place for environment/config values.
///
/// Change [apiBaseUrl] to wherever your FastAPI (Raqib AI Engine) server
/// is running. While developing locally with `uvicorn main:app --reload`
/// the default port is 8000.
class AppConfig {
  AppConfig._();

  /// Base URL of the FastAPI backend (api.py).
  /// Example when running locally: http://127.0.0.1:8000
  static const String apiBaseUrl = 'http://127.0.0.1:8000';

  /// Where the map opens the first time the app launches.
  /// Currently centered on Rashid (Rosetta) — the mouth of the
  /// Rashid branch of the Nile.
  static const double initialLat = 31.4014;
  static const double initialLng = 30.4184;
  static const double initialZoom = 13;
}
