import 'dart:typed_data';
import '../../models/book.dart';

abstract class IngestService {
  // ingest(pdfBytes) → Book(id: '...', title: 'Dart Basics', chunks: [Chunk(title: 'Intro', content: '...'), ...])
  // Sends raw PDF bytes to the backend (multipart), backend returns the whole book, already structured.
  Future<Book> ingest(Uint8List pdfBytes);
}
