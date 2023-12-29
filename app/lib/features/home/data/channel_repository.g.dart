// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$channelRepositoryHash() => r'fee96aeb22083b4d5f915f48c300b9e3121ebf64';

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

/// See also [channelRepository].
@ProviderFor(channelRepository)
const channelRepositoryProvider = ChannelRepositoryFamily();

/// See also [channelRepository].
class ChannelRepositoryFamily extends Family<ChannelRepository> {
  /// See also [channelRepository].
  const ChannelRepositoryFamily();

  /// See also [channelRepository].
  ChannelRepositoryProvider call(
    String channelName,
  ) {
    return ChannelRepositoryProvider(
      channelName,
    );
  }

  @override
  ChannelRepositoryProvider getProviderOverride(
    covariant ChannelRepositoryProvider provider,
  ) {
    return call(
      provider.channelName,
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
  String? get name => r'channelRepositoryProvider';
}

/// See also [channelRepository].
class ChannelRepositoryProvider extends AutoDisposeProvider<ChannelRepository> {
  /// See also [channelRepository].
  ChannelRepositoryProvider(
    String channelName,
  ) : this._internal(
          (ref) => channelRepository(
            ref as ChannelRepositoryRef,
            channelName,
          ),
          from: channelRepositoryProvider,
          name: r'channelRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$channelRepositoryHash,
          dependencies: ChannelRepositoryFamily._dependencies,
          allTransitiveDependencies:
              ChannelRepositoryFamily._allTransitiveDependencies,
          channelName: channelName,
        );

  ChannelRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.channelName,
  }) : super.internal();

  final String channelName;

  @override
  Override overrideWith(
    ChannelRepository Function(ChannelRepositoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChannelRepositoryProvider._internal(
        (ref) => create(ref as ChannelRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        channelName: channelName,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<ChannelRepository> createElement() {
    return _ChannelRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChannelRepositoryProvider &&
        other.channelName == channelName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, channelName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChannelRepositoryRef on AutoDisposeProviderRef<ChannelRepository> {
  /// The parameter `channelName` of this provider.
  String get channelName;
}

class _ChannelRepositoryProviderElement
    extends AutoDisposeProviderElement<ChannelRepository>
    with ChannelRepositoryRef {
  _ChannelRepositoryProviderElement(super.provider);

  @override
  String get channelName => (origin as ChannelRepositoryProvider).channelName;
}

String _$userSubscribedChannelHash() =>
    r'8721e59c9416a3c9311f0c69d4176a3c9d201691';

/// See also [userSubscribedChannel].
@ProviderFor(userSubscribedChannel)
const userSubscribedChannelProvider = UserSubscribedChannelFamily();

/// See also [userSubscribedChannel].
class UserSubscribedChannelFamily
    extends Family<AsyncValue<ChannelRepository>> {
  /// See also [userSubscribedChannel].
  const UserSubscribedChannelFamily();

  /// See also [userSubscribedChannel].
  UserSubscribedChannelProvider call(
    String userId,
  ) {
    return UserSubscribedChannelProvider(
      userId,
    );
  }

  @override
  UserSubscribedChannelProvider getProviderOverride(
    covariant UserSubscribedChannelProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userSubscribedChannelProvider';
}

/// See also [userSubscribedChannel].
class UserSubscribedChannelProvider
    extends AutoDisposeFutureProvider<ChannelRepository> {
  /// See also [userSubscribedChannel].
  UserSubscribedChannelProvider(
    String userId,
  ) : this._internal(
          (ref) => userSubscribedChannel(
            ref as UserSubscribedChannelRef,
            userId,
          ),
          from: userSubscribedChannelProvider,
          name: r'userSubscribedChannelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userSubscribedChannelHash,
          dependencies: UserSubscribedChannelFamily._dependencies,
          allTransitiveDependencies:
              UserSubscribedChannelFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserSubscribedChannelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<ChannelRepository> Function(UserSubscribedChannelRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserSubscribedChannelProvider._internal(
        (ref) => create(ref as UserSubscribedChannelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ChannelRepository> createElement() {
    return _UserSubscribedChannelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserSubscribedChannelProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserSubscribedChannelRef
    on AutoDisposeFutureProviderRef<ChannelRepository> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserSubscribedChannelProviderElement
    extends AutoDisposeFutureProviderElement<ChannelRepository>
    with UserSubscribedChannelRef {
  _UserSubscribedChannelProviderElement(super.provider);

  @override
  String get userId => (origin as UserSubscribedChannelProvider).userId;
}

String _$lobbySubscribedChannelHash() =>
    r'4999efb0c04ee750ff39dcb54b2c4cb5927363c4';

/// See also [lobbySubscribedChannel].
@ProviderFor(lobbySubscribedChannel)
final lobbySubscribedChannelProvider =
    AutoDisposeFutureProvider<ChannelRepository>.internal(
  lobbySubscribedChannel,
  name: r'lobbySubscribedChannelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lobbySubscribedChannelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LobbySubscribedChannelRef
    = AutoDisposeFutureProviderRef<ChannelRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
