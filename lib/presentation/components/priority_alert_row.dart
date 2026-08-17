import 'package:flutter/material.dart';
import '../../core/theme/hyacast_colors.dart';
import '../../data/models/priority_alert.dart';
import 'risk_badge.dart';

class PriorityAlertRow extends StatelessWidget {
  const PriorityAlertRow({super.key, required this.alert});

  final PriorityAlert alert;

  // Fixed column widths so every row's badge / percent / View line up
  // regardless of how long each label is.
  static const _badgeColumnWidth = 76.0;
  static const _percentColumnWidth = 40.0;
  static const _viewColumnWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(alert.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
              const SizedBox(height: 4),
              Text(alert.subtitle, style: const TextStyle(fontSize: 10, color: HyaCastColors.mutedLight)),
            ],
          ),
        ),
        SizedBox(
          width: _badgeColumnWidth,
          child: Align(alignment: Alignment.centerLeft, child: RiskBadge(level: alert.level)),
        ),
        SizedBox(
          width: _percentColumnWidth,
          child: Text(
            alert.percentLabel,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        SizedBox(
          width: _viewColumnWidth,
          child: const Text(
            'View',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A5C38)),
          ),
        ),
      ],
    );
  }
}
