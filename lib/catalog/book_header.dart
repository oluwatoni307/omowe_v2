import 'package:flutter/material.dart';
import '../theme/omowe_typography.dart';
import 'book_cover.dart';

/// Cover + title/subtitle row on the Book screen. Cover shows no
/// title overlay here, since the title's already rendered as text
/// beside it.
class BookHeader extends StatelessWidget {
  const BookHeader({
    super.key,
    required this.title,
    required this.chunkCount,
    this.tintIndex = 0,
  });

  final String title;
  final int chunkCount;
  final int tintIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: BookCover(
            title: title,
            tintIndex: tintIndex,
            showTitle: false,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: OmoweTypography.displayOnDevice(size: 20)),
              const SizedBox(height: 4),
              Text('$chunkCount chapters', style: OmoweTypography.uiCaption),
            ],
          ),
        ),
      ],
    );
  }
}
