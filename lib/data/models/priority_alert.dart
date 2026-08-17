import 'risk_level.dart';

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
    return PriorityAlert(
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      level: RiskLevel.fromString(json['level'] as String),
      percentLabel: json['percent_label'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'subtitle': subtitle,
        'level': level.name,
        'percent_label': percentLabel,
      };
}
