// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'2b5e8075b7c99c401204cb0f27d35674ddc305a2';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = AutoDisposeProvider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRepositoryRef = AutoDisposeProviderRef<ChatRepository>;
String _$getProfilesForRoomHash() =>
    r'87615ca4c5a0fd3e31fa6453cb07e6c7e0440a34';

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

/// See also [getProfilesForRoom].
@ProviderFor(getProfilesForRoom)
const getProfilesForRoomProvider = GetProfilesForRoomFamily();

/// See also [getProfilesForRoom].
class GetProfilesForRoomFamily
    extends Family<AsyncValue<Map<String, Profile>>> {
  /// See also [getProfilesForRoom].
  const GetProfilesForRoomFamily();

  /// See also [getProfilesForRoom].
  GetProfilesForRoomProvider call(
    String roomId,
  ) {
    return GetProfilesForRoomProvider(
      roomId,
    );
  }

  @override
  GetProfilesForRoomProvider getProviderOverride(
    covariant GetProfilesForRoomProvider provider,
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
  String? get name => r'getProfilesForRoomProvider';
}

/// See also [getProfilesForRoom].
class GetProfilesForRoomProvider
    extends AutoDisposeFutureProvider<Map<String, Profile>> {
  /// See also [getProfilesForRoom].
  GetProfilesForRoomProvider(
    String roomId,
  ) : this._internal(
          (ref) => getProfilesForRoom(
            ref as GetProfilesForRoomRef,
            roomId,
          ),
          from: getProfilesForRoomProvider,
          name: r'getProfilesForRoomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProfilesForRoomHash,
          dependencies: GetProfilesForRoomFamily._dependencies,
          allTransitiveDependencies:
              GetProfilesForRoomFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  GetProfilesForRoomProvider._internal(
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
  Override overrideWith(
    FutureOr<Map<String, Profile>> Function(GetProfilesForRoomRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProfilesForRoomProvider._internal(
        (ref) => create(ref as GetProfilesForRoomRef),
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
  AutoDisposeFutureProviderElement<Map<String, Profile>> createElement() {
    return _GetProfilesForRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfilesForRoomProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfilesForRoomRef
    on AutoDisposeFutureProviderRef<Map<String, Profile>> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _GetProfilesForRoomProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, Profile>>
    with GetProfilesForRoomRef {
  _GetProfilesForRoomProviderElement(super.provider);

  @override
  String get roomId => (origin as GetProfilesForRoomProvider).roomId;
}

String _$getAllRoomsHash() => r'c1bc1fad121c5e99d0bc76e33556ed65ef063e9b';

/// See also [getAllRooms].
@ProviderFor(getAllRooms)
final getAllRoomsProvider = AutoDisposeFutureProvider<List<Room>>.internal(
  getAllRooms,
  name: r'getAllRoomsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllRoomsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllRoomsRef = AutoDisposeFutureProviderRef<List<Room>>;
String _$watchNewMessagesStreamHash() =>
    r'25c4bc492ee93e4efa44b77e77c79b0a731841fa';

/// See also [watchNewMessagesStream].
@ProviderFor(watchNewMessagesStream)
const watchNewMessagesStreamProvider = WatchNewMessagesStreamFamily();

/// See also [watchNewMessagesStream].
class WatchNewMessagesStreamFamily extends Family<AsyncValue<Message>> {
  /// See also [watchNewMessagesStream].
  const WatchNewMessagesStreamFamily();

  /// See also [watchNewMessagesStream].
  WatchNewMessagesStreamProvider call(
    String roomId,
  ) {
    return WatchNewMessagesStreamProvider(
      roomId,
    );
  }

  @override
  WatchNewMessagesStreamProvider getProviderOverride(
    covariant WatchNewMessagesStreamProvider provider,
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
  String? get name => r'watchNewMessagesStreamProvider';
}

/// See also [watchNewMessagesStream].
class WatchNewMessagesStreamProvider
    extends AutoDisposeStreamProvider<Message> {
  /// See also [watchNewMessagesStream].
  WatchNewMessagesStreamProvider(
    String roomId,
  ) : this._internal(
          (ref) => watchNewMessagesStream(
            ref as WatchNewMessagesStreamRef,
            roomId,
          ),
          from: watchNewMessagesStreamProvider,
          name: r'watchNewMessagesStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchNewMessagesStreamHash,
          dependencies: WatchNewMessagesStreamFamily._dependencies,
          allTransitiveDependencies:
              WatchNewMessagesStreamFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  WatchNewMessagesStreamProvider._internal(
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
  Override overrideWith(
    Stream<Message> Function(WatchNewMessagesStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchNewMessagesStreamProvider._internal(
        (ref) => create(ref as WatchNewMessagesStreamRef),
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
  AutoDisposeStreamProviderElement<Message> createElement() {
    return _WatchNewMessagesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchNewMessagesStreamProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchNewMessagesStreamRef on AutoDisposeStreamProviderRef<Message> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _WatchNewMessagesStreamProviderElement
    extends AutoDisposeStreamProviderElement<Message>
    with WatchNewMessagesStreamRef {
  _WatchNewMessagesStreamProviderElement(super.provider);

  @override
  String get roomId => (origin as WatchNewMessagesStreamProvider).roomId;
}

String _$unReadMessagesStreamHash() =>
    r'7886b36f54db8174e62aad132680b4a88a745fb8';

/// See also [unReadMessagesStream].
@ProviderFor(unReadMessagesStream)
const unReadMessagesStreamProvider = UnReadMessagesStreamFamily();

/// See also [unReadMessagesStream].
class UnReadMessagesStreamFamily extends Family<AsyncValue<int>> {
  /// See also [unReadMessagesStream].
  const UnReadMessagesStreamFamily();

  /// See also [unReadMessagesStream].
  UnReadMessagesStreamProvider call([
    String? roomId,
  ]) {
    return UnReadMessagesStreamProvider(
      roomId,
    );
  }

  @override
  UnReadMessagesStreamProvider getProviderOverride(
    covariant UnReadMessagesStreamProvider provider,
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
  String? get name => r'unReadMessagesStreamProvider';
}

/// See also [unReadMessagesStream].
class UnReadMessagesStreamProvider extends AutoDisposeStreamProvider<int> {
  /// See also [unReadMessagesStream].
  UnReadMessagesStreamProvider([
    String? roomId,
  ]) : this._internal(
          (ref) => unReadMessagesStream(
            ref as UnReadMessagesStreamRef,
            roomId,
          ),
          from: unReadMessagesStreamProvider,
          name: r'unReadMessagesStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$unReadMessagesStreamHash,
          dependencies: UnReadMessagesStreamFamily._dependencies,
          allTransitiveDependencies:
              UnReadMessagesStreamFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  UnReadMessagesStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
  }) : super.internal();

  final String? roomId;

  @override
  Override overrideWith(
    Stream<int> Function(UnReadMessagesStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UnReadMessagesStreamProvider._internal(
        (ref) => create(ref as UnReadMessagesStreamRef),
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
  AutoDisposeStreamProviderElement<int> createElement() {
    return _UnReadMessagesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UnReadMessagesStreamProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UnReadMessagesStreamRef on AutoDisposeStreamProviderRef<int> {
  /// The parameter `roomId` of this provider.
  String? get roomId;
}

class _UnReadMessagesStreamProviderElement
    extends AutoDisposeStreamProviderElement<int> with UnReadMessagesStreamRef {
  _UnReadMessagesStreamProviderElement(super.provider);

  @override
  String? get roomId => (origin as UnReadMessagesStreamProvider).roomId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
