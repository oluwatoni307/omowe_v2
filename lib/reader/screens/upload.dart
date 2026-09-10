import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../catalog/back_button.dart';
import '../../catalog/dropzone.dart';
import '../../catalog/pill_button.dart';
import '../../catalog/upload_item_row.dart';
import '../../theme/omowe_colors.dart';
import '../../theme/omowe_typography.dart';
import '../view_model.dart/upload_view_model.dart';

import 'book_detail_screen.dart';

// Adjust to match your project structure.

/// Upload screen. One slot, one file at a time — no multi-row
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
/// - File picking is restricted to `.pdf`, since `uploadPdf()` only
///   accepts PDF bytes — [DropZone]'s "PDF or EPUB" copy is ahead of
///   what the pipeline actually supports today.
class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  static const _maxUploadBytes = 50 * 1024 * 1024;
  String? _pickedFileName;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    final file = result.isEmpty ? null : result.single;
    final bytes = file == null ? null : await file.xFile.readAsBytes();
    if (bytes == null || bytes.isEmpty) return;
    if (bytes.length > _maxUploadBytes) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a PDF smaller than 50 MB.')),
      );
      return;
    }

    setState(() => _pickedFileName = file!.name);
    await ref.read(uploadViewModelProvider.notifier).uploadPdf(bytes);
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              OmoweBackButton(onPressed: widget.onBack),
              const SizedBox(height: 20),
              uploadState.when(
                data: (book) => book == null
                    ? _IdleUploadArea(onTap: _pickAndUpload)
                    : _SuccessArea(
                        bookId: book.id,
                        title: book.title,
                        onUploadAnother: _reset,
                      ),
                loading: () => UploadItemRow(
                  title: _pickedFileName ?? 'Uploading…',
                  state: UploadState.processing,
                  subtitle: 'Preparing chapters…',
                ),
                error: (e, st) => _ErrorArea(onRetry: _reset),
              ),
            ],
          ),
        ),
      ),
    );
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
        OmowePillButton(label: 'Choose file', onPressed: onTap),
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
        OmowePillButton(label: 'Upload another', onPressed: onUploadAnother),
      ],
    );
  }
}

class _ErrorArea extends StatelessWidget {
  const _ErrorArea({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Couldn't process that file.", style: OmoweTypography.uiCaption),
        const SizedBox(height: 12),
        OmowePillButton(label: 'Try again', onPressed: onRetry),
      ],
    );
  }
}
