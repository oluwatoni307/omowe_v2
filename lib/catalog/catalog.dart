import 'package:flutter/material.dart';
import '../theme/omowe_colors.dart';
import '../theme/omowe_typography.dart';
import '../widgets/resume_pill_button.dart';
import '../widgets/book_cover.dart';
import '../widgets/staggered_chapter_reveal.dart';
import 'back_button.dart';
import 'book_header.dart';
import 'book_progress_row.dart';
import 'catalog_widget.dart';
import 'catalog_fixtures.dart';
import 'chapter_row.dart';
import 'continue_reading_hero.dart';
import 'cover_tile.dart';
import 'dropzone.dart';
import 'library_top_bar.dart';
import 'pill_button.dart';
import 'reading_drop_cap_text.dart';
import 'reading_footer.dart';
import 'reading_top_bar.dart';
import 'section_header.dart';
import 'thin_progress_bar.dart';
import 'upload_item_row.dart';

/// Living component catalog — every leaf widget rendered in every
/// state it supports, so each one can be verified in isolation
/// before it's composed into a real screen.
///
/// Maintenance rule: no widget merges without an entry here. When a
/// new composite is built, its entry ships in the same change, not
/// as a follow-up.
///
/// Mount this behind a debug-only route, e.g.:
/// ```dart
/// if (kDebugMode)
///   MaterialPageRoute(builder: (_) => const WidgetCatalogScreen())
/// ```
class WidgetCatalogScreen extends StatelessWidget {
  const WidgetCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final revealKey = GlobalKey<StaggeredChapterRevealState>();

