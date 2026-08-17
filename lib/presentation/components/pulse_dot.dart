import 'package:flutter/material.dart';

/// A small circle that gently pulses (scale + glow) to read as "live".
/// Used for the sidebar "Monitoring Active" indicator and next to the
/// "Analyzing..." label on the loading banner.
class PulseDot extends StatefulWidget {
  const PulseDot({
    super.key,
    this.size = 8,
    this.color = const Color(0xFF22C55E),
    this.duration = const Duration(milliseconds: 1200),
  });

  final double size;
  final Color color;
  final Duration duration;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(begin: 0.85, end: 1.35).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  late final Animation<double> _glowOpacity = Tween<double>(begin: 0.35, end: 0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          width: widget.size * 2.6,
          height: widget.size * 2.6,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft expanding halo
                Transform.scale(
                  scale: _scale.value * 1.8,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withOpacity(_glowOpacity.value),
                    ),
                  ),
                ),
                // Solid core dot
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
