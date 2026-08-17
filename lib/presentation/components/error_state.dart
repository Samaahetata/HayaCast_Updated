import 'package:flutter/material.dart';

import '../../core/theme/hyacast_colors.dart';

/// Centered icon + message + retry button, shown whenever a screen's
/// data failed to load. Generic enough to reuse anywhere a fetch can
/// fail, not just the dashboard.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: HyaCastColors.criticalText,
            size: 40,
          ),

          const SizedBox(height: 12),

          Text(
            message,
            style: const TextStyle(
              color: HyaCastColors.muted,
            ),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
