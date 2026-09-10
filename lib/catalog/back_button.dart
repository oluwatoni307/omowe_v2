import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_icon_sizes.dart';

/// The back chevron used in Book, Reading, and Upload chrome.
///
/// Visual icon size is fixed to [OmoweIconSizes.chrome]; the tap
/// target is padded out to a comfortable touch size independent of
/// that, so the small chrome icon doesn't shrink the hit area with it.
class OmoweBackButton extends StatelessWidget {
  const OmoweBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.maybePop(context),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      splashRadius: 22,
      icon: const CustomPaint(
        size: Size.square(OmoweIconSizes.chrome),
        painter: _ChevronPainter(color: OmoweColors.ink900),
      ),
    );
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Path traced from the source mockup's 24x24 viewBox chevron
    // (M15 5 L8 12 L15 19), scaled to this painter's actual size.
    final scale = size.width / 24;
    final path = Path()
      ..moveTo(15 * scale, 5 * scale)
      ..lineTo(8 * scale, 12 * scale)
      ..lineTo(15 * scale, 19 * scale);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChevronPainter oldDelegate) =>
      oldDelegate.color != color;
}
