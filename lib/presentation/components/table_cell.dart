import 'package:flutter/material.dart';

class SpreadTableCell extends StatelessWidget {
  const SpreadTableCell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      child: child,
    );
  }
}