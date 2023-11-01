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
String _$watchMessagesForRoomHash() =>
    r'73866d935549968e337309ea06cf929c8fa7df7a';

/// See also [watchMessagesForRoom].
@ProviderFor(watchMessagesForRoom)
const watchMessagesForRoomProvider = WatchMessagesForRoomFamily();

/// See also [watchMessagesForRoom].
class WatchMessagesForRoomFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [watchMessagesForRoom].
  const WatchMessagesForRoomFamily();

  /// See also [watchMessagesForRoom].
  WatchMessagesForRoomProvider call(
    String roomId,
  ) {
    return WatchMessagesForRoomProvider(
      roomId,
    );
  }

  @override
  WatchMessagesForRoomProvider getProviderOverride(
    covariant WatchMessagesForRoomProvider provider,
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
  String? get name => r'watchMessagesForRoomProvider';
}

/// See also [watchMessagesForRoom].
class WatchMessagesForRoomProvider
    extends AutoDisposeStreamProvider<List<Map<String, dynamic>>> {
  /// See also [watchMessagesForRoom].
  WatchMessagesForRoomProvider(
    String roomId,
  ) : this._internal(
          (ref) => watchMessagesForRoom(
            ref as WatchMessagesForRoomRef,
            roomId,
          ),
          from: watchMessagesForRoomProvider,
          name: r'watchMessagesForRoomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchMessagesForRoomHash,
          dependencies: WatchMessagesForRoomFamily._dependencies,
          allTransitiveDependencies:
              WatchMessagesForRoomFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  WatchMessagesForRoomProvider._internal(
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
    Stream<List<Map<String, dynamic>>> Function(
            WatchMessagesForRoomRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchMessagesForRoomProvider._internal(
        (ref) => create(ref as WatchMessagesForRoomRef),
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
  AutoDisposeStreamProviderElement<List<Map<String, dynamic>>> createElement() {
    return _WatchMessagesForRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchMessagesForRoomProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchMessagesForRoomRef
    on AutoDisposeStreamProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _WatchMessagesForRoomProviderElement
    extends AutoDisposeStreamProviderElement<List<Map<String, dynamic>>>
    with WatchMessagesForRoomRef {
  _WatchMessagesForRoomProviderElement(super.provider);

  @override
  String get roomId => (origin as WatchMessagesForRoomProvider).roomId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
