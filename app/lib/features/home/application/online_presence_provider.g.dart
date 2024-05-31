// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_presence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onlinePresenceHash() => r'9cf67fee316c9e58dd69bcc2b0048edd9e06a8b3';

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

abstract class _$OnlinePresence
    extends BuildlessAutoDisposeAsyncNotifier<OnlineStatus> {
  late final String userId;

  FutureOr<OnlineStatus> build(
    String userId,
  );
}

/// See also [OnlinePresence].
@ProviderFor(OnlinePresence)
const onlinePresenceProvider = OnlinePresenceFamily();

/// See also [OnlinePresence].
class OnlinePresenceFamily extends Family<AsyncValue<OnlineStatus>> {
  /// See also [OnlinePresence].
  const OnlinePresenceFamily();

  /// See also [OnlinePresence].
  OnlinePresenceProvider call(
    String userId,
  ) {
    return OnlinePresenceProvider(
      userId,
    );
  }

  @override
  OnlinePresenceProvider getProviderOverride(
    covariant OnlinePresenceProvider provider,
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
  String? get name => r'onlinePresenceProvider';
}

/// See also [OnlinePresence].
class OnlinePresenceProvider
    extends AutoDisposeAsyncNotifierProviderImpl<OnlinePresence, OnlineStatus> {
  /// See also [OnlinePresence].
  OnlinePresenceProvider(
    String userId,
  ) : this._internal(
          () => OnlinePresence()..userId = userId,
          from: onlinePresenceProvider,
          name: r'onlinePresenceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$onlinePresenceHash,
          dependencies: OnlinePresenceFamily._dependencies,
          allTransitiveDependencies:
              OnlinePresenceFamily._allTransitiveDependencies,
          userId: userId,
        );

  OnlinePresenceProvider._internal(
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
  FutureOr<OnlineStatus> runNotifierBuild(
    covariant OnlinePresence notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(OnlinePresence Function() create) {
    return ProviderOverride(
      origin: this,
      override: OnlinePresenceProvider._internal(
        () => create()..userId = userId,
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
  AutoDisposeAsyncNotifierProviderElement<OnlinePresence, OnlineStatus>
      createElement() {
    return _OnlinePresenceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OnlinePresenceProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OnlinePresenceRef on AutoDisposeAsyncNotifierProviderRef<OnlineStatus> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _OnlinePresenceProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<OnlinePresence,
        OnlineStatus> with OnlinePresenceRef {
  _OnlinePresenceProviderElement(super.provider);

  @override
  String get userId => (origin as OnlinePresenceProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
