// Sidebar Item

import 'package:flutter/material.dart';
import 'package:hyacast/core/theme/hyacast_colors.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? HyaCastColors.sidebarSelected
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          child: Row(
            children: [
              // Icon

              if (selected)
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF47E48E),
                        Color(0xFF217648),
                      ],
                    ).createShader(bounds);
                  },
                  child: Icon(
                    icon,
                    size: 22,
                    color: Colors.white,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 24,
                  color: const Color(0xFF6AAB92),
                ),

              const SizedBox(width: 8),

              // Label

              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : const Color(0xFF6AAB92),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
