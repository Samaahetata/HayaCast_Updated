import 'package:flutter/material.dart';
import 'package:hyacast/core/theme/hyacast_colors.dart';

class TableHeaderCell extends StatelessWidget {
  const TableHeaderCell(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: HyaCastColors.muted,
        ),
      ),
    );
  }
}