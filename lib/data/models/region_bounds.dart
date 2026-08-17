/// A plain lat/lon bounding box — deliberately independent of any
/// map package's own LatLngBounds type, so the data layer doesn't
/// need to import `google_maps_flutter`.
class RegionBounds {
  const RegionBounds({
    required this.minLat,
    required this.minLon,
    required this.maxLat,
    required this.maxLon,
  });

  final double minLat;
  final double minLon;
  final double maxLat;
  final double maxLon;

  Map<String, dynamic> toJson() => {
        'min_lon': minLon,
        'min_lat': minLat,
        'max_lon': maxLon,
        'max_lat': maxLat,
      };
}
