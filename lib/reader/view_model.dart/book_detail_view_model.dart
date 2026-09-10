// book_detail_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/book.dart';
import '../../app_providers.dart';

part 'view_model_generated/book_detail_view_model.g.dart';

// Backs the book detail page (chapter list). Parameterized by bookId —
// riverpod_generator turns the extra build() argument into a "family"
// provider automatically, no manual .family wiring needed.
//
// In the widget:
//   final detailAsync = ref.watch(bookDetailViewModelProvider(bookId));
//   detailAsync.when(data: (detail) => ..., loading: () => ..., error: (e, st) => ...)
@riverpod
class BookDetailViewModel extends _$BookDetailViewModel {
  @override
  Future<BookDetail?> build(String bookId) async {
    final repo = ref.watch(fileProcessingRepositoryProvider);
    return repo.getBookDetail(bookId);
  }

  // call after returning from the chunk reader, so isRead states refresh
  // ref.read(bookDetailViewModelProvider(bookId).notifier).refresh()
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
