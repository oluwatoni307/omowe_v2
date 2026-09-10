/// Icon sizes. The source is uniform here — every chrome icon (back
/// chevron, search, add) renders at exactly 19×19 logical pixels across
/// every mockup — with one deliberate exception for the upload dropzone's
/// larger icon. There was no token for this before, which is exactly how
/// a wrong 22px got pasted into four different screen files without
/// anything catching it.
class OmoweIconSizes {
  OmoweIconSizes._();

  /// Chrome icons: back chevron, search, add. Matches the source's
  /// `.icon { width: 19px; height: 19px; }`, applied uniformly everywhere
  /// it appears.
  static const double chrome = 19;

  /// The upload dropzone's icon — the one place the source uses a larger
  /// size (`.dropzone svg { width: 24px; height: 24px; }`).
  static const double dropzone = 24;
}
