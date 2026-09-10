import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omowe_v2/catalog/library_top_bar.dart' show LibraryTopBar;
import '../../catalog/continue_reading_hero.dart';
import '../../catalog/cover_tile.dart';
import '../../catalog/pill_button.dart';
import '../../catalog/section_header.dart';
import '../../theme/omowe_colors.dart';
import '../../theme/omowe_typography.dart';
import '../view_model.dart/home_view_model.dart';
import '../view_model.dart/library_view_model.dart';

import 'book_detail_screen.dart';
import 'book_tint.dart';
import 'reading_screen.dart';
import 'upload.dart';

/// Library screen. Wired to Riverpod view models, not constructor
/// data — [homeViewModelProvider] backs the continue-reading hero,
/// [libraryViewModelProvider] backs the grid.
///
/// The two are watched by separate sub-widgets, each with its own
/// `AsyncValue.when`, rather than one nested `.when` for the whole
/// screen: they load independently, and one erroring shouldn't take
/// the other down with it (a failed hero shouldn't blank the grid).
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key, this.onOpenBook, this.onSearch, this.onAdd});

  /// Optional hook fired alongside navigation (e.g. analytics) — the
  /// screen itself pushes [BookScreen] regardless of whether this is
  /// provided.
  final ValueChanged<String>? onOpenBook; // bookId
  /// Optional hook fired alongside navigation to search — no default
  /// search screen exists yet, so this stays a no-op if unset.
  final VoidCallback? onSearch;

  /// Optional hook fired alongside navigation — pushes [UploadScreen]
  /// regardless of whether this is provided, same as the empty-state
  /// CTA below.
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OmoweColors.stone50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              LibraryTopBar(
                onSearch: onSearch,
                onAdd: () {
                  onAdd?.call();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const UploadScreen()),
                  );
                },
              ),
              _ContinueReadingSection(onOpenBook: onOpenBook),
              const _LibraryHeader(),
              const SizedBox(height: 13),
              Expanded(child: _LibraryGrid(onOpenBook: onOpenBook)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueReadingSection extends ConsumerWidget {
  const _ContinueReadingSection({this.onOpenBook});

  final ValueChanged<String>? onOpenBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continueAsync = ref.watch(homeViewModelProvider);

    return continueAsync.when(
      data: (info) {
        if (info == null) return const SizedBox(height: 24);
        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 20),
          child: ContinueReadingHero(
            bookTitle: info.bookTitle,
            chunkTitle: info.chunkTitle,
            chunksLeft: info.chunksLeft,
            tintIndex: tintIndexForBookId(info.bookId),
            onResume: () {
              onOpenBook?.call(info.bookId);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ReadingScreen(
                    bookId: info.bookId,
                    chunkIndex: info.chunkIndex,
                  ),
                ),
              );
            },
          ),
        );
      },
      // A quiet placeholder the same rough height as the hero, not a
      // spinner — keeps the library grid below from jumping once
      // this resolves.
      loading: () => const SizedBox(height: 24 + 120 + 20),
      // The hero is a nice-to-have, not essential — fail quietly
      // rather than show an error where a card would be.
      error: (e, st) => const SizedBox(height: 24),
    );
  }
}

class _LibraryHeader extends ConsumerWidget {
  const _LibraryHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(libraryViewModelProvider);
    return SectionHeader(
      label: 'Library',
      trailing: booksAsync.maybeWhen(
        data: (books) => '${books.length} books',
        orElse: () => null,
      ),
    );
  }
}

class _LibraryGrid extends ConsumerWidget {
  const _LibraryGrid({this.onOpenBook});

  final ValueChanged<String>? onOpenBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(libraryViewModelProvider);

    return booksAsync.when(
      data: (books) {
        if (books.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your library is empty.',
                    style: OmoweTypography.uiCaption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OmowePillButton(
                    label: 'Upload your first book',
                    expand: false,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const UploadScreen()),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 22),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 12,
            // Cover (6:7) plus the caption line beneath it — eyeballed,
            // tune once real covers are on screen.
            childAspectRatio: 0.78,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return GestureDetector(
              onTap: () {
                onOpenBook?.call(book.id);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BookScreen(bookId: book.id),
                  ),
                );
              },
              child: LibraryCoverTile(
                title: book.title,
                unreadCount: book.unreadChunkCount,
                tintIndex: tintIndexForBookId(book.id),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Text(
          "Couldn't load your library.",
          style: OmoweTypography.uiCaption,
        ),
      ),
    );
  }
}
