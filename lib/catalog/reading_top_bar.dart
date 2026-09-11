import 'package:flutter/material.dart';
import 'back_button.dart';
import 'thin_progress_bar.dart';

/// Back button + the mini progress bar variant, on the Reading screen.
class ReadingTopBar extends StatelessWidget {
  const ReadingTopBar({super.key, required this.progress, this.onBack});

  /// 0.0–1.0. Progress through the current chunk.
  final double progress;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OmoweBackButton(onPressed: onBack),
        const SizedBox(width: 14),
        Expanded(child: ThinProgressBar(value: progress)),
      ],
    );
  }
}
