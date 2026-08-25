import 'risk_level.dart';

/// Parsed result of a POST to /api/v1/map/analyze-point or
/// /api/v1/map/analyze-bbox on the Raqib / HyaCast AI Engine
/// (main.py). Mirrors the response JSON, which is returned directly
/// at the top level (no wrapping "data" object):
///
/// ```json
/// {
///   "status": "success",
///   "location": "[31.4014, 30.4184]",
///   "acquisition_date": "2026-08-10 09:32",
///   "coverage_percentage": 12.5,
///   "growth_rate_weekly": 1.8,
///   "days_to_critical": 21.0,
///   "risk_level": "MEDIUM",
///   "action_recommendation": "Moderate Tracking: ...",
///   "historical_trend": [8.1, 10.4, 12.5]
/// }
/// ```
class AnalysisResult {
  const AnalysisResult({
    required this.location,
    required this.acquisitionDate,
    required this.coveragePercentage,
    required this.growthRateWeekly,
    required this.risk,
    required this.daysToCritical,
    required this.actionRecommendation,
    required this.historicalTrend,
  });

  final String location;
  final String acquisitionDate;
  final double coveragePercentage;
  final double growthRateWeekly;
  final RiskLevel risk;

  /// -1 means "not projected to reach critical coverage".
  final double daysToCritical;
  final String actionRecommendation;
  final List<double> historicalTrend;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      location: json['location'] as String? ?? '',
      acquisitionDate: json['acquisition_date'] as String? ?? '',
      coveragePercentage: (json['coverage_percentage'] as num?)?.toDouble() ?? 0.0,
      growthRateWeekly: (json['growth_rate_weekly'] as num?)?.toDouble() ?? 0.0,
      risk: RiskLevel.fromString(json['risk_level'] as String? ?? 'Low'),
      daysToCritical: (json['days_to_critical'] as num?)?.toDouble() ?? -1,
      actionRecommendation: json['action_recommendation'] as String? ?? '',
      historicalTrend: (json['historical_trend'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
