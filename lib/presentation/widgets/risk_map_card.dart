import 'package:flutter/material.dart';
import 'package:hyacast/presentation/components/HotspotMarke.dart';
import '../../core/theme/hyacast_colors.dart';
import '../../data/models/risk_hotspot.dart';

class RiskMapCard extends StatefulWidget {
  const RiskMapCard({super.key, required this.mapImageUrl, required this.hotspots});

  final String mapImageUrl;
  final List<RiskHotspot> hotspots;

  @override
  State<RiskMapCard> createState() => _RiskMapCardState();
}

class _RiskMapCardState extends State<RiskMapCard> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RiskHotspot> get _filteredHotspots {
    if (_query.trim().isEmpty) return widget.hotspots;
    final query = _query.trim().toLowerCase();
    return widget.hotspots.where((hotspot) => hotspot.label.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredHotspots = _filteredHotspots;
    final hasQuery = _query.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: HyaCastColors.cardBg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hyacinth Risk Map', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: HyaCastColors.heading)),
                    SizedBox(height: 4),
                    Text('Current coverage across monitored waterways', style: TextStyle(fontSize: 12, color: HyaCastColors.muted)),
                  ],
                ),
              ),
              Container(
                width: 220,
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: HyaCastColors.muted.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 14, color: HyaCastColors.muted),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: HyaCastColors.heading),
                        decoration: const InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: 'Search a region',
                          hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: HyaCastColors.muted),
                        ),
                      ),
                    ),
                    if (hasQuery)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        child: const Icon(Icons.close, size: 14, color: HyaCastColors.muted),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 351,
              width: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          widget.mapImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFDDE7DE)),
                        ),
                      ),
                      for (final hotspot in filteredHotspots)
                        Positioned(
                          left: hotspot.dx * constraints.maxWidth,
                          top: hotspot.dy * constraints.maxHeight,
                          child: HotspotMarker(hotspot: hotspot),
                        ),
                      if (hasQuery && filteredHotspots.isEmpty)
                        const Positioned.fill(
                          child: Center(
                            child: Text(
                              'No region matches your search',
                              style: TextStyle(fontSize: 13, color: HyaCastColors.muted),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
