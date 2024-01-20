// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joined_room_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$joinedRoomNotifierHash() =>
    r'35693e6c6a4b7601d87eea2892e2996d42abce13';

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

abstract class _$JoinedRoomNotifier
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String roomId;

  FutureOr<bool> build(
    String roomId,
  );
}

/// See also [JoinedRoomNotifier].
@ProviderFor(JoinedRoomNotifier)
const joinedRoomNotifierProvider = JoinedRoomNotifierFamily();

/// See also [JoinedRoomNotifier].
class JoinedRoomNotifierFamily extends Family<AsyncValue<bool>> {
  /// See also [JoinedRoomNotifier].
  const JoinedRoomNotifierFamily();

  /// See also [JoinedRoomNotifier].
  JoinedRoomNotifierProvider call(
    String roomId,
  ) {
    return JoinedRoomNotifierProvider(
      roomId,
    );
  }

  @override
  JoinedRoomNotifierProvider getProviderOverride(
    covariant JoinedRoomNotifierProvider provider,
  ) {
    return call(
      provider.roomId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'joinedRoomNotifierProvider';
}

/// See also [JoinedRoomNotifier].
class JoinedRoomNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<JoinedRoomNotifier, bool> {
  /// See also [JoinedRoomNotifier].
  JoinedRoomNotifierProvider(
    String roomId,
  ) : this._internal(
          () => JoinedRoomNotifier()..roomId = roomId,
          from: joinedRoomNotifierProvider,
          name: r'joinedRoomNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$joinedRoomNotifierHash,
          dependencies: JoinedRoomNotifierFamily._dependencies,
          allTransitiveDependencies:
              JoinedRoomNotifierFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  JoinedRoomNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
  }) : super.internal();

  final String roomId;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant JoinedRoomNotifier notifier,
  ) {
    return notifier.build(
      roomId,
    );
  }

  @override
  Override overrideWith(JoinedRoomNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: JoinedRoomNotifierProvider._internal(
        () => create()..roomId = roomId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<JoinedRoomNotifier, bool>
      createElement() {
    return _JoinedRoomNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JoinedRoomNotifierProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin JoinedRoomNotifierRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _JoinedRoomNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<JoinedRoomNotifier, bool>
    with JoinedRoomNotifierRef {
  _JoinedRoomNotifierProviderElement(super.provider);

  @override
  String get roomId => (origin as JoinedRoomNotifierProvider).roomId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
