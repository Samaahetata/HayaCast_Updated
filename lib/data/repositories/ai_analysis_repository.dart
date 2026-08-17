import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../models/analysis_result.dart';
import '../models/region_bounds.dart';

/// Thrown when the AI engine responds with `status: "error"` (e.g. no
/// clear satellite imagery for the requested region) or the request
/// itself fails.
class AnalysisException implements Exception {
  AnalysisException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Talks to the Raqib AI Engine (api.py) over HTTP.
class AiAnalysisRepository {
  AiAnalysisRepository({String? baseUrl}) : _baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  final String _baseUrl;

  /// Calls POST /analyze for the given bounding box and returns the
  /// parsed result. Throws [AnalysisException] on error responses.
  Future<AnalysisResult> analyzeRegion(RegionBounds bounds) async {
    final uri = Uri.parse('$_baseUrl/analyze');

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(bounds.toJson()),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != 200) {
      throw AnalysisException('Server error (${response.statusCode}): ${response.body}');
    }

    final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;

    if (body['status'] != 'success') {
      throw AnalysisException(body['message'] as String? ?? 'Unknown analysis error.');
    }

    return AnalysisResult.fromJson(body['data'] as Map<String, dynamic>);
  }
}
