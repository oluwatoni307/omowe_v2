import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../catalog/reading_top_bar.dart';

import '../../models/chunk.dart';
import '../../theme/omowe_colors.dart';
import '../../theme/omowe_typography.dart';
// Adjust these to match your project structure.
import '../../widgets/staggered_chapter_reveal.dart';
import '../view_model.dart/book_detail_view_model.dart';
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
    this.initialScrollOffset = 0,
    this.onBack,
  });

  final String bookId;
  final int chunkIndex;
  final double initialScrollOffset;
  final VoidCallback? onBack;

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  final _scrollController = ScrollController();
  double _progress = 0;
  bool _markedRead = false;
  bool _showContinue = false;
  bool _isAdvancing = false;
  bool _restoredOffset = false;
  Timer? _saveOffsetTimer;

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

    final atEnd = position.extentAfter < 40;
    if (atEnd != _showContinue) {
      setState(() => _showContinue = atEnd);
    }

    if (!_markedRead && atEnd) {
      _markRead();
    }

    _saveOffsetTimer?.cancel();
    _saveOffsetTimer = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      ref
          .read(
            chunkReaderViewModelProvider(
              widget.bookId,
              widget.chunkIndex,
            ).notifier,
          )
          .saveScrollOffset(position.pixels);
    });
  }

  void _markRead() {
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

  Future<void> _continueToNextChunk() async {
    if (_isAdvancing) return;
    setState(() => _isAdvancing = true);
    if (!_markedRead) _markRead();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ReadingScreen(
          bookId: widget.bookId,
          chunkIndex: widget.chunkIndex + 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _saveOffsetTimer?.cancel();
    if (_scrollController.hasClients) {
      ref
          .read(
            chunkReaderViewModelProvider(
              widget.bookId,
              widget.chunkIndex,
            ).notifier,
          )
          .saveScrollOffset(_scrollController.position.pixels);
    }
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chunkAsync = ref.watch(
      chunkReaderViewModelProvider(widget.bookId, widget.chunkIndex),
    );
    final detailAsync = ref.watch(bookDetailViewModelProvider(widget.bookId));
    final hasNextChunk = detailAsync.maybeWhen(
      data: (book) =>
          book != null && widget.chunkIndex + 1 < book.chunks.length,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: OmoweColors.stone50,
      floatingActionButton: _showContinue && hasNextChunk
          ? FloatingActionButton.extended(
              onPressed: _isAdvancing ? null : _continueToNextChunk,
              label: const Text('Continue to next section'),
              icon: const Icon(Icons.arrow_forward),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && _scrollController.hasClients) {
                        if (!_restoredOffset) {
                          _restoredOffset = true;
                          final offset = widget.initialScrollOffset.clamp(
                            0.0,
                            _scrollController.position.maxScrollExtent,
                          );
                          if (offset > 0) _scrollController.jumpTo(offset);
                        }
                        _onScroll();
                      }
                    });
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
        padding: const EdgeInsets.only(bottom: 128),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chapter ${chunkIndex + 1}', style: OmoweTypography.uiEyebrow),
            const SizedBox(height: 12),
            Text(chunk.title, style: OmoweTypography.displayOnDevice(size: 23)),
            const SizedBox(height: 24),
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
      padding: const EdgeInsets.only(bottom: 128),
      child: StaggeredChapterReveal(
        children: [
          Text('Chapter ${chunkIndex + 1}', style: OmoweTypography.uiEyebrow),
          const SizedBox(height: 12),
          Text(chunk.title, style: OmoweTypography.displayOnDevice(size: 23)),
          const SizedBox(height: 24),
          MarkdownBody(
            data: chunk.content,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                  p: OmoweTypography.readingBody,
                  h1: OmoweTypography.displayOnDevice(size: 28),
                  h2: OmoweTypography.displayOnDevice(size: 25),
                  h3: OmoweTypography.displayOnDevice(size: 22),
                ),
          ),
        ],
      ),
    );
  }
}
