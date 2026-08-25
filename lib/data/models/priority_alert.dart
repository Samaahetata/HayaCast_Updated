import 'risk_level.dart';

/// One waterway segment, as returned inside `priority_alerts` by
/// GET /api/v1/dashboard/overview. Mirrors:
///
/// ```json
/// {
///   "segment_id": "EG-901",
///   "area_name": "Kitchener Drain",
///   "basin": "Delta Basin",
///   "coverage_percentage": 75.0,
///   "growth_rate_weekly": "+4.8%/week",
///   "risk_level": "CRITICAL",
///   "days_to_critical": 9
/// }
/// ```
class PriorityAlert {
  const PriorityAlert({
    required this.name,
    required this.subtitle,
    required this.level,
    required this.percentLabel,
  });

  final String name;
  final String subtitle;
  final RiskLevel level;
  final String percentLabel;

  factory PriorityAlert.fromJson(Map<String, dynamic> json) {
    final basin = json['basin'] as String?;
    final coverage = (json['coverage_percentage'] as num?)?.toDouble() ?? 0.0;

    return PriorityAlert(
      name: json['area_name'] as String? ?? json['name'] as String? ?? '',
      subtitle: basin != null && basin.isNotEmpty
          ? '$basin waterway segment'
          : json['subtitle'] as String? ?? '',
      level: RiskLevel.fromString(json['risk_level'] as String? ?? json['level'] as String? ?? 'Low'),
      percentLabel: '${coverage.round()}%',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'subtitle': subtitle,
        'level': level.name,
        'percent_label': percentLabel,
      };
}
