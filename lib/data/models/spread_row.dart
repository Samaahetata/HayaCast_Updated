import 'risk_level.dart';

/// One waterway segment, as returned inside `spread_overview` by
/// GET /api/v1/dashboard/overview. Same JSON shape as the segments
/// used for [PriorityAlert] — see that class for an example payload.
class SpreadRow {
  const SpreadRow({
    required this.area,
    required this.segmentId,
    required this.level,
    required this.growthRateLabel,
    required this.criticalInLabel,
    required this.coverageFraction,
  });

  final String area;
  final String segmentId;
  final RiskLevel level;
  final String growthRateLabel;
  final String criticalInLabel;

  /// 0.0 - 1.0
  final double coverageFraction;

  factory SpreadRow.fromJson(Map<String, dynamic> json) {
    final coverage = (json['coverage_percentage'] as num?)?.toDouble() ?? 0.0;
    final critical = json['days_to_critical'];

    return SpreadRow(
      area: json['area_name'] as String? ?? json['area'] as String? ?? '',
      segmentId: json['segment_id'] as String? ?? '',
      level: RiskLevel.fromString(json['risk_level'] as String? ?? json['level'] as String? ?? 'Low'),
      growthRateLabel: json['growth_rate_weekly'] as String? ?? json['growth_rate_label'] as String? ?? '',
      criticalInLabel: critical is num ? '${critical.round()} days' : (critical as String? ?? '—'),
      coverageFraction: coverage / 100.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'area': area,
        'segment_id': segmentId,
        'level': level.name,
        'growth_rate_label': growthRateLabel,
        'critical_in_label': criticalInLabel,
        'coverage_fraction': coverageFraction,
      };
}
