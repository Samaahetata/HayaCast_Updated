import 'package:flutter/material.dart';

import '../../core/theme/hyacast_colors.dart';
import '../../data/models/risk_level.dart';
import '../cubit/map_analysis_cubit.dart';

/// Small floating badge shown over the risk map with the current
/// region's analysis (coverage %, risk level) or a loading/error
/// state, driven entirely by a [MapAnalysisState].
class MapAnalysisBadge extends StatelessWidget {
  const MapAnalysisBadge({super.key, required this.state});

  final MapAnalysisState state;

  static const _colorByLevel = {
    RiskLevel.critical: Color(0xFFDC2626),
    RiskLevel.high: Color(0xFFEA580C),
    RiskLevel.moderate: Color(0xFFCA8A04),
    RiskLevel.low: Color(0xFF16A34A),
  };

  @override
  Widget build(BuildContext context) {
    if (state is MapAnalysisInitial) return const SizedBox.shrink();

    if (state is MapAnalysisError) {
      return const _Pill(
        color: HyaCastColors.criticalText,
        child: Text('Analysis failed', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      );
    }

    final result = state is MapAnalysisLoaded
        ? (state as MapAnalysisLoaded).result
        : (state as MapAnalysisLoading).previous;

    final isLoading = state is MapAnalysisLoading;

    if (result == null) {
      return const _Pill(
        color: HyaCastColors.muted,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
            SizedBox(width: 8),
            Text('Analyzing region…', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      );
    }

    final color = _colorByLevel[result.risk] ?? HyaCastColors.muted;

    return _Pill(
      color: color.withOpacity(0.9),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
            const SizedBox(width: 8),
          ],
          Text(
            '${result.risk.label} \u00b7 ${result.coveragePercentage.toStringAsFixed(1)}% coverage',
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Tiny rounded-rect chip shared by every state of [MapAnalysisBadge].
/// Kept private — it's an implementation detail of the badge, not a
/// generally reusable shape on its own.
class _Pill extends StatelessWidget {
  const _Pill({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: child,
    );
  }
}
