import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/sidebar.dart' show AppScreen;

/// Which screen the persistent sidebar shell is showing. Both screens
/// stay mounted (see [AppShell]'s `IndexedStack`) — this cubit just
/// picks which one is on top, so switching feels instant instead of
/// a page navigation/reload.
class NavigationCubit extends Cubit<AppScreen> {
  NavigationCubit() : super(AppScreen.monitoring);

  void showMonitoring() => emit(AppScreen.monitoring);
  void showImageAnalysis() => emit(AppScreen.imageAnalysis);
}
