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
    r'c139f41c702774f246cd4d267503f4c7bd63d043';

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
    String otherProfileId,
  ) {
    return GetProfilesForRoomProvider(
      otherProfileId,
    );
  }

  @override
  GetProfilesForRoomProvider getProviderOverride(
    covariant GetProfilesForRoomProvider provider,
  ) {
    return call(
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
  String? get name => r'getProfilesForRoomProvider';
}

/// See also [getProfilesForRoom].
class GetProfilesForRoomProvider
    extends AutoDisposeFutureProvider<Map<String, Profile>> {
  /// See also [getProfilesForRoom].
  GetProfilesForRoomProvider(
    String otherProfileId,
  ) : this._internal(
          (ref) => getProfilesForRoom(
            ref as GetProfilesForRoomRef,
            otherProfileId,
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
          otherProfileId: otherProfileId,
        );

  GetProfilesForRoomProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.otherProfileId,
  }) : super.internal();

  final String otherProfileId;

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
        otherProfileId: otherProfileId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, Profile>> createElement() {
    return _GetProfilesForRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfilesForRoomProvider &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfilesForRoomRef
    on AutoDisposeFutureProviderRef<Map<String, Profile>> {
  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _GetProfilesForRoomProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, Profile>>
    with GetProfilesForRoomRef {
  _GetProfilesForRoomProviderElement(super.provider);

  @override
  String get otherProfileId =>
      (origin as GetProfilesForRoomProvider).otherProfileId;
}

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
