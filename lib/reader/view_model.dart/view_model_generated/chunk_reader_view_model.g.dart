// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../chunk_reader_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chunkReaderViewModelHash() =>
    r'a891cd63ae86c412cc43862349c4146758691702';

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

abstract class _$ChunkReaderViewModel
    extends BuildlessAutoDisposeAsyncNotifier<Chunk?> {
  late final String bookId;
  late final int chunkIndex;

  FutureOr<Chunk?> build(String bookId, int chunkIndex);
}

/// See also [ChunkReaderViewModel].
@ProviderFor(ChunkReaderViewModel)
const chunkReaderViewModelProvider = ChunkReaderViewModelFamily();

/// See also [ChunkReaderViewModel].
class ChunkReaderViewModelFamily extends Family<AsyncValue<Chunk?>> {
  /// See also [ChunkReaderViewModel].
  const ChunkReaderViewModelFamily();

  /// See also [ChunkReaderViewModel].
  ChunkReaderViewModelProvider call(String bookId, int chunkIndex) {
    return ChunkReaderViewModelProvider(bookId, chunkIndex);
  }

  @override
  ChunkReaderViewModelProvider getProviderOverride(
    covariant ChunkReaderViewModelProvider provider,
  ) {
    return call(provider.bookId, provider.chunkIndex);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chunkReaderViewModelProvider';
}

/// See also [ChunkReaderViewModel].
class ChunkReaderViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ChunkReaderViewModel, Chunk?> {
  /// See also [ChunkReaderViewModel].
  ChunkReaderViewModelProvider(String bookId, int chunkIndex)
    : this._internal(
        () => ChunkReaderViewModel()
          ..bookId = bookId
          ..chunkIndex = chunkIndex,
        from: chunkReaderViewModelProvider,
        name: r'chunkReaderViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chunkReaderViewModelHash,
        dependencies: ChunkReaderViewModelFamily._dependencies,
        allTransitiveDependencies:
            ChunkReaderViewModelFamily._allTransitiveDependencies,
        bookId: bookId,
        chunkIndex: chunkIndex,
      );

  ChunkReaderViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
    required this.chunkIndex,
  }) : super.internal();

  final String bookId;
  final int chunkIndex;

  @override
  FutureOr<Chunk?> runNotifierBuild(covariant ChunkReaderViewModel notifier) {
    return notifier.build(bookId, chunkIndex);
  }

  @override
  Override overrideWith(ChunkReaderViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChunkReaderViewModelProvider._internal(
        () => create()
          ..bookId = bookId
          ..chunkIndex = chunkIndex,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookId: bookId,
        chunkIndex: chunkIndex,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChunkReaderViewModel, Chunk?>
  createElement() {
    return _ChunkReaderViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChunkReaderViewModelProvider &&
        other.bookId == bookId &&
        other.chunkIndex == chunkIndex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);
    hash = _SystemHash.combine(hash, chunkIndex.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChunkReaderViewModelRef on AutoDisposeAsyncNotifierProviderRef<Chunk?> {
  /// The parameter `bookId` of this provider.
  String get bookId;

  /// The parameter `chunkIndex` of this provider.
  int get chunkIndex;
}

class _ChunkReaderViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<ChunkReaderViewModel, Chunk?>
    with ChunkReaderViewModelRef {
  _ChunkReaderViewModelProviderElement(super.provider);

  @override
  String get bookId => (origin as ChunkReaderViewModelProvider).bookId;
  @override
  int get chunkIndex => (origin as ChunkReaderViewModelProvider).chunkIndex;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
