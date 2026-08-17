import 'package:flutter/material.dart';

import '../components/risk_badge.dart';
import '../components/table_cell.dart';
import '../components/table_header_cell.dart';

import '../../core/theme/hyacast_colors.dart';
import '../../data/models/spread_row.dart';

class SpreadOverviewCard extends StatelessWidget {
  const SpreadOverviewCard({
    super.key,
    required this.rows,
  });

  final List<SpreadRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: HyaCastColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hyacinth Spread Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: HyaCastColors.heading,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Track current coverage and projected spread across areas',
            style: TextStyle(
              fontSize: 12,
              color: HyaCastColors.muted,
            ),
          ),

          const SizedBox(height: 24),

          LayoutBuilder(
            builder: (context, constraints) {
              const minTableWidth = 900.0;

              final table = Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.55),
                  1: FlexColumnWidth(1.58),
                  2: FlexColumnWidth(1.01),
                  3: FlexColumnWidth(1.32),
                  4: FlexColumnWidth(1.19),
                  5: FlexColumnWidth(1),
                },

                children: [
                  // HEADER
                  const TableRow(
                    decoration: BoxDecoration(
                      color: Color(0x1A85A0B2),
                    ),
                    children: [
                      TableHeaderCell('Area'),
                      TableHeaderCell('Segment ID'),
                      TableHeaderCell('Risk'),
                      TableHeaderCell('Growth rate'),
                      TableHeaderCell('Critical in'),
                      TableHeaderCell('Coverage'),
                    ],
                  ),

                  // DATA ROWS
                  for (final row in rows) _buildRow(row),
                ],
              );

              // Wide screen
              if (constraints.maxWidth >= minTableWidth) {
                return SizedBox(
                  width: double.infinity,
                  child: table,
                );
              }

              // Small screen
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: minTableWidth,
                  ),
                  child: table,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  TableRow _buildRow(SpreadRow row) {
    final color = RiskBadge.colorForLevel(row.level);

    return TableRow(
      children: [
        // AREA
        SpreadTableCell(
          child: Text(
            row.area,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: HyaCastColors.heading,
            ),
          ),
        ),

        // SEGMENT ID
        SpreadTableCell(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF6AAB92).withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                row.segmentId,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A5C38),
                ),
              ),
            ),
          ),
        ),

        // =========================
        // RISK
        // =========================
        SpreadTableCell(
          child: Align(
            alignment: Alignment.centerLeft,
            child: RiskBadge(
              level: row.level,
            ),
          ),
        ),

        // =========================
        // GROWTH RATE
        // =========================
        SpreadTableCell(
          child: Text(
            row.growthRateLabel,
            style: TextStyle(
              fontSize: 18,
              color: color,
            ),
          ),
        ),

        // =========================
        // CRITICAL IN
        // =========================
        SpreadTableCell(
          child: Text(
            row.criticalInLabel,
            style: TextStyle(
              fontSize: 18,
              color: color,
            ),
          ),
        ),

        // =========================
        // COVERAGE
        // =========================
        SpreadTableCell(
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: row.coverageFraction,
                    minHeight: 7,
                    backgroundColor:
                        HyaCastColors.muted.withOpacity(0.4),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      color,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Text(
                '${(row.coverageFraction * 100).round()}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: HyaCastColors.muted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}