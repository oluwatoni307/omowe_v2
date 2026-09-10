// app_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'Service/ingest/httpIngest.dart';
import 'Service/ingest/ingestService.dart';
import 'Service/storage/HiveStorage.dart';
import 'Service/storage/storageService.dart';
import 'fpRepo.dart';

part 'app_providers.g.dart';

// The ONLY place real implementations get chosen.
// Swap HiveStorageService()/HttpIngestService() for fakes here
// (e.g. in a test override) — nothing else in the app changes.

@riverpod
StorageService storageService(StorageServiceRef ref) {
  return HiveStorageService();
}

@riverpod
IngestService ingestService(IngestServiceRef ref) {
  return HttpIngestService();
}

@riverpod
FileProcessingRepository fileProcessingRepository(
  FileProcessingRepositoryRef ref,
) {
  return FileProcessingRepository(
    ingestService: ref.watch(ingestServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
}
