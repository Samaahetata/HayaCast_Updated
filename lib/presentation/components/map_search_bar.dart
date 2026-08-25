import 'package:flutter/material.dart';

import '../../core/theme/hyacast_colors.dart';

/// Floating search field shown over [RiskMapCard]. Purely presentational
/// — it just reports submitted queries via [onSearch] and shows a
/// loading/error state around the result of that call.
class MapSearchBar extends StatefulWidget {
  const MapSearchBar({super.key, required this.onSearch});

  final Future<void> Function(String query) onSearch;

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await widget.onSearch(query);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: _error ?? 'Search a place or canal…',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: _error != null ? HyaCastColors.criticalText : HyaCastColors.muted,
                ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          if (_loading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.search, size: 18, color: HyaCastColors.muted),
              onPressed: _submit,
            ),
        ],
      ),
    );
  }
}
