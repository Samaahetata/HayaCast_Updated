import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../models/analysis_result.dart';
import '../models/region_bounds.dart';

/// Thrown when the AI engine responds with something other than
/// `status: "success"` (e.g. no clear satellite imagery for the
/// requested region) or the request itself fails.
class AnalysisException implements Exception {
  AnalysisException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Talks to the Raqib / HyaCast AI Engine (main.py) over HTTP.
class AiAnalysisRepository {
  AiAnalysisRepository({String? baseUrl}) : _baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  final String _baseUrl;

  /// Calls POST /api/v1/map/analyze-bbox for the given bounding box
  /// and returns the parsed result. Throws [AnalysisException] on
  /// error responses.
  Future<AnalysisResult> analyzeRegion(RegionBounds bounds) async {
    final uri = Uri.parse('$_baseUrl/api/v1/map/analyze-bbox');

    // Runs a real Earth Engine analysis server-side (imagery fetch +
    // model fit), which can take a while, so give it a generous
    // timeout instead of the previous tight 60s.
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bounds.toJson()),
    );

    final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw AnalysisException('Server error (${response.statusCode}): ${response.body}');
    }

    if (response.statusCode != 200 || body['status'] != 'success') {
      final detail = body['detail'] ?? body['message'] ?? 'Unknown analysis error.';
      throw AnalysisException(detail.toString());
    }

    return AnalysisResult.fromJson(body);
  }
}