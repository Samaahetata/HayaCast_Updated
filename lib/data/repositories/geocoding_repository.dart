import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Thrown when a place search fails or returns no results.
class GeocodingException implements Exception {
  GeocodingException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Looks up place names using OpenStreetMap's free Nominatim service —
/// the same map provider already used for tiles in [RiskMapCard], so
/// no API key is needed.
class GeocodingRepository {
  static const _baseUrl = 'https://nominatim.openstreetmap.org/search';

  Future<LatLng> searchPlace(String query) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'q': query,
      'format': 'json',
      'limit': '1',
    });

    final response = await http
        .get(uri, headers: {'User-Agent': 'com.hyacast.app'})
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw GeocodingException('Search failed (${response.statusCode}).');
    }

    final results = jsonDecode(response.body) as List;
    if (results.isEmpty) {
      throw GeocodingException('No location found for "$query".');
    }

    final first = results.first as Map<String, dynamic>;
    return LatLng(
      double.parse(first['lat'] as String),
      double.parse(first['lon'] as String),
    );
  }
}
