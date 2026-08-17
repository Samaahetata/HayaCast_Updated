import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/dashboard_data.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../components/error_state.dart';
import '../cubit/dashboard_cubit.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/priority_alerts_card.dart';
import '../widgets/risk_map_card.dart';
import '../widgets/spread_overview_card.dart';
import '../widgets/stat_cards_row.dart';

/// The Monitoring dashboard's content. Lives inside [AppShell] — no
/// `Scaffold`/`Sidebar` here, that's owned once by the shell.
///
/// Owns a [DashboardCubit] scoped to this widget's lifetime and
/// renders whatever state it's in. All fetch/refresh/error logic
/// lives in the cubit, not here.
class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
    required this.repository,
  });

  final DashboardRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(repository: repository)..load(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        // A refresh failed but we still have data on screen — surface
        // it as a snackbar instead of throwing the content away.
        if (state is DashboardError && state.previous != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('Refresh failed: ${state.message}')));
        }
      },
      builder: (context, state) {
        // ==============================================================
        // FIRST LOAD — no data yet
        // ==============================================================

        if (state is DashboardLoading && state.previous == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // ==============================================================
        // ERROR — and nothing to fall back on
        // ==============================================================

        if (state is DashboardError && state.previous == null) {
          return ErrorState(
            message: state.message,
            onRetry: () => context.read<DashboardCubit>().load(),
          );
        }

        // ==============================================================
        // CONTENT — freshly loaded, or a refresh/retry in flight with
        // the previous data still on screen
        // ==============================================================

        final data = switch (state) {
          DashboardLoaded(:final data) => data,
          DashboardLoading(:final previous) => previous!,
          DashboardError(:final previous) => previous!,
        };

        return RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().load(),
          child: _DashboardContent(data: data),
        );
      },
    );
  }
}

// ============================================================================
// CONTENT
// ============================================================================

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // HEADER
          // ========================================================
          // Header is intentionally OUTSIDE the 24px content padding
          // so it can stretch across the available width.

          DashboardHeader(
            title: data.title,
            subtitle: data.subtitle,
            lastUpdateLabel: data.lastUpdateLabel,
            analyst: data.analyst,
          ),

          // ========================================================
          // DASHBOARD CONTENT
          // ========================================================
          // Everything below the header keeps the original 24px
          // padding.

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

                    const map = RiskMapCard();

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
    );
  }
}
