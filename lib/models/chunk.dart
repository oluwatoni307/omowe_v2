class Chunk {
  final String title;
  final String content;
  final String? aiExplanation;
  final bool isRead;
  final DateTime? completedAt;

  Chunk({
    required this.title,
    required this.content,
    this.aiExplanation,
    this.isRead = false,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'aiExplanation': aiExplanation,
    'isRead': isRead,
    'completedAt': completedAt?.toIso8601String(),
  };

  factory Chunk.fromJson(Map<String, dynamic> json) => Chunk(
    title: json['title'],
    content: json['content'],
    aiExplanation: json['aiExplanation'],
    isRead: json['isRead'] ?? false,
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'])
        : null,
  );

  Chunk markAsRead() => Chunk(
    title: title,
    content: content,
    aiExplanation: aiExplanation,
    isRead: true,
    completedAt: DateTime.now(),
  );
}

// A lighter view of Chunk — title + read state only, no content.
// Used inside BookDetail so the book page can list chapters without
// loading every chunk's full markdown body.
class ChunkSummary {
  final int index;
  final String title;
  final bool isRead;

  ChunkSummary({
    required this.index,
    required this.title,
    required this.isRead,
  });

  // ChunkSummary.fromChunk(0, Chunk(title: 'Intro', isRead: true, ...))
  // → ChunkSummary(index: 0, title: 'Intro', isRead: true)
  factory ChunkSummary.fromChunk(int index, Chunk chunk) =>
      ChunkSummary(index: index, title: chunk.title, isRead: chunk.isRead);
}
