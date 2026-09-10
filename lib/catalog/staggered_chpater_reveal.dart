import 'package:flutter/material.dart';
import '../theme/omowe_motion.dart';

/// Eyebrow → title (+40ms) → each line (+80ms), fade-up 8px.
///
/// Re-trigger via `GlobalKey<StaggeredChapterRevealState>` → `.replay()`.
class StaggeredChapterReveal extends StatefulWidget {
  const StaggeredChapterReveal({super.key, required this.children});

  final List<Widget> children;

  @override
  State<StaggeredChapterReveal> createState() => StaggeredChapterRevealState();
}

class StaggeredChapterRevealState extends State<StaggeredChapterReveal>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (_) => AnimationController(vsync: this, duration: OmoweMotion.quick),
    );
    _play();
  }

  void _play() {
    for (var i = 0; i < _controllers.length; i++) {
      final delay = OmoweMotion.titleLead + OmoweMotion.lineStagger * i;
      Future.delayed(delay, () {
        if (mounted) _controllers[i].forward(from: 0);
      });
    }
  }

  /// Resets and replays the entrance.
  void replay() {
    for (final c in _controllers) {
      c.reset();
    }
    _play();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widget.children.length; i++)
          AnimatedBuilder(
            animation: _controllers[i],
            builder: (context, child) {
              final t = CurvedAnimation(
                parent: _controllers[i],
                curve: OmoweMotion.easeRead,
              ).value;
              return Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, (1 - t) * 8),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: widget.children[i],
            ),
          ),
      ],
    );
  }
}
