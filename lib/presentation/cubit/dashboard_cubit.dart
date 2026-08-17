import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/dashboard_data.dart';
import '../../data/repositories/dashboard_repository.dart';

sealed class DashboardState {
  const DashboardState();
}

/// A fetch is in flight. Carries the last good data (if any) so the
/// UI can keep showing it — with a pull-to-refresh spinner over the
/// top — instead of flashing back to a blank loading screen every
/// time the user refreshes.
class DashboardLoading extends DashboardState {
  const DashboardLoading({this.previous});
  final DashboardData? previous;
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.data);
  final DashboardData data;
}

class DashboardError extends DashboardState {
  const DashboardError(this.message, {this.previous});
  final String message;
  final DashboardData? previous;
}

/// Owns the Monitoring dashboard's data: fetches it from a
/// [DashboardRepository] and exposes loading/loaded/error states.
/// The screen (`dashboard_screen.dart`) only renders whatever state
/// this cubit is in — it holds no fetch/refresh logic of its own.
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required DashboardRepository repository})
      : _repository = repository,
        super(const DashboardLoading());

  final DashboardRepository _repository;

  /// Bumped on every call so a slow, stale request can't overwrite
  /// the result of a newer one (e.g. the user pulls to refresh twice
  /// quickly).
  int _requestId = 0;

  Future<void> load() async {
    final thisRequestId = ++_requestId;
    final previous = _previousData(state);

    emit(DashboardLoading(previous: previous));

    try {
      final data = await _repository.fetchDashboardData();
      if (thisRequestId != _requestId) return; // a newer request superseded this one
      emit(DashboardLoaded(data));
    } catch (e) {
      if (thisRequestId != _requestId) return;
      emit(DashboardError(e.toString(), previous: previous));
    }
  }

  DashboardData? _previousData(DashboardState state) {
    if (state is DashboardLoaded) return state.data;
    if (state is DashboardError) return state.previous;
    if (state is DashboardLoading) return state.previous;
    return null;
  }
}
