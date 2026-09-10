import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../catalog/reading_top_bar.dart';

import '../../models/chunk.dart';
import '../../theme/omowe_colors.dart';
import '../../theme/omowe_typography.dart';
// Adjust these to match your project structure.
import '../../widgets/staggered_chapter_reveal.dart';
import '../view_model.dart/chunk_reader_view_model.dart';

/// Reading screen. Wired to
/// `chunkReaderViewModelProvider(bookId, chunkIndex)`.
///
/// Two behaviors here are guesses, not spec — flagged in-line rather
/// than silently assumed:
///
/// 1. The mini progress bar in [ReadingTopBar] reflects scroll
///    position within this chunk, tracked locally via a
///    [ScrollController]. Nothing in [Chunk] models "progress within
///    a chunk" — this is ephemeral UI state, not business data, so
///    it isn't (and shouldn't be) persisted anywhere.
/// 2. `markRead()` fires once, the first time scroll position gets
///    within ~40px of the bottom. If the real trigger should be
///    different — an explicit "next chapter" tap, leaving the screen
///    regardless of scroll position, a time-on-screen threshold —
///    this needs to change.
class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({
    super.key,
    required this.bookId,
    required this.chunkIndex,
    this.onBack,
  });

  final String bookId;
  final int chunkIndex;
  final VoidCallback? onBack;

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  final _scrollController = ScrollController();
  double _progress = 0;
  bool _markedRead = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final position = _scrollController.position;
    final max = position.maxScrollExtent;
    final value = max == 0 ? 1.0 : (position.pixels / max).clamp(0.0, 1.0);

    if (value != _progress) {
      setState(() => _progress = value);
    }

    if (!_markedRead && position.extentAfter < 40) {
      _markedRead = true;
      ref
          .read(
            chunkReaderViewModelProvider(
              widget.bookId,
              widget.chunkIndex,
            ).notifier,
          )
          .markRead();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chunkAsync = ref.watch(
      chunkReaderViewModelProvider(widget.bookId, widget.chunkIndex),
    );

    return Scaffold(
      backgroundColor: OmoweColors.stone50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ReadingTopBar(progress: _progress, onBack: widget.onBack),
              const SizedBox(height: 10),
              Expanded(
                child: chunkAsync.when(
                  data: (chunk) {
                    if (chunk == null) {
                      return Center(
                        child: Text(
                          "Couldn't find that chapter.",
                          style: OmoweTypography.uiCaption,
                        ),
                      );
                    }
                    return _ChunkBody(
                      chunk: chunk,
                      chunkIndex: widget.chunkIndex,
                      scrollController: _scrollController,
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(
                    child: Text(
                      "Couldn't load this chapter.",
                      style: OmoweTypography.uiCaption,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChunkBody extends StatelessWidget {
  const _ChunkBody({
    required this.chunk,
    required this.chunkIndex,
    required this.scrollController,
  });

  final Chunk chunk;
  final int chunkIndex;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (chunk.content.trim().isEmpty) {
      return SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chapter ${chunkIndex + 1}', style: OmoweTypography.uiEyebrow),
            Text(chunk.title, style: OmoweTypography.displayOnDevice(size: 21)),
            const SizedBox(height: 18),
            Text(
              'This chapter has no content yet.',
              style: OmoweTypography.uiCaption,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      controller: scrollController,
      child: StaggeredChapterReveal(
        children: [
          Text('Chapter ${chunkIndex + 1}', style: OmoweTypography.uiEyebrow),
          Text(chunk.title, style: OmoweTypography.displayOnDevice(size: 21)),
          MarkdownBody(
            data: chunk.content,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                  p: OmoweTypography.readingBody,
                  h1: OmoweTypography.displayOnDevice(size: 24),
                  h2: OmoweTypography.displayOnDevice(size: 21),
                  h3: OmoweTypography.displayOnDevice(size: 18),
                ),
          ),
        ],
      ),
    );
  }
}
