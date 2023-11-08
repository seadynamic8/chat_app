// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_presences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lobbySubscribedChannelHash() =>
    r'53eb522bad814f13da5c3faae2470d1aa3ae97c0';

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

/// See also [lobbySubscribedChannel].
@ProviderFor(lobbySubscribedChannel)
const lobbySubscribedChannelProvider = LobbySubscribedChannelFamily();

/// See also [lobbySubscribedChannel].
class LobbySubscribedChannelFamily
    extends Family<AsyncValue<ChannelRepository>> {
  /// See also [lobbySubscribedChannel].
  const LobbySubscribedChannelFamily();

  /// See also [lobbySubscribedChannel].
  LobbySubscribedChannelProvider call(
    String channelName,
  ) {
    return LobbySubscribedChannelProvider(
      channelName,
    );
  }

  @override
  LobbySubscribedChannelProvider getProviderOverride(
    covariant LobbySubscribedChannelProvider provider,
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
  String? get name => r'lobbySubscribedChannelProvider';
}

/// See also [lobbySubscribedChannel].
class LobbySubscribedChannelProvider extends FutureProvider<ChannelRepository> {
  /// See also [lobbySubscribedChannel].
  LobbySubscribedChannelProvider(
    String channelName,
  ) : this._internal(
          (ref) => lobbySubscribedChannel(
            ref as LobbySubscribedChannelRef,
            channelName,
          ),
          from: lobbySubscribedChannelProvider,
          name: r'lobbySubscribedChannelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lobbySubscribedChannelHash,
          dependencies: LobbySubscribedChannelFamily._dependencies,
          allTransitiveDependencies:
              LobbySubscribedChannelFamily._allTransitiveDependencies,
          channelName: channelName,
        );

  LobbySubscribedChannelProvider._internal(
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
    FutureOr<ChannelRepository> Function(LobbySubscribedChannelRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LobbySubscribedChannelProvider._internal(
        (ref) => create(ref as LobbySubscribedChannelRef),
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
  FutureProviderElement<ChannelRepository> createElement() {
    return _LobbySubscribedChannelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LobbySubscribedChannelProvider &&
        other.channelName == channelName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, channelName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LobbySubscribedChannelRef on FutureProviderRef<ChannelRepository> {
  /// The parameter `channelName` of this provider.
  String get channelName;
}

class _LobbySubscribedChannelProviderElement
    extends FutureProviderElement<ChannelRepository>
    with LobbySubscribedChannelRef {
  _LobbySubscribedChannelProviderElement(super.provider);

  @override
  String get channelName =>
      (origin as LobbySubscribedChannelProvider).channelName;
}

String _$onlinePresencesHash() => r'526a0b987c752169430308fa8d36f6ca681398f5';

/// See also [OnlinePresences].
@ProviderFor(OnlinePresences)
final onlinePresencesProvider =
    NotifierProvider<OnlinePresences, Map<String, OnlineState>>.internal(
  OnlinePresences.new,
  name: r'onlinePresencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onlinePresencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OnlinePresences = Notifier<Map<String, OnlineState>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
