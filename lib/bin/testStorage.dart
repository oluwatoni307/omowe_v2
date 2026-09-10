import '../Service/storage/FakeStorage.dart';
import '../Service/storage/storageService.dart';

/// Run with: dart run bin/test_storage.dart
///
/// This proves the StorageService contract works, with zero UI,
/// zero Hive setup, zero API calls. Swap FakeStorageService for
/// HiveStorageService later — nothing below this line would change.
void main() async {
  final StorageService storage = FakeStorageService();

  print('--- Saving two books ---');
  await storage.put('books', 'book1', {
    'id': 'book1',
    'title': 'Intro to Flutter',
    'chunkCount': 3,
  });
  await storage.put('books', 'book2', {
    'id': 'book2',
    'title': 'Dart Basics',
    'chunkCount': 5,
  });

  print('--- Saving chunks for book1 ---');
  await storage.put('chunks', 'c1', {
    'id': 'c1',
    'bookId': 'book1',
    'title': 'Chapter 1: Getting Started',
    'content': '# Getting Started\n\nWelcome to Flutter...',
  });
  await storage.put('chunks', 'c2', {
    'id': 'c2',
    'bookId': 'book1',
    'title': 'Chapter 2: Widgets',
    'content': '# Widgets\n\nEverything is a widget...',
  });

  print('--- Reading back one book ---');
  final book1 = await storage.get('books', 'book1');
  print(book1);

  print('--- Reading all books ---');
  final allBooks = await storage.getAll('books');
  for (final b in allBooks) {
    print(' - ${b['title']} (${b['chunkCount']} chunks)');
  }

  print('--- Reading all chunks and filtering for book1 ---');
  final allChunks = await storage.getAll('chunks');
  final book1Chunks = allChunks.where((c) => c['bookId'] == 'book1');
  for (final c in book1Chunks) {
    print(' - ${c['title']}');
  }

  print('--- Deleting book2 ---');
  await storage.delete('books', 'book2');
  final remaining = await storage.getAll('books');
  print('Remaining books: ${remaining.length}');

  print('--- Done ---');
}
