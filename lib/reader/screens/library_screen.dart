import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omowe_v2/catalog/library_top_bar.dart' show LibraryTopBar;
import '../../catalog/continue_reading_hero.dart';
import '../../catalog/cover_tile.dart';
import '../../catalog/pill_button.dart';
import '../../catalog/section_header.dart';
import '../../theme/omowe_colors.dart';
import '../../theme/omowe_shapes.dart';
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
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 600 ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: OmoweColors.stone50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
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
        if (info == null) {
          return const Padding(
            padding: EdgeInsets.only(top: 18, bottom: 16),
            child: _ContinueReadingEmptyState(),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 16),
          child: ContinueReadingHero(
            bookTitle: info.bookTitle,
            chunkTitle: info.chunkTitle,
            chunksLeft: info.chunksLeft,
            onTap: () {
              onOpenBook?.call(info.bookId);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BookScreen(bookId: info.bookId),
                ),
              );
            },
            onResume: () {
              onOpenBook?.call(info.bookId);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ReadingScreen(
                    bookId: info.bookId,
                    chunkIndex: info.chunkIndex,
                    initialScrollOffset: info.scrollOffset,
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
      loading: () => const SizedBox(height: 18 + 120 + 16),
      // The hero is a nice-to-have, not essential — fail quietly
      // rather than show an error where a card would be.
      error: (e, st) => const SizedBox(height: 24),
    );
  }
}

class _ContinueReadingEmptyState extends StatelessWidget {
  const _ContinueReadingEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(17, 16, 17, 17),
      decoration: ShapeDecoration(
        color: OmoweColors.sageWash,
        shape: OmoweShapes.cardShape.copyWith(
          side: const BorderSide(color: OmoweColors.sage400),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('continue reading', style: OmoweTypography.uiEyebrow),
          const SizedBox(height: 7),
          Text(
            'Your next chapter will appear here.',
            style: OmoweTypography.displayOnDevice(size: 19),
          ),
          const SizedBox(height: 4),
          Text(
            'Open a book and start reading to pick up where you left off.',
            style: OmoweTypography.uiBody.copyWith(color: OmoweColors.ink500),
          ),
        ],
      ),
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
        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 700
                ? 4
                : constraints.maxWidth >= 520
                ? 3
                : 2;

            return GridView.builder(
              padding: const EdgeInsets.only(bottom: 22),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: crossAxisCount == 2 ? 1.12 : 1.18,
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
