import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../models/analyst.dart';
import '../models/dashboard_data.dart';
import '../models/priority_alert.dart';
import '../models/risk_hotspot.dart';
import '../models/spread_row.dart';
import '../models/stat_item.dart';
import 'dashboard_repository.dart';

/// Live implementation of [DashboardRepository]. Calls
/// GET /api/v1/dashboard/overview on the Raqib / HyaCast AI Engine
/// (main.py), which analyzes all 126 registered waterway segments and
/// returns aggregate metrics plus the top priority-alert / spread
/// rows for the dashboard screen.
class ApiDashboardRepository implements DashboardRepository {
  ApiDashboardRepository({String? baseUrl}) : _baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  final String _baseUrl;

  @override
  Future<DashboardData> fetchDashboardData() async {
    final uri = Uri.parse('$_baseUrl/api/v1/dashboard/overview');

    // Loops over every segment server-side, so give it a generous timeout.
    final response = await http.get(uri).timeout(const Duration(minutes: 10));

    if (response.statusCode != 200) {
      throw Exception('Server error (${response.statusCode}): ${response.body}');
    }

    final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;

    if (body['status'] != 'success') {
      throw Exception(body['message'] as String? ?? 'Unknown dashboard error.');
    }

    final metrics = body['metrics'] as Map<String, dynamic>;
    final priorityAlerts = (body['priority_alerts'] as List)
        .map((e) => PriorityAlert.fromJson(e as Map<String, dynamic>))
        .toList();
    final spreadRows = (body['spread_overview'] as List)
        .map((e) => SpreadRow.fromJson(e as Map<String, dynamic>))
        .toList();

    return DashboardData(
      // The API only returns metrics + segment lists — it has no
      // concept of a title/subtitle/analyst, so these stay static to
      // match the Figma header design.
      title: 'Hyacinth monitoring & forecasting',
      subtitle: 'Early detection, risk prioritization & spread forecasting',
      lastUpdateLabel: 'Just now',
      analyst: const Analyst(name: 'Dr. Sarah', role: 'Senior Analyst'),
      stats: [
        StatItem(
          type: StatType.monitoredSegments,
          label: 'MONITORED SEGMENTS',
          value: '${metrics['monitored_segments']}',
        ),
        StatItem(
          type: StatType.activeAlerts,
          label: 'ACTIVE ALERTS',
          value: '${metrics['active_alerts']}',
        ),
        StatItem(
          type: StatType.coverageDetected,
          label: 'COVERAGE DETECTED',
          value: '${metrics['coverage_detected']}',
        ),
        StatItem(
          type: StatType.forecastAccuracy,
          label: 'FORECAST ACCURACY',
          value: '${metrics['forecast_accuracy']}',
        ),
      ],
      // Not part of the API response — RiskMapCard renders a live map
      // via MapAnalysisCubit instead of a static image, so these stay
      // empty/unused.
      mapImageUrl: '',
      hotspots: const <RiskHotspot>[],
      priorityAlerts: priorityAlerts,
      spreadRows: spreadRows,
    );
  }
}
