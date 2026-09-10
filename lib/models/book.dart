// book.dart
import 'chunk.dart';

class Book {
  final String id;
  final String title;
  final bool active;
  final List<Chunk> chunks;

  Book({this.active = true, required this.id, required this.title, required this.chunks});

  // Book(id: 'book1', title: 'Dart Basics', chunks: [Chunk(title: 'Intro', content: '...')]).toJson()
  // → {'id': 'book1', 'title': 'Dart Basics', 'chunks': [{'title': 'Intro', 'content': '...'}]}
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'active': active,
    'chunks': chunks.map((c) => c.toJson()).toList(),
  };

  // Book.fromJson({'id': 'book1', 'title': 'Dart Basics', 'active': true, 'chunks': [{'title': 'Intro', 'content': '...'}]})
  // → Book(id: 'book1', title: 'Dart Basics', active: true, chunks: [Chunk(title: 'Intro', content: '...')])
  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json['id'],
    title: json['title'],
    active: true,
    chunks: (json['chunks'] as List)
        .map((c) => Chunk.fromJson(Map<String, dynamic>.from(c)))
        .toList(),
  );
}

// Lightest view of a Book — for the library list.
// No chunk titles, no content, just enough to render a card.
class BookSummary {
  final String id;
  final String title;
  final int unreadChunkCount;

  BookSummary({
    required this.id,
    required this.title,
    required this.unreadChunkCount,
  });

  // BookSummary.fromBook(Book(id: 'b1', title: 'Dart Basics', chunks: [read, unread, unread]))
  // → BookSummary(id: 'b1', title: 'Dart Basics', unreadChunkCount: 2)
  factory BookSummary.fromBook(Book book) => BookSummary(
    id: book.id,
    title: book.title,
    unreadChunkCount: book.chunks.where((c) => !c.isRead).length,
  );
}

// Mid-weight view of a Book — for the book detail page.
// Chunk titles + read state, but not full chunk content.
class BookDetail {
  final String id;
  final String title;
  final List<ChunkSummary> chunks;

  BookDetail({required this.id, required this.title, required this.chunks});

  // BookDetail.fromBook(Book(id: 'b1', title: 'Dart Basics', chunks: [Chunk(title: 'Intro', isRead: true, ...)]))
  // → BookDetail(id: 'b1', title: 'Dart Basics', chunks: [ChunkSummary(index: 0, title: 'Intro', isRead: true)])
  factory BookDetail.fromBook(Book book) => BookDetail(
    id: book.id,
    title: book.title,
    chunks: [
      for (var i = 0; i < book.chunks.length; i++)
        ChunkSummary.fromChunk(i, book.chunks[i]),
    ],
  );
}
