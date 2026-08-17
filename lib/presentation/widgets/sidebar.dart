import 'package:flutter/material.dart';
import 'package:hyacast/presentation/components/StatusCard.dart';
import '../components/sidebar_item.dart';
import '../components/sidebar_logo.dart';
import '../../core/theme/hyacast_colors.dart';

/// The app's fixed left navigation rail: logo, nav items, and the
/// connection status card. There's currently a single screen
/// (Monitoring), so this is static — no selection state to manage.
/// If a second screen is added later, give this widget a `current`/
/// `onTap` pair again rather than hardcoding.
class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: HyaCastColors.sidebarBg,
      padding: const EdgeInsets.all(24),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SidebarLogo(),

          SizedBox(height: 40),

          SidebarItem(
            icon: Icons.gps_fixed,
            label: 'Monitoring',
            selected: true,
          ),

          Spacer(),

          StatusCard(),
        ],
      ),
    );
  }
}
