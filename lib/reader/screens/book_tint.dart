import '../../theme/omowe_colors.dart';

/// Deterministic tint assignment for a book, derived from its [id].
///
/// Stable across reordering, filtering, or partial loads — unlike an
/// index-based assignment, which would require every place a book's
/// tint is shown to agree on the same list order at the same moment.
/// That matters here specifically because the library grid and the
/// continue-reading hero are backed by two independently-loading
/// providers and can resolve in either order.
int tintIndexForBookId(String id) =>
    id.hashCode.abs() % OmoweColors.coverTints.length;
