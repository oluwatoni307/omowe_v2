// upload_view_model.dart
import 'dart:async';
import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/book.dart';
import '../../app_providers.dart';

import 'library_view_model.dart';
import 'home_view_model.dart';

part 'view_model_generated/upload_view_model.g.dart';

// Backs the upload screen. Unlike the other viewModels, build() doesn't
// fetch anything — it starts idle (null) and only changes when uploadPdf()
// is called from a button tap.
//
// In the widget:
//   final uploadState = ref.watch(uploadViewModelProvider);
//   uploadState.when(
//     data: (book) => book == null ? PickFileButton() : SuccessView(book),
//     loading: () => ProgressIndicator(),
//     error: (e, st) => ErrorView(e),
//   )
//   ...
//   ref.read(uploadViewModelProvider.notifier).uploadPdf(pdfBytes);
@riverpod
class UploadViewModel extends _$UploadViewModel {
  @override
  FutureOr<Book?> build() => null; // idle — nothing uploaded yet this session

  // uploadPdf(bytes)
  //   1. sets state to loading (widget shows a spinner)
  //   2. sends bytes through the repository (ingest + save)
  //   3. on success: state becomes AsyncData(book), and the library/home
  //      viewModels are invalidated so the new book shows up there too
  //   4. on failure: state becomes AsyncError, caught by AsyncValue.guard —
  //      no try/catch needed here
  Future<void> uploadPdf(Uint8List pdfBytes) async {
    state = const AsyncLoading();
    final repo = ref.read(fileProcessingRepositoryProvider);

    state = await AsyncValue.guard(() => repo.processPdf(pdfBytes));

    if (state.hasValue) {
      ref.invalidate(libraryViewModelProvider);
      ref.invalidate(homeViewModelProvider);
    }
  }

  // reset() → back to idle, e.g. after showing a success message
  void reset() {
    state = const AsyncData(null);
  }
}
