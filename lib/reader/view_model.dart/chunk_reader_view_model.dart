// chunk_reader_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/chunk.dart';
import '../../app_providers.dart';
import 'book_detail_view_model.dart';
import 'home_view_model.dart';
import 'library_view_model.dart';

part 'view_model_generated/chunk_reader_view_model.g.dart';

// Backs the chunk reader screen. Loads the full Chunk (with markdown
// content) for one bookId + chunkIndex, and exposes the action to
// mark it read once the user finishes.
//
// In the widget:
//   final chunkAsync = ref.watch(chunkReaderViewModelProvider(bookId, chunkIndex));
//   ...
//   ref.read(chunkReaderViewModelProvider(bookId, chunkIndex).notifier).markRead();
@riverpod
class ChunkReaderViewModel extends _$ChunkReaderViewModel {
  @override
  Future<Chunk?> build(String bookId, int chunkIndex) async {
    final repo = ref.watch(fileProcessingRepositoryProvider);
    return repo.getChunk(bookId, chunkIndex);
  }

  // markRead()
  //   1. tells the repository to mark this chunk read (updates isRead/completedAt, saves)
  //   2. refetches this chunk so the screen reflects isRead: true immediately
  Future<void> markRead() async {
    final repo = ref.read(fileProcessingRepositoryProvider);
    await repo.markChunkRead(bookId, chunkIndex);
    ref.invalidateSelf();
    ref.invalidate(bookDetailViewModelProvider(bookId));
    ref.invalidate(libraryViewModelProvider);
    ref.invalidate(homeViewModelProvider);
    await future;
  }
}
