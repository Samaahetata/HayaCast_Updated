import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/hyacast_colors.dart';
import 'data/repositories/dashboard_repository.dart';
import 'data/repositories/mock_dashboard_repository.dart';
import 'presentation/cubit/navigation_cubit.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/widgets/sidebar.dart';

void main() {
  runApp(const HyaCastApp());
}

class HyaCastApp extends StatelessWidget {
  const HyaCastApp({super.key});

  // Swap this line for a real implementation (e.g. ApiDashboardRepository)
  // once the backend is ready — nothing else has to change.
  static final DashboardRepository dashboardRepository = MockDashboardRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HyaCast',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Geist'),
      home: BlocProvider(
        create: (_) => NavigationCubit(),
        child: Scaffold(
          backgroundColor: HyaCastColors.bg,
          body: BlocBuilder<NavigationCubit, AppScreen>(
            builder: (context, screen) {
              final nav = context.read<NavigationCubit>();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Sidebar(
                    current: screen,
                    onMonitoringTap: nav.showMonitoring,
                    // Image Analysis screen isn't part of this bundle —
                    // the tap still updates the cubit, it just has
                    // nowhere else to navigate to yet.
                    onImageAnalysisTap: nav.showImageAnalysis,
                  ),
                  Expanded(
                    child: DashboardBody(
                      repository: dashboardRepository,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
