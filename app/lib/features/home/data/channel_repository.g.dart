// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$channelRepositoryHash() => r'9fe2c324a73077456b71339841a139d371c172ee';

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
class ChannelRepositoryProvider extends Provider<ChannelRepository> {
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
  ProviderElement<ChannelRepository> createElement() {
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

mixin ChannelRepositoryRef on ProviderRef<ChannelRepository> {
  /// The parameter `channelName` of this provider.
  String get channelName;
}

class _ChannelRepositoryProviderElement
    extends ProviderElement<ChannelRepository> with ChannelRepositoryRef {
  _ChannelRepositoryProviderElement(super.provider);

  @override
  String get channelName => (origin as ChannelRepositoryProvider).channelName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
