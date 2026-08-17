enum StatType {
  monitoredSegments,
  activeAlerts,
  coverageDetected,
  forecastAccuracy;

  factory StatType.fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'monitored_segments':
        return StatType.monitoredSegments;
      case 'active_alerts':
        return StatType.activeAlerts;
      case 'coverage_detected':
        return StatType.coverageDetected;
      case 'forecast_accuracy':
        return StatType.forecastAccuracy;
      default:
        throw ArgumentError('Unknown stat type: $value');
    }
  }
}

class StatItem {
  const StatItem({
    required this.type,
    required this.label,
    required this.value,
  });

  final StatType type;
  final String label;
  final String value;

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(
      type: StatType.fromString(json['type'] as String),
      label: json['label'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'label': label,
        'value': value,
      };
}
