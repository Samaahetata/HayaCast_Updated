import 'package:flutter/material.dart';

import 'core/theme/hyacast_colors.dart';
import 'data/repositories/api_dashboard_repository.dart';
import 'data/repositories/dashboard_repository.dart';
import 'presentation/widgets/app_shell.dart';

void main() {
  runApp(const HyaCastApp());
}

/// App bootstrap only: theming and which [DashboardRepository]
/// implementation is wired in. All actual screen composition lives in
/// [AppShell]; the dashboard's own loading/error/data state lives in
/// its cubit (see `presentation/cubit/dashboard_cubit.dart`).
class HyaCastApp extends StatelessWidget {
  const HyaCastApp({super.key});

  // Live data from the Raqib AI Engine (api_full.py's /dashboard
  // endpoint). Swap back to MockDashboardRepository() if you need to
  // work on the UI without the backend running.
  static final DashboardRepository dashboardRepository = ApiDashboardRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HyaCast',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Geist'),
      home: Scaffold(
        backgroundColor: HyaCastColors.bg,
        body: AppShell(dashboardRepository: dashboardRepository),
      ),
    );
  }
}
