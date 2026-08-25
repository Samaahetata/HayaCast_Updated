enum RiskLevel {
  critical,
  high,
  moderate,
  low;

  factory RiskLevel.fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'critical':
        return RiskLevel.critical;
      case 'high':
        return RiskLevel.high;
      case 'moderate':
      case 'medium':
        return RiskLevel.moderate;
      case 'low':
        return RiskLevel.low;
      default:
        throw ArgumentError('Unknown risk level: $value');
    }
  }

  String get label {
    switch (this) {
      case RiskLevel.critical:
        return 'Critical';
      case RiskLevel.high:
        return 'High';
      case RiskLevel.moderate:
        return 'Moderate';
      case RiskLevel.low:
        return 'Low';
    }
  }
}
