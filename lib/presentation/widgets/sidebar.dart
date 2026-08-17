import 'package:flutter/material.dart';
import 'package:hyacast/presentation/components/SidebarItem.dart';
import 'package:hyacast/presentation/components/StatusCard.dart';

import '../../core/theme/hyacast_colors.dart';

/// Which top-level screen the sidebar is currently pointing at. Add a
/// case here whenever a new sidebar destination is introduced.
enum AppScreen { monitoring, imageAnalysis }

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.current,
    required this.onMonitoringTap,
    required this.onImageAnalysisTap,
  });

  final AppScreen current;
  final VoidCallback onMonitoringTap;
  final VoidCallback onImageAnalysisTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: HyaCastColors.sidebarBg,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
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
          ),

          const SizedBox(height: 40),

          // Monitoring

          SidebarItem(
            icon: Icons.gps_fixed,
            label: 'Monitoring',
            selected: current == AppScreen.monitoring,
            onTap: onMonitoringTap,
          ),

          const SizedBox(height: 8),

          // Image Analysis

          SidebarItem(
            icon: Icons.photo_library_outlined,
            label: 'Image Analysis',
            selected: current == AppScreen.imageAnalysis,
            onTap: onImageAnalysisTap,
          ),

          const Spacer(),

          // Status Card

          const StatusCard(),
        ],
      ),
    );
  }
}
