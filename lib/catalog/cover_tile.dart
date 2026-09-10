import 'package:flutter/material.dart';
import '../theme/omowe_typography.dart';
import 'book_cover.dart';

/// A single library grid tile — [BookCover] plus the "X unread"
/// caption underneath. Takes an already-computed unread count, not a
/// [Book] or [BookSummary] — the screen derives that before calling
/// this.
class LibraryCoverTile extends StatelessWidget {
  const LibraryCoverTile({
    super.key,
    required this.title,
    required this.unreadCount,
    required this.tintIndex,
  });

  final String title;
  final int unreadCount;
  final int tintIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BookCover(title: title, tintIndex: tintIndex),
        const SizedBox(height: 5),
        Text('$unreadCount unread', style: OmoweTypography.uiMicro),
      ],
    );
  }
}
