import 'package:flutter/material.dart';

import '../../core/theme/hyacast_colors.dart';
import '../../data/models/dashboard_data.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/priority_alerts_card.dart';
import '../widgets/risk_map_card.dart';
import '../widgets/spread_overview_card.dart';
import '../widgets/stat_cards_row.dart';

/// The Monitoring dashboard's content. Lives inside [AppShell]'s
/// `IndexedStack` — no `Scaffold`/`Sidebar`/navigation here, those are
/// owned once by the shell so switching tabs never rebuilds them.
class DashboardBody extends StatefulWidget {
  const DashboardBody({
    super.key,
    required this.repository,
  });

  final DashboardRepository repository;

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  late Future<DashboardData> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = widget.repository.fetchDashboardData();
  }

  Future<void> _refresh() async {
    final future = widget.repository.fetchDashboardData();

    setState(() {
      _dashboardFuture = future;
    });

    await future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardData>(
      future: _dashboardFuture,
      builder: (context, snapshot) {
        // ==============================================================
        // LOADING
        // ==============================================================

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // ==============================================================
        // ERROR
        // ==============================================================

        if (snapshot.hasError) {
          return _ErrorState(
            message: snapshot.error.toString(),
            onRetry: _refresh,
          );
        }

        final data = snapshot.data!;

        // ==============================================================
        // CONTENT
        // ==============================================================

        return RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========================================================
                // HEADER
                // ========================================================
                // Header is intentionally OUTSIDE the 24px content
                // padding so it can stretch across the available width.

                DashboardHeader(
                  title: data.title,
                  subtitle: data.subtitle,
                  lastUpdateLabel: data.lastUpdateLabel,
                  analyst: data.analyst,
                ),

                // ========================================================
                // DASHBOARD CONTENT
                // ========================================================
                // Everything below the header keeps the original
                // 24px padding.

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // STAT CARDS
                      // ==================================================

                      StatCardsRow(
                        stats: data.stats,
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // MAP + PRIORITY ALERTS
                      // ==================================================

                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 900;

                          final map = RiskMapCard(
                            mapImageUrl: data.mapImageUrl,
                            hotspots: data.hotspots,
                          );

                          final alerts = PriorityAlertsCard(
                            alerts: data.priorityAlerts,
                          );

                          // ------------------------------------------------
                          // WIDE SCREEN
                          // ------------------------------------------------

                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: map,
                                ),

                                const SizedBox(width: 24),

                                Expanded(
                                  flex: 1,
                                  child: alerts,
                                ),
                              ],
                            );
                          }

                          // ------------------------------------------------
                          // SMALL SCREEN
                          // ------------------------------------------------

                          return Column(
                            children: [
                              map,

                              const SizedBox(height: 24),

                              alerts,
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // SPREAD OVERVIEW
                      // ==================================================

                      SpreadOverviewCard(
                        rows: data.spreadRows,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// ERROR STATE
// ============================================================================

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

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