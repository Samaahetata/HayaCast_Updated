import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/hyacast_colors.dart';
import '../../data/models/region_bounds.dart';
import '../../data/repositories/geocoding_repository.dart';
import '../components/map_analysis_badge.dart';
import '../components/map_search_bar.dart';
import '../cubit/map_analysis_cubit.dart';

/// The Hyacinth Risk Map card. Owns the [MapAnalysisCubit] and the
/// [MapController] — both are per-map state, so they're created and
/// disposed here rather than living anywhere shared.
class RiskMapCard extends StatefulWidget {
  const RiskMapCard({super.key});

  @override
  State<RiskMapCard> createState() => _RiskMapCardState();
}

class _RiskMapCardState extends State<RiskMapCard> {
  late final MapAnalysisCubit _cubit;
  final MapController _mapController = MapController();
  final GeocodingRepository _geocoding = GeocodingRepository();
  Timer? _debounce;

  static const _initialCenter = LatLng(AppConfig.initialLat, AppConfig.initialLng);

  @override
  void initState() {
    super.initState();
    _cubit = MapAnalysisCubit();
    // First analysis, once the map has laid itself out.
    WidgetsBinding.instance.addPostFrameCallback((_) => _analyzeVisibleRegion());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cubit.close();
    super.dispose();
  }

  /// Called on every map event (drag, zoom, fling...). Debounced so we
  /// only call the AI engine once the user has actually stopped
  /// moving the map, instead of on every intermediate frame.
  void _onMapEvent(MapEvent event) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _analyzeVisibleRegion);
  }

  void _analyzeVisibleRegion() {
    final bounds = _mapController.camera.visibleBounds;

    final region = RegionBounds(
      minLat: bounds.south,
      minLon: bounds.west,
      maxLat: bounds.north,
      maxLon: bounds.east,
    );

    if (!mounted) return;
    _cubit.analyzeRegion(region);
  }

  /// Looks up [query] and recenters the map there. Moving the map
  /// fires the same [_onMapEvent] the user's own panning/zooming
  /// triggers, so the visible region gets re-analyzed automatically.
  Future<void> _searchAndMove(String query) async {
    final target = await _geocoding.searchPlace(query);
    _mapController.move(target, 14);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: HyaCastColors.cardBg, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hyacinth Risk Map', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: HyaCastColors.heading)),
                SizedBox(height: 4),
                Text('Pan or zoom to analyze a different waterway region', style: TextStyle(fontSize: 12, color: HyaCastColors.muted)),
              ],
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 351,
                width: double.infinity,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _initialCenter,
                        initialZoom: AppConfig.initialZoom,
                        onMapEvent: _onMapEvent,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.hyacast.app',
                        ),
                      ],
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: BlocBuilder<MapAnalysisCubit, MapAnalysisState>(
                        builder: (context, state) => MapAnalysisBadge(state: state),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: MapSearchBar(onSearch: _searchAndMove),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
