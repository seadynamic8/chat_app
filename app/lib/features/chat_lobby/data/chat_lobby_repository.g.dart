// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_lobby_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatLobbyRepositoryHash() =>
    r'6353457f7e51d00052283cb7c5187421a680be9e';

/// See also [chatLobbyRepository].
@ProviderFor(chatLobbyRepository)
final chatLobbyRepositoryProvider =
    AutoDisposeProvider<ChatLobbyRepository>.internal(
  chatLobbyRepository,
  name: r'chatLobbyRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatLobbyRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatLobbyRepositoryRef = AutoDisposeProviderRef<ChatLobbyRepository>;
String _$unReadMessagesStreamHash() =>
    r'613388fec9e61aee2e561c8756cd9d6d9488aeda';

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
