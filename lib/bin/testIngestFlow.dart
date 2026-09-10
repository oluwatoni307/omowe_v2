// test_ingest_flow.dart
import 'dart:typed_data';

import '../Service/ingest/fakeIngest.dart';
import '../Service/storage/FakeStorage.dart';
import '../fpRepo.dart';

/// Run with: dart run bin/test_ingest_flow.dart
///
/// Proves the full pipeline (bytes → ingest → save → retrieve) works,
/// using fakes only — no real backend, no real Hive. Swap in
/// HttpIngestService + HiveStorageService later, nothing else changes.
void main() async {
  final repo = FileProcessingRepository(
    ingestService: FakeIngestService(),
    storageService: FakeStorageService(),
  );

  print('--- Processing a fake PDF ---');
  final fakePdfBytes = Uint8List.fromList([
    1,
    2,
    3,
  ]); // stand-in, FakeIngestService ignores it anyway
  final book = await repo.processPdf(fakePdfBytes);
  print('Book returned: ${book.title} (${book.chunks.length} chunks)');
  for (final chunk in book.chunks) {
    print(' - ${chunk.title}');
  }

  print('--- Retrieving the same book by id ---');
  final fetched = await repo.getBook(book.id);
  print('Fetched: ${fetched?.title}');

  print('--- Retrieving a book that does not exist ---');
  final missing = await repo.getBook('nope');
  print('Missing: $missing');

  print('--- Listing all books ---');
  final all = await repo.getAllBooks();
  print('Total books in storage: ${all.length}');

  print('--- Done ---');
}
