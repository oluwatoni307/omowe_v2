import 'package:flutter/material.dart';
import '../theme/omowe_typography.dart';
import 'thin_progress_bar.dart';

/// [ThinProgressBar] + its caption, on the Book screen.
///
/// Takes `readCount`/`totalCount` (plain ints) rather than a chunk
/// list — the 0–1 fill value is just arithmetic on those two numbers,
/// not a data derivation, so it's fine to compute here.
class BookProgressRow extends StatelessWidget {
  const BookProgressRow({
    super.key,
    required this.readCount,
    required this.totalCount,
  });

  final int readCount;
  final int totalCount;

  double get _value => totalCount == 0 ? 0 : readCount / totalCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThinProgressBar(value: _value),
        const SizedBox(height: 7),
        Text(
          '$readCount of $totalCount read',
          style: OmoweTypography.uiCaption.copyWith(
            fontFeatures: OmoweTypography.tabularFigures,
          ),
        ),
      ],
    );
  }
}
