// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joined_room_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$joinedRoomNotifierHash() =>
    r'0051915fe95829f9b2c543b19c2108cb954dde70';

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
  late final String otherProfileId;

  FutureOr<bool> build(
    String roomId,
    String otherProfileId,
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
    String otherProfileId,
  ) {
    return JoinedRoomNotifierProvider(
      roomId,
      otherProfileId,
    );
  }

  @override
  JoinedRoomNotifierProvider getProviderOverride(
    covariant JoinedRoomNotifierProvider provider,
  ) {
    return call(
      provider.roomId,
      provider.otherProfileId,
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
    String otherProfileId,
  ) : this._internal(
          () => JoinedRoomNotifier()
            ..roomId = roomId
            ..otherProfileId = otherProfileId,
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
          otherProfileId: otherProfileId,
        );

  JoinedRoomNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
    required this.otherProfileId,
  }) : super.internal();

  final String roomId;
  final String otherProfileId;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant JoinedRoomNotifier notifier,
  ) {
    return notifier.build(
      roomId,
      otherProfileId,
    );
  }

  @override
  Override overrideWith(JoinedRoomNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: JoinedRoomNotifierProvider._internal(
        () => create()
          ..roomId = roomId
          ..otherProfileId = otherProfileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
        otherProfileId: otherProfileId,
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
    return other is JoinedRoomNotifierProvider &&
        other.roomId == roomId &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin JoinedRoomNotifierRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `roomId` of this provider.
  String get roomId;

  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _JoinedRoomNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<JoinedRoomNotifier, bool>
    with JoinedRoomNotifierRef {
  _JoinedRoomNotifierProviderElement(super.provider);

  @override
  String get roomId => (origin as JoinedRoomNotifierProvider).roomId;
  @override
  String get otherProfileId =>
      (origin as JoinedRoomNotifierProvider).otherProfileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
