import 'storageService.dart';

// In-memory only — data is gone when the process ends.
// Same put/get/getAll/delete/clear behavior as HiveStorageService,
// just backed by a Map instead of disk. Good for quick scripts and tests.
class FakeStorageService implements StorageService {
  final Map<String, Map<String, Map<String, dynamic>>> _data = {};

  @override
  Future<void> put(String box, String key, Map<String, dynamic> value) async {
    _data.putIfAbsent(box, () => {});
    _data[box]![key] = value;
  }

  @override
  Future<Map<String, dynamic>?> get(String box, String key) async {
    return _data[box]?[key];
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(String box) async {
    return _data[box]?.values.toList() ?? [];
  }

  @override
  Future<void> delete(String box, String key) async {
    _data[box]?.remove(key);
  }

  @override
  Future<void> clear(String box) async {
    _data[box]?.clear();
  }
}
