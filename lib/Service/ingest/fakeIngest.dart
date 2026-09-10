import 'dart:typed_data';

import '../../models/book.dart';
import '../../models/chunk.dart';
import 'ingestService.dart';

// Ignores pdfBytes entirely, always returns the same canned Book.
// Lets FileProcessingRepository be built and tested before the
// real multipart upload / backend endpoint exists.
class FakeIngestService implements IngestService {
  @override
  Future<Book> ingest(Uint8List pdfBytes) async {
    return Book(
      id: 'fake-book-1',
      title: 'Fake Book Title',
      chunks: [
        Chunk(
          title: 'Introduction',
          content: '# Introduction\n\nThis is a fake chunk for testing.',
        ),
        Chunk(
          title: 'Chapter 1',
          content: '# Chapter 1\n\nAnother fake chunk.',
        ),
      ],
    );
  }
}
