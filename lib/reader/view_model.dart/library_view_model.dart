// library_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/book.dart';
import '../../app_providers.dart';

part 'view_model_generated/library_view_model.g.dart';

// Backs the library screen. No manual isLoading/error fields —
// AsyncValue (via AsyncNotifier) carries loading/error/data automatically.
//
// In the widget:
//   final booksAsync = ref.watch(libraryViewModelProvider);
//   booksAsync.when(
//     data: (books) => ...,     // List<BookSummary>
//     loading: () => ...,
//     error: (e, st) => ...,
//   )
@riverpod
class LibraryViewModel extends _$LibraryViewModel {
  @override
  Future<List<BookSummary>> build() async {
    final repo = ref.watch(fileProcessingRepositoryProvider);
    return repo.getBookSummaries();
  }

  // call this after a new book is processed, or on pull-to-refresh
  // ref.read(libraryViewModelProvider.notifier).refresh()
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future; // waits for the rebuilt build() to finish
  }
}
