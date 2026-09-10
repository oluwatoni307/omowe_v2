import 'package:hive/hive.dart';
import 'storageService.dart';

// Only file in the app allowed to import 'package:hive'.
class HiveStorageService implements StorageService {
  final Map<String, Box> _openBoxes = {};

  // _boxFor('books') first call  → opens Hive box from disk, caches it
  // _boxFor('books') second call → returns cached box, no disk hit
  Future<Box> _boxFor(String boxName) async {
    if (_openBoxes.containsKey(boxName)) return _openBoxes[boxName]!;
    final box = await Hive.openBox(boxName);
    _openBoxes[boxName] = box;
    return box;
  }

  @override
  // put('books', 'book1', {'title': 'Dart Basics'}) → written to disk via Hive
  Future<void> put(String box, String key, Map<String, dynamic> value) async {
    final b = await _boxFor(box);
    await b.put(key, value);
  }

  @override
  // get('books', 'book1') → {'title': 'Dart Basics'}
  // get('books', 'book404') → null
  Future<Map<String, dynamic>?> get(String box, String key) async {
    final b = await _boxFor(box);
    final raw = b.get(key);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map);
  }

  @override
  // getAll('books') → [{'title': 'Dart Basics'}, {'title': 'Intro to Flutter'}]
  Future<List<Map<String, dynamic>>> getAll(String box) async {
    final b = await _boxFor(box);
    return b.values
        .map((raw) => Map<String, dynamic>.from(raw as Map))
        .toList();
  }

  @override
  // delete('books', 'book1') → gone from disk
  Future<void> delete(String box, String key) async {
    final b = await _boxFor(box);
    await b.delete(key);
  }

  @override
  // clear('books') → box emptied, disk updated
  Future<void> clear(String box) async {
    final b = await _boxFor(box);
    await b.clear();
  }
}
