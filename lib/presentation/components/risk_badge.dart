import 'package:flutter/material.dart';

import '../../core/theme/hyacast_colors.dart';
import '../../data/models/risk_level.dart';

class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key, required this.level});

  final RiskLevel level;

  static const _bgByLevel = {
    RiskLevel.critical: HyaCastColors.criticalBg,
    RiskLevel.high: HyaCastColors.highBg,
    RiskLevel.moderate: HyaCastColors.moderateBg,
    RiskLevel.low: HyaCastColors.lowBg,
  };

  static const _textByLevel = {
    RiskLevel.critical: HyaCastColors.criticalText,
    RiskLevel.high: HyaCastColors.highText,
    RiskLevel.moderate: HyaCastColors.moderateText,
    RiskLevel.low: HyaCastColors.lowText,
  };

  static Color colorForLevel(RiskLevel level) => _textByLevel[level]!;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: _bgByLevel[level], borderRadius: BorderRadius.circular(6)),
      child: Text(
        level.label,
        style: TextStyle(color: _textByLevel[level], fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
