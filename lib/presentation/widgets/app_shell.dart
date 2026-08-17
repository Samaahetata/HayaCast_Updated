import 'package:flutter/material.dart';

import '../../data/repositories/dashboard_repository.dart';
import '../screens/dashboard_screen.dart';
import 'sidebar.dart';

/// The app's persistent shell: the fixed [Sidebar] plus the main
/// screen content. Kept separate from `main.dart` so app bootstrap
/// (theme, repository wiring) stays independent of screen composition.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.dashboardRepository});

  final DashboardRepository dashboardRepository;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Sidebar(),
        Expanded(
          child: DashboardBody(repository: dashboardRepository),
        ),
      ],
    );
  }
}
