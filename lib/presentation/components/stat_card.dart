import 'package:flutter/material.dart';
import '../../core/theme/hyacast_colors.dart';

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: HyaCastColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: HyaCastColors.muted)),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [HyaCastColors.gradientStart, HyaCastColors.gradientEnd]),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(icon, size: 14, color: Colors.white),
              ),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: HyaCastColors.heading)),
        ],
      ),
    );
  }
}
