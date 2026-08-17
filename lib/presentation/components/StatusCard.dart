import 'package:flutter/material.dart';

import 'pulse_dot.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // rgba(133,160,178,0.26) from Figma — a translucent slate
        // overlay on the dark sidebar, not a solid navy card.
        color: const Color(0x4285A0B2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Green pulsing status indicator
          const PulseDot(size: 8, color: Color(0xFF22C55E)),

          const SizedBox(width: 8),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monitoring Active',
                style: TextStyle(
                  color: Color(0xFFF8FAFC),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                'System Online',
                style: TextStyle(
                  color: Color(0xFF85A0B2),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
