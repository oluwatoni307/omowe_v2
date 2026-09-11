// ignore_for_file: duplicate_ignore, unused_element_parameter

import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_icon_sizes.dart';
import '../theme/omowe_typography.dart';

/// The upload screen's drop target. Dashed borders aren't a native
/// Flutter [Border] style, so the outline is hand-painted with a
/// [CustomPainter] tracing a dashed path around a rounded rect
/// (matching [OmoweShapes.cardShape]'s r10) — no external dependency.
class DropZone extends StatelessWidget {
  const DropZone({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: CustomPaint(
        painter: const _DashedBorderPainter(
          color: OmoweColors.stone300,
          radius: 10,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
          decoration: BoxDecoration(
            color: OmoweColors.paper100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.upload_rounded,
                size: OmoweIconSizes.dropzone,
                color: OmoweColors.sage600,
              ),
              const SizedBox(height: 9),
              Text(
                'Choose processed JSON',
                style: OmoweTypography.uiLabel.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 2),
              Text(
                'or browse your device',
                style: OmoweTypography.uiCaption.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                'Book JSON · read offline',
                style: OmoweTypography.uiMicro.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    // ignore: unused_element_parameter
    this.strokeWidth = 1.5,
    this.dashLength = 5,
    this.gapLength = 4,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashLength != dashLength ||
      oldDelegate.gapLength != gapLength;
}
