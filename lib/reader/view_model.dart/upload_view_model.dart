import 'dart:async';
import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/book.dart';
import '../../app_providers.dart';

import 'library_view_model.dart';
import 'home_view_model.dart';

part 'view_model_generated/upload_view_model.g.dart';

@riverpod
class UploadViewModel extends _$UploadViewModel {
  @override
  FutureOr<Book?> build() => null;

  Future<void> uploadPdf(Uint8List pdfBytes) async {
    state = const AsyncLoading();
    final repo = ref.read(fileProcessingRepositoryProvider);

    state = await AsyncValue.guard(() => repo.processPdf(pdfBytes));

    if (state.hasValue) {
      ref.invalidate(libraryViewModelProvider);
      ref.invalidate(homeViewModelProvider);
    }
  }

  Future<void> importBook(Book book) async {
    state = const AsyncLoading();
    final repo = ref.read(fileProcessingRepositoryProvider);

    state = await AsyncValue.guard(() => repo.importBook(book));

    if (state.hasValue) {
      ref.invalidate(libraryViewModelProvider);
      ref.invalidate(homeViewModelProvider);
    }
  }

  Future<void> updateTitle(String newTitle) async {
    final currentBook = state.value;
    if (currentBook == null) return;

    final repo = ref.read(fileProcessingRepositoryProvider);
    final updatedBook = await repo.updateBookTitle(currentBook.id, newTitle);

    if (updatedBook != null) {
      state = AsyncData(updatedBook);
      ref.invalidate(libraryViewModelProvider);
      ref.invalidate(homeViewModelProvider);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}
