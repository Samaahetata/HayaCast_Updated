import 'package:flutter/material.dart';

import '../../core/theme/hyacast_colors.dart';
import '../../data/models/analyst.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.lastUpdateLabel,
    required this.analyst,
  });

  final String title;
  final String subtitle;
  final String lastUpdateLabel;
  final Analyst analyst;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: HyaCastColors.cardBg, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(24),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: HyaCastColors.heading),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 18, color: HyaCastColors.muted)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: HyaCastColors.gradientStart.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(color: HyaCastColors.gradientEnd, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        // Explicit fontFamily: RichText/Text.rich spans
                        // don't inherit ThemeData.fontFamily, so this
                        // was silently rendering in the platform's
                        // default font instead of Geist.
                        style: const TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: HyaCastColors.muted,
                        ),
                        children: [
                          const TextSpan(text: 'Last satellite update:'),
                          TextSpan(
                            text: ' $lastUpdateLabel',
                            style: const TextStyle(fontFamily: 'Geist', color: HyaCastColors.heading),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 28),
              CircleAvatar(
                radius: 23,
                backgroundColor: const Color(0xFFE2E8F0),
                backgroundImage: analyst.avatarUrl != null ? NetworkImage(analyst.avatarUrl!) : null,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    analyst.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: HyaCastColors.heading),
                  ),
                  Text(analyst.role, style: const TextStyle(fontSize: 12, color: HyaCastColors.muted)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
