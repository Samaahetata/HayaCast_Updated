import 'package:flutter/material.dart';
import '../../core/theme/hyacast_colors.dart';
import '../../data/models/risk_hotspot.dart';

class HotspotMarker extends StatelessWidget {
  const HotspotMarker({super.key, required this.hotspot});

  final RiskHotspot hotspot;

  static const _colorByLevel = {
    'critical': Color(0xFFDC2626),
    'high': Color(0xFFEA580C),
    'moderate': Color(0xFFCA8A04),
    'low': Color(0xFF16A34A),
  };

  @override
  Widget build(BuildContext context) {
    final color = _colorByLevel[hotspot.level.name] ?? HyaCastColors.muted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.8), borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(hotspot.label, style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
