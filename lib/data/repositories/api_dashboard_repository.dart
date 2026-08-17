import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../models/dashboard_data.dart';
import 'dashboard_repository.dart';

/// Live implementation of [DashboardRepository]. Calls GET /dashboard
/// on the Raqib AI Engine (api_full.py), which analyzes every
/// registered waterway and returns everything the dashboard screen
/// needs in one response.
class ApiDashboardRepository implements DashboardRepository {
  ApiDashboardRepository({String? baseUrl}) : _baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  final String _baseUrl;

  @override
  Future<DashboardData> fetchDashboardData() async {
    final uri = Uri.parse('$_baseUrl/dashboard');

    // The aggregate analysis loops over several waterways, each doing
    // multiple Earth Engine calls, so give it a generous timeout.
    final response = await http.get(uri).timeout(const Duration(minutes: 3));

    if (response.statusCode != 200) {
      throw Exception('Server error (${response.statusCode}): ${response.body}');
    }

    final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
    return DashboardData.fromJson(body);
  }
}
