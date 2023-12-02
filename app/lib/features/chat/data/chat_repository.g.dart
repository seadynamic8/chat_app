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

String _$getAllRoomsHash() => r'cb1e6b1d320a2df5187d9b7311a22286bfd8c6cf';

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
String _$newMessagesStreamHash() => r'd67b495c20a979a9bd7447ea68e57f16b84fc7df';

/// See also [newMessagesStream].
@ProviderFor(newMessagesStream)
const newMessagesStreamProvider = NewMessagesStreamFamily();

/// See also [newMessagesStream].
class NewMessagesStreamFamily extends Family<AsyncValue<Message>> {
  /// See also [newMessagesStream].
  const NewMessagesStreamFamily();

  /// See also [newMessagesStream].
  NewMessagesStreamProvider call(
    String roomId,
  ) {
    return NewMessagesStreamProvider(
      roomId,
    );
  }

  @override
  NewMessagesStreamProvider getProviderOverride(
    covariant NewMessagesStreamProvider provider,
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
  String? get name => r'newMessagesStreamProvider';
}

/// See also [newMessagesStream].
class NewMessagesStreamProvider extends AutoDisposeStreamProvider<Message> {
  /// See also [newMessagesStream].
  NewMessagesStreamProvider(
    String roomId,
  ) : this._internal(
          (ref) => newMessagesStream(
            ref as NewMessagesStreamRef,
            roomId,
          ),
          from: newMessagesStreamProvider,
          name: r'newMessagesStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$newMessagesStreamHash,
          dependencies: NewMessagesStreamFamily._dependencies,
          allTransitiveDependencies:
              NewMessagesStreamFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  NewMessagesStreamProvider._internal(
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
    Stream<Message> Function(NewMessagesStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NewMessagesStreamProvider._internal(
        (ref) => create(ref as NewMessagesStreamRef),
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
    return _NewMessagesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NewMessagesStreamProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NewMessagesStreamRef on AutoDisposeStreamProviderRef<Message> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _NewMessagesStreamProviderElement
    extends AutoDisposeStreamProviderElement<Message>
    with NewMessagesStreamRef {
  _NewMessagesStreamProviderElement(super.provider);

  @override
  String get roomId => (origin as NewMessagesStreamProvider).roomId;
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
