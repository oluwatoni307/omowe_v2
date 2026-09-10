/// Centralized sample data for the widget catalog. Edit values here,
/// not inline inside individual catalog entries — when theming or
/// content rules change, this is the one place to update.
class CatalogFixtures {
  CatalogFixtures._();

  static const shortTitle = 'Emma';
  static const longTitle = 'Half of a Yellow Sun';

  static const chapterTitleShort = 'A yam harvest, remembered';
  static const chapterTitleLong = 'What the drums announced at first light';

  static const uploadFilenameShort = 'Sapiens';
  static const uploadFilenameLong = 'a-very-long-filename-that-might-wrap.epub';

  // Real prose, not lorem ipsum — Literata/Fraunces render differently
  // against actual sentence rhythm than against placeholder text.
  static const readingParagraph =
      'Low on the horizon the pale gathering light moved slowly across '
      'the compound, touching first the roofs, then the quiet stretch '
      'of red earth between the huts. It was the hour before anyone '
      'spoke, when the whole village still belonged to itself.';
}
