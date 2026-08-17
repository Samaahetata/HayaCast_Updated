import 'risk_level.dart';

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
    return SpreadRow(
      area: json['area'] as String,
      segmentId: json['segment_id'] as String,
      level: RiskLevel.fromString(json['level'] as String),
      growthRateLabel: json['growth_rate_label'] as String,
      criticalInLabel: json['critical_in_label'] as String,
      coverageFraction: (json['coverage_fraction'] as num).toDouble(),
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
