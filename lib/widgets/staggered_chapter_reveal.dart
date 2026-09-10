import 'package:flutter/material.dart';
import '../theme/omowe_motion.dart';

/// The signature moment: an eyebrow, then a title 40ms behind it, then each
/// following line staggered by 80ms. Content fades up 8px — arrival, not a
/// page being dragged past. Used for chapter transitions.
class StaggeredChapterReveal extends StatefulWidget {
  const StaggeredChapterReveal({super.key, required this.children});

  final List<Widget> children;

  @override
  State<StaggeredChapterReveal> createState() =>
      StaggeredChapterRevealState();
}

class StaggeredChapterRevealState extends State<StaggeredChapterReveal>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (_) => AnimationController(vsync: this, duration: OmoweMotion.deliberate),
    );
    _play();
  }

  void _play() {
    for (var i = 0; i < _controllers.length; i++) {
      final delay = i == 0
          ? Duration.zero
          : OmoweMotion.titleLead + (OmoweMotion.lineStagger * i);
      Future.delayed(delay, () {
        if (mounted) _controllers[i].forward(from: 0);
      });
    }
  }

  /// Re-trigger the reveal — wire this to a "Replay" affordance if one is
  /// shown, as in the web system's demo.
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
      children: List.generate(widget.children.length, (i) {
        final controller = _controllers[i];
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final curved =
                CurvedAnimation(parent: controller, curve: OmoweMotion.easeRead);
            return Opacity(
              opacity: curved.value,
              child: Transform.translate(
                offset: Offset(0, 8 * (1 - curved.value)),
                child: child,
              ),
            );
          },
          child: widget.children[i],
        );
      }),
    );
  }
}