    return Scaffold(
      backgroundColor: OmoweColors.stone50,
      appBar: AppBar(
        backgroundColor: OmoweColors.stone50,
        foregroundColor: OmoweColors.ink900,
        elevation: 0,
        title: const Text('Widget catalog'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CatalogEntry(
            label: 'BookHeader',
            width: 280,
            child: const BookHeader(
              title: 'Things Fall Apart',
              chunkCount: 12,
              tintIndex: 0,
            ),
          ),

          CatalogEntry(
            label: 'ReadingDropCapText',
            width: 260,
            child: const ReadingDropCapText(
              paragraph: CatalogFixtures.readingParagraph,
            ),
          ),

          CatalogEntry(
            label: 'DropZone',
            width: 260,
            child: DropZone(onTap: () {}),
          ),
          CatalogEntry(
            label: 'ReadingFooter',
            width: 260,
            child: const ReadingFooter(
              timeLeftLabel: '12 min left in chapter',
              paceLabel: 'on pace',
            ),
          ),
          CatalogEntry(
            label: 'ReadingTopBar',
            width: 220,
            child: ReadingTopBar(progress: 0.38, onBack: () {}),
          ),

          CatalogEntry(
            label: 'BookProgressRow',
            width: 200,
            child: const BookProgressRow(readCount: 2, totalCount: 12),
          ),
          CatalogEntry(
            label: 'LibraryTopBar',
            width: 360,
            child: LibraryTopBar(onSearch: () {}, onAdd: () {}),
          ),

          CatalogEntry(
            label: 'LibraryCoverTile',
            width: 100,
            child: const LibraryCoverTile(
              title: CatalogFixtures.shortTitle,
              unreadCount: 6,
              tintIndex: 3,
            ),
          ),

          CatalogEntry(
            label: 'ContinueReadingHero',
            width: 360,
            child: ContinueReadingHero(
              bookTitle: 'Things Fall Apart',
              chunkTitle: CatalogFixtures.chapterTitleShort,
              chunksLeft: 10,
              onResume: () {},
              tintIndex: 0,
            ),
          ),

          CatalogSection(
            title: 'Chrome',
            entries: [
              CatalogEntry(
                label: 'OmoweBackButton',
                child: OmoweBackButton(onPressed: () {}),
              ),
              CatalogEntry(
                label: 'SectionHeader — with trailing count',
                width: 240,
                child: const SectionHeader(
                  label: 'Library',
                  trailing: '4 books',
                ),
              ),
              CatalogEntry(
                label: 'SectionHeader — label only',
                width: 240,
                child: const SectionHeader(label: 'Recently added'),
              ),
            ],
          ),
          CatalogSection(
            title: 'Buttons',
            entries: [
              CatalogEntry(
                label: 'OmowePillButton — ink',
                width: 220,
                child: OmowePillButton(label: 'Choose file', onPressed: () {}),
              ),
              CatalogEntry(
                label: 'OmowePillButton — sage, with icon',
                width: 220,
                child: OmowePillButton(
                  label: 'Resume reading',
                  onPressed: () {},
                  variant: OmowePillVariant.sage,
                  icon: Icons.arrow_forward,
                ),
              ),
              CatalogEntry(
                label: 'OmowePillButton — compact, no icon',
                child: OmowePillButton(
                  label: 'Retry',
                  onPressed: () {},
                  compact: true,
                  expand: false,
                ),
              ),
              CatalogEntry(
                label: 'ResumePillButton — full width',
                width: 220,
                child: ResumePillButton(
                  label: 'Resume reading',
                  onPressed: () {},
                ),
              ),
              CatalogEntry(
                label: 'ResumePillButton — compact',
                child: ResumePillButton(
                  label: 'Resume',
                  onPressed: () {},
                  compact: true,
                ),
              ),
            ],
          ),
          CatalogSection(
            title: 'Covers',
            entries: [
              for (var i = 0; i < OmoweColors.coverTints.length; i++)
                CatalogEntry(
                  label: 'BookCover — tint $i, short title',
                  width: 150,
                  child: BookCover(
                    title: CatalogFixtures.shortTitle,
                    tintIndex: i,
                  ),
                ),
              CatalogEntry(
                label: 'BookCover — long title (ellipsis check)',
                width: 100,
                child: BookCover(
                  title: CatalogFixtures.longTitle,
                  tintIndex: 1,
                ),
              ),
              CatalogEntry(
                label: 'BookCover — no title overlay (book-header context)',
                width: 100,
                child: BookCover(
                  title: CatalogFixtures.shortTitle,
                  tintIndex: 0,
                ),
              ),
            ],
          ),
          CatalogSection(
            title: 'Progress',
            entries: [
              CatalogEntry(
                label: 'ThinProgressBar — 0%',
                width: 200,
                child: const ThinProgressBar(value: 0),
              ),
              CatalogEntry(
                label: 'ThinProgressBar — 40%',
                width: 200,
                child: const ThinProgressBar(value: 0.4),
              ),
              CatalogEntry(
                label: 'ThinProgressBar — 100%',
                width: 200,
                child: const ThinProgressBar(value: 1),
              ),
              CatalogEntry(
                label: 'ThinProgressBar — mini (reading top bar)',
                width: 84,
                child: const ThinProgressBar(value: 0.38, height: 2),
              ),
            ],
          ),
          CatalogSection(
            title: 'Rows',
            entries: [
              CatalogEntry(
                label: 'ChapterRow — read',
                width: 280,
                child: ChapterRow(
                  number: 1,
                  title: CatalogFixtures.chapterTitleShort,
                  state: ChapterState.read,
                ),
              ),
              CatalogEntry(
                label: 'ChapterRow — current, long title',
                width: 280,
                child: ChapterRow(
                  number: 3,
                  title: CatalogFixtures.chapterTitleLong,
                  state: ChapterState.current,
                ),
              ),
              CatalogEntry(
                label: 'ChapterRow — unread',
                width: 280,
                child: ChapterRow(
                  number: 4,
                  title: CatalogFixtures.chapterTitleShort,
                  state: ChapterState.unread,
                ),
              ),
              CatalogEntry(
                label: 'UploadItemRow — transferring, long filename',
                width: 280,
                child: UploadItemRow(
                  title: CatalogFixtures.uploadFilenameLong,
                  state: UploadState.transferring,
                  progress: 0.42,
                ),
              ),
              CatalogEntry(
                label: 'UploadItemRow — processing',
                width: 280,
                child: UploadItemRow(
                  title: CatalogFixtures.uploadFilenameShort,
                  state: UploadState.processing,
                  subtitle: 'Preparing chapters…',
                ),
              ),
              CatalogEntry(
                label: 'UploadItemRow — ready',
                width: 280,
                child: UploadItemRow(
                  title: 'Things Fall Apart',
                  state: UploadState.ready,
                  subtitle: 'Ready to read',
                ),
              ),
            ],
          ),
          CatalogSection(
            title: 'Motion',
            entries: [
              CatalogEntry(
                label: 'StaggeredChapterReveal — tap to replay',
                width: 260,
                child: Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => revealKey.currentState?.replay(),
                    child: StaggeredChapterReveal(
                      key: revealKey,
                      children: [
                        Text('Chapter three', style: OmoweTypography.uiEyebrow),
                        Text(
                          'The weight of a name',
                          style: OmoweTypography.displayOnDevice(size: 18),
                        ),
                        Text(
                          CatalogFixtures.readingParagraph,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: OmoweTypography.readingBody.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
