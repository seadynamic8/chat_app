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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member