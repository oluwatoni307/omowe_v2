// home_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../app_providers.dart';
import '../../models/book_util.dart';

part 'view_model_generated/home_view_model.g.dart';

// Type alias matching the repository's record output

// Backs the "continue reading" hero card on the library screen.
// Returns null when there's nothing to resume.
//
// In the widget:
//   final continueAsync = ref.watch(homeViewModelProvider);
//   continueAsync.when(
//     data: (info) => info == null ? const SizedBox.shrink() : ContinueCard(info),
//     loading: () => const CircularProgressIndicator(),
//     error: (e, st) => Text('Error: $e'),
//   )
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<ContinueReadingInfo?> build() async {
    final repo = ref.watch(fileProcessingRepositoryProvider);
    return repo.getContinueReadingInfo();
  }

  // Call after returning from the reader so the hero reflects new progress:
  // ref.read(homeViewModelProvider.notifier).refresh();
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
