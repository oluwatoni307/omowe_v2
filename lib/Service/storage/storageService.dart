abstract class StorageService {
  // put('books', 'book1', {'title': 'Dart Basics'}) → saved, nothing returned
  Future<void> put(String box, String key, Map<String, dynamic> value);

  // get('books', 'book1')  → {'title': 'Dart Basics'}
  // get('books', 'book404') → null
  Future<Map<String, dynamic>?> get(String box, String key);

  // getAll('books') → [{'title': 'Dart Basics'}, {'title': 'Intro to Flutter'}]
  // getAll('empty_box') → []
  Future<List<Map<String, dynamic>>> getAll(String box);

  // delete('books', 'book1') → removed
  // get('books', 'book1') afterwards → null
  Future<void> delete(String box, String key);

  // clear('books') → every key in 'books' removed
  Future<void> clear(String box);
}