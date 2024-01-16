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
String _$newMessagesStreamHash() => r'd67b495c20a979a9bd7447ea68e57f16b84fc7df';

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

String _$chatUserInsertHash() => r'63922107ac7ce2b488a91569ad6d94bb0372e5ca';

/// See also [chatUserInsert].
@ProviderFor(chatUserInsert)
final chatUserInsertProvider =
    AutoDisposeStreamProvider<Map<String, dynamic>>.internal(
  chatUserInsert,
  name: r'chatUserInsertProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatUserInsertHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatUserInsertRef = AutoDisposeStreamProviderRef<Map<String, dynamic>>;
String _$chatUserUpdateHash() => r'363ec6424f12ddc9f79df7bf9326362fc9025c21';

/// See also [chatUserUpdate].
@ProviderFor(chatUserUpdate)
final chatUserUpdateProvider =
    AutoDisposeStreamProvider<Map<String, dynamic>>.internal(
  chatUserUpdate,
  name: r'chatUserUpdateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatUserUpdateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatUserUpdateRef = AutoDisposeStreamProviderRef<Map<String, dynamic>>;
String _$onJoinForRoomHash() => r'83c4c5f315e71e8c49f0b9d9c6bd751c18e0cbdc';

/// See also [onJoinForRoom].
@ProviderFor(onJoinForRoom)
const onJoinForRoomProvider = OnJoinForRoomFamily();

/// See also [onJoinForRoom].
class OnJoinForRoomFamily extends Family<AsyncValue<bool>> {
  /// See also [onJoinForRoom].
  const OnJoinForRoomFamily();

  /// See also [onJoinForRoom].
  OnJoinForRoomProvider call(
    String roomId,
  ) {
    return OnJoinForRoomProvider(
      roomId,
    );
  }

  @override
  OnJoinForRoomProvider getProviderOverride(
    covariant OnJoinForRoomProvider provider,
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
  String? get name => r'onJoinForRoomProvider';
}

/// See also [onJoinForRoom].
class OnJoinForRoomProvider extends AutoDisposeStreamProvider<bool> {
  /// See also [onJoinForRoom].
  OnJoinForRoomProvider(
    String roomId,
  ) : this._internal(
          (ref) => onJoinForRoom(
            ref as OnJoinForRoomRef,
            roomId,
          ),
          from: onJoinForRoomProvider,
          name: r'onJoinForRoomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$onJoinForRoomHash,
          dependencies: OnJoinForRoomFamily._dependencies,
          allTransitiveDependencies:
              OnJoinForRoomFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  OnJoinForRoomProvider._internal(
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
    Stream<bool> Function(OnJoinForRoomRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OnJoinForRoomProvider._internal(
        (ref) => create(ref as OnJoinForRoomRef),
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
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _OnJoinForRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OnJoinForRoomProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OnJoinForRoomRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _OnJoinForRoomProviderElement
    extends AutoDisposeStreamProviderElement<bool> with OnJoinForRoomRef {
  _OnJoinForRoomProviderElement(super.provider);

  @override
  String get roomId => (origin as OnJoinForRoomProvider).roomId;
}

String _$newRequestedRoomHash() => r'9b967f2aaceaea90b51a07c3108387c248e65a64';

/// See also [newRequestedRoom].
@ProviderFor(newRequestedRoom)
final newRequestedRoomProvider = AutoDisposeStreamProvider<Room>.internal(
  newRequestedRoom,
  name: r'newRequestedRoomProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newRequestedRoomHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NewRequestedRoomRef = AutoDisposeStreamProviderRef<Room>;
String _$joinedRoomHash() => r'7ab55724c0128d9d804490fc857e1a96cf0d8b89';

/// See also [joinedRoom].
@ProviderFor(joinedRoom)
final joinedRoomProvider = AutoDisposeStreamProvider<Room>.internal(
  joinedRoom,
  name: r'joinedRoomProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$joinedRoomHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef JoinedRoomRef = AutoDisposeStreamProviderRef<Room>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
