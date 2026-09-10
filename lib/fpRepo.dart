// file_processing_repository.dart
import 'dart:typed_data';
import '../models/book.dart';
import '../models/chunk.dart';
import 'Service/ingest/ingestService.dart';
import 'Service/storage/storageService.dart';
import 'models/book_util.dart';

// Combines IngestService (talks to backend) + StorageService (saves locally).
// Neither service knows about the other — this is the only place that does.
class FileProcessingRepository {
  final IngestService ingestService;
  final StorageService storageService;

  FileProcessingRepository({
    required this.ingestService,
    required this.storageService,
  });

  // processPdf(pdfBytes)
  //   1. sends bytes to backend  → Book(id: 'b1', title: 'Dart Basics', chunks: [...])
  //   2. saves it under box 'books', key 'b1'
  //   3. returns the same Book, ready to display
  Future<Book> processPdf(Uint8List pdfBytes) async {
    final book = await ingestService.ingest(pdfBytes);
    await storageService.put('books', book.id, book.toJson());
    return book;
  }

  // getBook('b1') → Book(id: 'b1', title: 'Dart Basics', chunks: [...])
  // getBook('missing') → null
  Future<Book?> getBook(String id) async {
    final json = await storageService.get('books', id);
    if (json == null) return null;
    return Book.fromJson(json);
  }

  // getAllBooks() → [Book(...), Book(...)]
  Future<List<Book>> getAllBooks() async {
    final all = await storageService.getAll('books');
    return all.map((json) => Book.fromJson(json)).toList();
  }

  // markChunkRead('b1', 1)
  //   before: book.chunks[1] = Chunk(title: 'Ch 1', isRead: false, completedAt: null)
  //   after:  book.chunks[1] = Chunk(title: 'Ch 1', isRead: true, completedAt: DateTime.now())
  // whole book re-saved (storage only knows whole-book records, see StorageService)
  // → returns the updated Book, or null if bookId doesn't exist
  Future<Book?> markChunkRead(String bookId, int chunkIndex) async {
    final book = await getBook(bookId);
    if (book == null) return null;
    if (chunkIndex < 0 || chunkIndex >= book.chunks.length) return null;

    final updatedChunks = [...book.chunks];
    updatedChunks[chunkIndex] = updatedChunks[chunkIndex].markAsRead();

    final updatedBook = Book(
      id: book.id,
      title: book.title,
      chunks: updatedChunks,
    );

    await storageService.put('books', updatedBook.id, updatedBook.toJson());
    return updatedBook;
  }

  // getBookSummaries() → [BookSummary(id: 'b1', title: 'Dart Basics', unreadChunkCount: 2), ...]
  // for the library list — no chunk content loaded into the summary
  Future<List<BookSummary>> getBookSummaries() async {
    final books = await getAllBooks();
    return books.map((b) => BookSummary.fromBook(b)).toList();
  }

  // getBookDetail('b1') → BookDetail(id: 'b1', title: 'Dart Basics', chunks: [ChunkSummary(...), ...])
  // getBookDetail('missing') → null
  // for the book page — chunk titles + read state, no chunk content
  Future<BookDetail?> getBookDetail(String id) async {
    final book = await getBook(id);
    if (book == null) return null;
    return BookDetail.fromBook(book);
  }

  // getChunk('b1', 1) → Chunk(title: 'Chapter 1', content: '...', isRead: false)
  // getChunk('b1', 99) → null (index out of range)
  // getChunk('missing', 0) → null (book doesn't exist)
  // for the chunk reader screen — full content, only for the one chunk opened.
  // Auto-saves the opened chunk position to key-value storage.
  Future<Chunk?> getChunk(String bookId, int chunkIndex) async {
    final book = await getBook(bookId);
    if (book == null) return null;
    if (chunkIndex < 0 || chunkIndex >= book.chunks.length) return null;

    await saveLastReadPosition(bookId, chunkIndex);
    return book.chunks[chunkIndex];
  }

  // Saves the last accessed book & chunk indices to lightweight key-value storage
  Future<void> saveLastReadPosition(String bookId, int chunkIndex) async {
    await storageService.put('app_state', 'last_read', {
      'bookId': bookId,
      'chunkIndex': chunkIndex,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // getContinueReadingInfo() → ({bookId: 'b1', chunkIndex: 1})
  // getContinueReadingInfo() → null (if no previous reading session exists)
  // Returns only the identifiers for the last opened location
  Future<ContinueReadingInfo?> getContinueReadingInfo() async {
    final state = await storageService.get('app_state', 'last_read');
    if (state == null) return null;

    final bookId = state['bookId'] as String?;
    final chunkIndex = state['chunkIndex'] as int?;
    if (bookId == null || chunkIndex == null) return null;

    final book = await getBook(bookId);
    if (book == null) return null;
    if (chunkIndex < 0 || chunkIndex >= book.chunks.length) return null;

    final chunk = book.chunks[chunkIndex];
    final remaining = book.chunks.length - 1 - chunkIndex;

    return (
      bookId: book.id,
      bookTitle: book.title,
      chunkIndex: chunkIndex,
      chunkTitle: chunk.title,
      chunksLeft: remaining < 0 ? 0 : remaining,
    );
  }
}
