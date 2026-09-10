// book_metrics.dart
import '../models/book.dart';

// Pure functions — no I/O, no services. Take a Book already in memory,
// return a derived number/date. Nothing here is stored; it's all computed
// fresh from Chunk.isRead / Chunk.completedAt every time it's called.

// isBookComplete(Book(chunks: [read, read])) → true
// isBookComplete(Book(chunks: [read, unread])) → false
bool isBookComplete(Book book) =>
    book.chunks.isNotEmpty && book.chunks.every((c) => c.isRead);

// completionPercent(Book(chunks: [read, unread, unread])) → 0.33
// completionPercent(Book(chunks: [])) → 0.0
double completionPercent(Book book) {
  if (book.chunks.isEmpty) return 0.0;
  final readCount = book.chunks.where((c) => c.isRead).length;
  return readCount / book.chunks.length;
}

// lastActivityAt(Book(chunks: [completedAt: Aug 28, completedAt: Aug 30])) → Aug 30
// lastActivityAt(Book(chunks: [unread, unread])) → null (nothing completed yet)
DateTime? lastActivityAt(Book book) {
  final completedDates = book.chunks
      .where((c) => c.completedAt != null)
      .map((c) => c.completedAt!);
  if (completedDates.isEmpty) return null;
  return completedDates.reduce((latest, t) => t.isAfter(latest) ? t : latest);
}
