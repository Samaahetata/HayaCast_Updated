import 'package:flutter/material.dart';
import '../components/stat_card.dart';
import '../../data/models/stat_item.dart';

class StatCardsRow extends StatelessWidget {
  const StatCardsRow({super.key, required this.stats});

  final List<StatItem> stats;

  static const _iconByType = {
    StatType.monitoredSegments: Icons.location_on_outlined,
    StatType.activeAlerts: Icons.warning_amber_rounded,
    StatType.coverageDetected: Icons.eco_outlined,
    StatType.forecastAccuracy: Icons.insights_outlined,
  };

  static const _spacing = 24.0;
  static const _minCardWidth = 200.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          for (final stat in stats)
            StatCard(label: stat.label, value: stat.value, icon: _iconByType[stat.type] ?? Icons.circle_outlined),
        ];

        // Enough room for every card at equal width in one row (matches
        // the header/map row above and below so all edges line up).
        final widthIfOneRow = (constraints.maxWidth - _spacing * (cards.length - 1)) / cards.length;
        if (widthIfOneRow >= _minCardWidth) {
          return Row(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                Expanded(child: cards[i]),
                if (i != cards.length - 1) const SizedBox(width: _spacing),
              ],
            ],
          );
        }

        // Narrow screens: two equal-width cards per row.
        return Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: [
            for (final card in cards)
              SizedBox(width: (constraints.maxWidth - _spacing) / 2, child: card),
          ],
        );
      },
    );
  }
}

