import 'package:flutter/material.dart';
import '../components/priority_alert_row.dart';

import '../../core/theme/hyacast_colors.dart';
import '../../data/models/priority_alert.dart';
class PriorityAlertsCard extends StatelessWidget {
  const PriorityAlertsCard({super.key, required this.alerts});

  final List<PriorityAlert> alerts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: HyaCastColors.cardBg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Priority Alerts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: HyaCastColors.heading)),
          const SizedBox(height: 4),
          const Text('Highest-risk areas requiring intervention', style: TextStyle(fontSize: 12, color: HyaCastColors.muted)),
          const SizedBox(height: 24),
          for (var i = 0; i < alerts.length; i++) ...[
            PriorityAlertRow(alert: alerts[i]),
            if (i != alerts.length - 1) const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}

