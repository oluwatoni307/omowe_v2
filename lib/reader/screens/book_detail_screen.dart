import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../catalog/back_button.dart';
import '../../catalog/book_header.dart';
import '../../catalog/book_progress_row.dart';
import '../../catalog/chapter_row.dart';
import '../../catalog/resume_pill_button.dart';
import '../../models/book.dart';
import '../../theme/omowe_colors.dart';
import '../../theme/omowe_typography.dart';
import '../view_model.dart/book_detail_view_model.dart';
import '../view_model.dart/home_view_model.dart';
import 'book_tint.dart';
import 'reading_screen.dart';

/// Book screen (chapter list). Wired to [bookDetailViewModelProvider]
/// (family, keyed on [bookId]) for the chapter data, and cross-checks
/// [homeViewModelProvider] to know which chapter — if any — is
/// "current."
class BookScreen extends ConsumerWidget {
  const BookScreen({
    super.key,
    required this.bookId,
    this.onOpenChunk,
    this.onBack,
  });

  final String bookId;

  /// (bookId, chunkIndex)
  final void Function(String bookId, int chunkIndex)? onOpenChunk;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: OmoweColors.stone50,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _confirmDelete(context, ref),
        icon: const Icon(Icons.delete_outline),
        label: const Text('Delete book'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              OmoweBackButton(onPressed: onBack),
              const SizedBox(height: 8),
              Expanded(
                child: _BookBody(bookId: bookId, onOpenChunk: onOpenChunk),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete book?'),
        content: const Text(
          'This will remove the book and all of its chapters from your library.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) return;

    try {
      await ref.read(bookDetailViewModelProvider(bookId).notifier).deleteBook();
      if (context.mounted) Navigator.of(context).pop();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not delete this book.')),
        );
      }
    }
  }
}

class _BookBody extends ConsumerWidget {
  const _BookBody({required this.bookId, this.onOpenChunk});

  final String bookId;
  final void Function(String bookId, int chunkIndex)? onOpenChunk;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(bookDetailViewModelProvider(bookId));

    final continueInfo = ref
        .watch(homeViewModelProvider)
        .maybeWhen(data: (info) => info, orElse: () => null);

    final currentChunkIndex =
        (continueInfo != null && continueInfo.bookId == bookId)
        ? continueInfo.chunkIndex
        : null;

    return detailAsync.when(
      data: (detail) {
        if (detail == null) {
          return Center(
            child: Text(
              "Couldn't find that book.",
              style: OmoweTypography.uiCaption,
            ),
          );
        }

        final readCount = detail.chunks.where((c) => c.isRead).length;

        if (detail.chunks.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showEditTitleDialog(context, ref, detail.title),
                child: BookHeader(
                  title: detail.title,
                  chunkCount: 0,
                  tintIndex: tintIndexForBookId(detail.id),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'No chapters yet.',
                    style: OmoweTypography.uiCaption,
                  ),
                ),
              ),
            ],
          );
        }

        final resumeIndex = _resumeIndex(detail, currentChunkIndex);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showEditTitleDialog(context, ref, detail.title),
              child: BookHeader(
                title: detail.title,
                chunkCount: detail.chunks.length,
                tintIndex: tintIndexForBookId(detail.id),
              ),
            ),
            const SizedBox(height: 14),
            BookProgressRow(
              readCount: readCount,
              totalCount: detail.chunks.length,
            ),
            const SizedBox(height: 14),
            ResumePillButton(
              label: 'Continue reading',
              onPressed: () {
                onOpenChunk?.call(bookId, resumeIndex);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ReadingScreen(bookId: bookId, chunkIndex: resumeIndex),
                  ),
                );
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: detail.chunks.length,
                itemBuilder: (context, index) {
                  final chunk = detail.chunks[index];
                  final state = chunk.isRead
                      ? ChapterState.read
                      : (chunk.index == currentChunkIndex
                            ? ChapterState.current
                            : ChapterState.unread);

                  return ChapterRow(
                    number: chunk.index + 1,
                    title: chunk.title,
                    state: state,
                    onTap: () {
                      onOpenChunk?.call(bookId, chunk.index);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ReadingScreen(
                            bookId: bookId,
                            chunkIndex: chunk.index,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Text(
          "Couldn't load this book.",
          style: OmoweTypography.uiCaption,
        ),
      ),
    );
  }

  Future<void> _showEditTitleDialog(
    BuildContext context,
    WidgetRef ref,
    String currentTitle,
  ) async {
    final controller = TextEditingController(text: currentTitle);

    final newTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Book Title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Enter new title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newTitle != null &&
        newTitle.isNotEmpty &&
        newTitle != currentTitle &&
        context.mounted) {
      try {
        await ref
            .read(bookDetailViewModelProvider(bookId).notifier)
            .updateTitle(newTitle);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not update title.')),
          );
        }
      }
    }
  }

  int _resumeIndex(BookDetail detail, int? currentChunkIndex) {
    if (currentChunkIndex != null) return currentChunkIndex;
    final firstUnread = detail.chunks.indexWhere((c) => !c.isRead);
    return firstUnread == -1 ? 0 : firstUnread;
  }
}
