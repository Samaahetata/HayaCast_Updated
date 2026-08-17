import 'risk_level.dart';

/// Parsed result of a POST /analyze call to the Raqib AI Engine
/// (api.py). Mirrors the `data` object in a successful response:
///
/// ```json
/// {
///   "status": "success",
///   "data": {
///     "hyacinth_detected": true,
///     "coverage_percentage": 12.5,
///     "growth_rate_weekly": 1.8,
///     "risk": "Moderate",
///     "days_to_critical": 21.0,
///     "points_analyzed": 4
///   }
/// }
/// ```
class AnalysisResult {
  const AnalysisResult({
    required this.hyacinthDetected,
    required this.coveragePercentage,
    required this.growthRateWeekly,
    required this.risk,
    required this.daysToCritical,
    required this.pointsAnalyzed,
  });

  final bool hyacinthDetected;
  final double coveragePercentage;
  final double growthRateWeekly;
  final RiskLevel risk;

  /// -1 means "not projected to reach critical coverage".
  final double daysToCritical;
  final int pointsAnalyzed;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      hyacinthDetected: json['hyacinth_detected'] as bool? ?? false,
      coveragePercentage: (json['coverage_percentage'] as num?)?.toDouble() ?? 0.0,
      growthRateWeekly: (json['growth_rate_weekly'] as num?)?.toDouble() ?? 0.0,
      risk: RiskLevel.fromString(json['risk'] as String? ?? 'Low'),
      daysToCritical: (json['days_to_critical'] as num?)?.toDouble() ?? -1,
      pointsAnalyzed: (json['points_analyzed'] as num?)?.toInt() ?? 0,
    );
  }
}
