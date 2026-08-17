import 'package:flutter/material.dart';

import '../../core/theme/hyacast_colors.dart';

/// The "HyaCast." wordmark shown at the top of the sidebar — the
/// gradient-filled name plus a solid-color period.
class SidebarLogo extends StatelessWidget {
  const SidebarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              HyaCastColors.gradientStart,
              HyaCastColors.gradientEnd,
            ],
          ).createShader(bounds),
          child: const Text(
            'HyaCast',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const Text(
          '.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: HyaCastColors.gradientStart,
          ),
        ),
      ],
    );
  }
}
