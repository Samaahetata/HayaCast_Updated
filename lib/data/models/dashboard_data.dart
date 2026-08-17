import 'analyst.dart';
import 'priority_alert.dart';
import 'risk_hotspot.dart';
import 'spread_row.dart';
import 'stat_item.dart';

/// Everything the dashboard screen needs to render, in one place.
/// Any data source (mock, REST API, AI model output) just needs to
/// produce this object — the UI layer never knows or cares where it
/// came from.
class DashboardData {
  const DashboardData({
    required this.title,
    required this.subtitle,
    required this.lastUpdateLabel,
    required this.analyst,
    required this.stats,
    required this.mapImageUrl,
    required this.hotspots,
    required this.priorityAlerts,
    required this.spreadRows,
  });

  final String title;
  final String subtitle;
  final String lastUpdateLabel;
  final Analyst analyst;
  final List<StatItem> stats;
  final String mapImageUrl;
  final List<RiskHotspot> hotspots;
  final List<PriorityAlert> priorityAlerts;
  final List<SpreadRow> spreadRows;

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      lastUpdateLabel: json['last_update_label'] as String,
      analyst: Analyst.fromJson(json['analyst'] as Map<String, dynamic>),
      stats: (json['stats'] as List)
          .map((e) => StatItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      mapImageUrl: json['map_image_url'] as String,
      hotspots: (json['hotspots'] as List)
          .map((e) => RiskHotspot.fromJson(e as Map<String, dynamic>))
          .toList(),
      priorityAlerts: (json['priority_alerts'] as List)
          .map((e) => PriorityAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
      spreadRows: (json['spread_rows'] as List)
          .map((e) => SpreadRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'last_update_label': lastUpdateLabel,
        'analyst': analyst.toJson(),
        'stats': stats.map((e) => e.toJson()).toList(),
        'map_image_url': mapImageUrl,
        'hotspots': hotspots.map((e) => e.toJson()).toList(),
        'priority_alerts': priorityAlerts.map((e) => e.toJson()).toList(),
        'spread_rows': spreadRows.map((e) => e.toJson()).toList(),
      };
}
