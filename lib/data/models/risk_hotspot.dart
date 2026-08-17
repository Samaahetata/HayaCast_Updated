import 'risk_level.dart';

class RiskHotspot {
  const RiskHotspot({
    required this.label,
    required this.level,
    required this.dx,
    required this.dy,
  });

  final String label;
  final RiskLevel level;

  /// Position on the map image as a fraction of width/height (0.0 - 1.0),
  /// so it stays correct regardless of the rendered image size.
  final double dx;
  final double dy;

  factory RiskHotspot.fromJson(Map<String, dynamic> json) {
    return RiskHotspot(
      label: json['label'] as String,
      level: RiskLevel.fromString(json['level'] as String),
      dx: (json['dx'] as num).toDouble(),
      dy: (json['dy'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'level': level.name,
        'dx': dx,
        'dy': dy,
      };
}
