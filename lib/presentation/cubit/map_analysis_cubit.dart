import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/analysis_result.dart';
import '../../data/models/region_bounds.dart';
import '../../data/repositories/ai_analysis_repository.dart';

abstract class MapAnalysisState {
  const MapAnalysisState();
}

/// Nothing analyzed yet (before the map has finished its first frame).
class MapAnalysisInitial extends MapAnalysisState {
  const MapAnalysisInitial();
}

/// A request is in flight. Carries the last good result (if any) so
/// the UI can keep showing it while the new one loads instead of
/// flashing a blank state every time the user pans the map.
class MapAnalysisLoading extends MapAnalysisState {
  const MapAnalysisLoading({this.previous});
  final AnalysisResult? previous;
}

class MapAnalysisLoaded extends MapAnalysisState {
  const MapAnalysisLoaded(this.result);
  final AnalysisResult result;
}

class MapAnalysisError extends MapAnalysisState {
  const MapAnalysisError(this.message);
  final String message;
}

/// Drives region analysis: every time the visible map region changes
/// (the user pans/zooms), call [analyzeRegion] with the new bounds and
/// this cubit fetches fresh data from the AI engine and emits it.
class MapAnalysisCubit extends Cubit<MapAnalysisState> {
  MapAnalysisCubit({AiAnalysisRepository? repository})
      : _repository = repository ?? AiAnalysisRepository(),
        super(const MapAnalysisInitial());

  final AiAnalysisRepository _repository;

  /// Bumped on every call so that a slow, stale request can't
  /// overwrite the result of a newer one (e.g. user panned twice
  /// quickly).
  int _requestId = 0;

  Future<void> analyzeRegion(RegionBounds bounds) async {
    final thisRequestId = ++_requestId;

    final previous = state is MapAnalysisLoaded ? (state as MapAnalysisLoaded).result : null;
    emit(MapAnalysisLoading(previous: previous));

    try {
      final result = await _repository.analyzeRegion(bounds);
      if (thisRequestId != _requestId) return; // a newer request superseded this one
      emit(MapAnalysisLoaded(result));
    } catch (e) {
      if (thisRequestId != _requestId) return;
      emit(MapAnalysisError(e.toString()));
    }
  }
}
