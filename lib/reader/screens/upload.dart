import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../catalog/back_button.dart';
import '../../catalog/dropzone.dart';
import '../../catalog/pill_button.dart';
import '../../catalog/upload_item_row.dart';
import '../../models/book.dart';
import '../../models/chunk.dart';
import '../../theme/omowe_colors.dart';
import '../../theme/omowe_typography.dart';
import '../view_model.dart/upload_view_model.dart';

import 'book_detail_screen.dart';

/// "recently added" list, since [UploadViewModel] only tracks a
/// single in-flight upload (`AsyncValue<Book?>`, not a list).
///
/// Decisions made here that weren't spec — flagged, not silent:
///
/// - No `UploadState.transferring` is ever shown. `uploadPdf()` has
///   no byte-level progress callback, only a loading boolean, so the
///   row goes straight from nothing to `processing` (spinner) to
///   `ready`. Add a progress stream later if chunked upload progress
///   becomes available.
/// - The filename shown while uploading isn't part of the view
///   model's state (`uploadPdf` takes raw bytes, not a `PlatformFile`)
///   — it's captured as local screen state at pick-time, purely for
///   display.
/// - `AsyncError` doesn't try to fit into [UploadItemRow]'s state
///   enum (no error variant exists there) — it renders as a separate
///   inline message instead.
/// - After success, nothing auto-navigates or auto-resets — the
///   "ready" row stays until the user taps "Upload another," which
///   calls `reset()`.
/// - This screen imports processed JSON so the long-running backend pipeline
///   can be run separately and the app can read the result offline.
class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  String? _pickedFileName;

  Future<void> _pickAndImport() async {
    try {
      final result = await FilePicker.pickFiles(type: FileType.any);
      final file = result.isEmpty ? null : result.single;
      if (file == null) return;

      final bytes = await file.xFile.readAsBytes();
      if (bytes.isEmpty) {
        throw const FormatException('The selected JSON file was empty');
      }

      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is! Map && decoded is! List) {
        throw const FormatException('The JSON root must be an object or list');
      }
      final book = decoded is Map
          ? _bookFromEnvelope(Map<String, dynamic>.from(decoded))
          : _bookFromJson(decoded);
      if (book.chunks.isEmpty) {
        throw const FormatException('The JSON contains no readable chapters');
      }

      debugPrint('Importing ${file.name} (${bytes.length} bytes)');
      setState(() => _pickedFileName = file.name);
      await ref.read(uploadViewModelProvider.notifier).importBook(book);
    } catch (error, stackTrace) {
      debugPrint('Upload setup failed: $error\n$stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not import that JSON: $error')),
      );
    }
  }

  Book _bookFromEnvelope(Map<String, dynamic> envelope) {
    if (envelope['ok'] == false) {
      throw FormatException(envelope['error']?.toString() ?? 'Import failed');
    }
    return _bookFromJson(envelope['result'] ?? envelope);
  }

  Book _bookFromJson(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final nestedBook = map['book'];
      if (nestedBook is Map) return _bookFromJson(nestedBook);
      if (map['chunks'] is List) return Book.fromJson(map);

      final chunks = _chunksFrom(value);
      return Book(
        id:
            map['id']?.toString() ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        title:
            map['title']?.toString() ??
            map['book_title']?.toString() ??
            'Imported book',
        chunks: chunks,
      );
    }
    if (value is List) {
      return Book(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: 'Imported book',
        chunks: _chunksFrom(value),
      );
    }
    throw const FormatException('The JSON must contain a book or chapter list');
  }

  List<Chunk> _chunksFrom(dynamic value, {String? chapterTitle}) {
    if (value is String && value.trim().isNotEmpty) {
      return [Chunk(title: chapterTitle ?? 'Untitled chapter', content: value)];
    }
    if (value is List) {
      return value
          .expand((item) => _chunksFrom(item, chapterTitle: chapterTitle))
          .toList();
    }
    if (value is! Map) return const [];

    final map = Map<String, dynamic>.from(value);
    final title =
        map['title']?.toString() ??
        map['chapter_title']?.toString() ??
        map['chapter']?.toString() ??
        map['name']?.toString() ??
        chapterTitle;
    final content =
        map['content'] ??
        map['markdown'] ??
        map['markdown_content'] ??
        map['content_markdown'] ??
        map['processed_content'] ??
        map['text'] ??
        map['body'] ??
        map['piece'] ??
        map['piece_content'];
    if (content != null && content.toString().trim().isNotEmpty) {
      return [
        Chunk(title: title ?? 'Untitled chapter', content: content.toString()),
      ];
    }

    for (final key in const [
      'chunks',
      'pieces',
      'reader_pieces',
      'processed_pieces',
      'chapters',
      'processed_chapters',
      'sections',
      'data',
      'output',
    ]) {
      final nested = map[key];
      if (nested is List) {
        return _chunksFrom(nested, chapterTitle: title);
      }
    }
    return const [];
  }

  void _reset() {
    setState(() => _pickedFileName = null);
    ref.read(uploadViewModelProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadViewModelProvider);

    return Scaffold(
      backgroundColor: OmoweColors.stone50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              OmoweBackButton(onPressed: widget.onBack),
              const SizedBox(height: 20),
              uploadState.when(
                data: (book) => book == null
                    ? _IdleUploadArea(onTap: _pickAndImport)
                    : _SuccessArea(
                        bookId: book.id,
                        title: book.title,
                        onUploadAnother: _reset,
                      ),
                loading: () => UploadItemRow(
                  title: _pickedFileName ?? 'Uploading…',
                  state: UploadState.processing,
                  subtitle: 'Importing chapters…',
                ),
                error: (e, st) => _ErrorArea(
                  message: _friendlyErrorMessage(e),
                  onRetry: _reset,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _friendlyErrorMessage(Object error) {
    if (error is FormatException) {
      final message = error.message.toLowerCase();
      if (message.contains('empty')) {
        return 'That file is empty. Choose a processed book JSON file.';
      }
      if (message.contains('json')) {
        return 'That file is not a supported book JSON format.';
      }
      if (message.contains('chapter')) {
        return 'We could not find any readable chapters in that file.';
      }
    }
    return 'We could not import that book. Please try another processed JSON file.';
  }
}

class _IdleUploadArea extends StatelessWidget {
  const _IdleUploadArea({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropZone(onTap: onTap),
        const SizedBox(height: 16),
        OmowePillButton(label: 'Choose JSON', onPressed: onTap),
      ],
    );
  }
}

class _SuccessArea extends StatelessWidget {
  const _SuccessArea({
    required this.bookId,
    required this.title,
    required this.onUploadAnother,
  });

  final String bookId;
  final String title;
  final VoidCallback onUploadAnother;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => BookScreen(bookId: bookId))),
          child: UploadItemRow(
            title: title,
            state: UploadState.ready,
            subtitle: 'Ready to read',
          ),
        ),
        const SizedBox(height: 16),
        OmowePillButton(
          label: 'Open book',
          icon: Icons.arrow_forward,
          variant: OmowePillVariant.sage,
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => BookScreen(bookId: bookId))),
        ),
        const SizedBox(height: 10),
        OmowePillButton(label: 'Upload another', onPressed: onUploadAnother),
      ],
    );
  }
}

class _ErrorArea extends StatelessWidget {
  const _ErrorArea({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Couldn't process that file.", style: OmoweTypography.uiBody),
        const SizedBox(height: 6),
        Text(message, style: OmoweTypography.uiCaption),
        const SizedBox(height: 12),
        OmowePillButton(label: 'Try again', onPressed: onRetry),
      ],
    );
  }
}
