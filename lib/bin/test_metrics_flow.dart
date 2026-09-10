// test_metrics_flow.dart
import 'dart:typed_data';
import '../Service/ingest/fakeIngest.dart';
import '../Service/storage/FakeStorage.dart';
import '../book_metrics.dart';
import '../fpRepo.dart';

/// Run with: dart run bin/test_metrics_flow.dart
void main() async {
  final repo = FileProcessingRepository(
    ingestService: FakeIngestService(),
    storageService: FakeStorageService(),
  );

  final book = await repo.processPdf(Uint8List.fromList([1, 2, 3]));
  print('--- Before marking anything read ---');
  print('isBookComplete: ${isBookComplete(book)}');
  print('completionPercent: ${completionPercent(book)}');
  print('lastActivityAt: ${lastActivityAt(book)}');

  print('--- Marking chunk 0 as read ---');
  final afterFirst = await repo.markChunkRead(book.id, 0);
  print('isBookComplete: ${isBookComplete(afterFirst!)}');
  print('completionPercent: ${completionPercent(afterFirst)}');
  print('lastActivityAt: ${lastActivityAt(afterFirst)}');

  print('--- Marking chunk 1 as read ---');
  final afterSecond = await repo.markChunkRead(book.id, 1);
  print('isBookComplete: ${isBookComplete(afterSecond!)}');
  print('completionPercent: ${completionPercent(afterSecond)}');
  print('lastActivityAt: ${lastActivityAt(afterSecond)}');

  print('--- Done ---');
}
