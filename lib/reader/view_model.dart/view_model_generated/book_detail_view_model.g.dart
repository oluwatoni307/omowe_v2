// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../book_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookDetailViewModelHash() =>
    r'bef997449bac7b91d03eba58ca416596c4d99e0b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$BookDetailViewModel
    extends BuildlessAutoDisposeAsyncNotifier<BookDetail?> {
  late final String bookId;

  FutureOr<BookDetail?> build(String bookId);
}

/// See also [BookDetailViewModel].
@ProviderFor(BookDetailViewModel)
const bookDetailViewModelProvider = BookDetailViewModelFamily();

/// See also [BookDetailViewModel].
class BookDetailViewModelFamily extends Family<AsyncValue<BookDetail?>> {
  /// See also [BookDetailViewModel].
  const BookDetailViewModelFamily();

  /// See also [BookDetailViewModel].
  BookDetailViewModelProvider call(String bookId) {
    return BookDetailViewModelProvider(bookId);
  }

  @override
  BookDetailViewModelProvider getProviderOverride(
    covariant BookDetailViewModelProvider provider,
  ) {
    return call(provider.bookId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookDetailViewModelProvider';
}

/// See also [BookDetailViewModel].
class BookDetailViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<BookDetailViewModel, BookDetail?> {
  /// See also [BookDetailViewModel].
  BookDetailViewModelProvider(String bookId)
    : this._internal(
        () => BookDetailViewModel()..bookId = bookId,
        from: bookDetailViewModelProvider,
        name: r'bookDetailViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bookDetailViewModelHash,
        dependencies: BookDetailViewModelFamily._dependencies,
        allTransitiveDependencies:
            BookDetailViewModelFamily._allTransitiveDependencies,
        bookId: bookId,
      );

  BookDetailViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
  }) : super.internal();

  final String bookId;

  @override
  FutureOr<BookDetail?> runNotifierBuild(
    covariant BookDetailViewModel notifier,
  ) {
    return notifier.build(bookId);
  }

  @override
  Override overrideWith(BookDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookDetailViewModelProvider._internal(
        () => create()..bookId = bookId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookId: bookId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BookDetailViewModel, BookDetail?>
  createElement() {
    return _BookDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookDetailViewModelProvider && other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookDetailViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<BookDetail?> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _BookDetailViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BookDetailViewModel,
          BookDetail?
        >
    with BookDetailViewModelRef {
  _BookDetailViewModelProviderElement(super.provider);

  @override
  String get bookId => (origin as BookDetailViewModelProvider).bookId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
