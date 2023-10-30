// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchRepositoryHash() => r'13c34e60580ca88b8a06614a117c2ca39f12ed73';

/// See also [searchRepository].
@ProviderFor(searchRepository)
final searchRepositoryProvider = AutoDisposeProvider<SearchRepository>.internal(
  searchRepository,
  name: r'searchRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchRepositoryRef = AutoDisposeProviderRef<SearchRepository>;
String _$getProfileHash() => r'2c7e2e76ffd290a1b3f05eaad91c90b1e6291ba7';

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

/// See also [getProfile].
@ProviderFor(getProfile)
const getProfileProvider = GetProfileFamily();

/// See also [getProfile].
class GetProfileFamily extends Family<AsyncValue<Profile>> {
  /// See also [getProfile].
  const GetProfileFamily();

  /// See also [getProfile].
  GetProfileProvider call(
    String profileId,
  ) {
    return GetProfileProvider(
      profileId,
    );
  }

  @override
  GetProfileProvider getProviderOverride(
    covariant GetProfileProvider provider,
  ) {
    return call(
      provider.profileId,
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
  String? get name => r'getProfileProvider';
}

/// See also [getProfile].
class GetProfileProvider extends AutoDisposeFutureProvider<Profile> {
  /// See also [getProfile].
  GetProfileProvider(
    String profileId,
  ) : this._internal(
          (ref) => getProfile(
            ref as GetProfileRef,
            profileId,
          ),
          from: getProfileProvider,
          name: r'getProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProfileHash,
          dependencies: GetProfileFamily._dependencies,
          allTransitiveDependencies:
              GetProfileFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  GetProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
  }) : super.internal();

  final String profileId;

  @override
  Override overrideWith(
    FutureOr<Profile> Function(GetProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProfileProvider._internal(
        (ref) => create(ref as GetProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Profile> createElement() {
    return _GetProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfileProvider && other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfileRef on AutoDisposeFutureProviderRef<Profile> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _GetProfileProviderElement
    extends AutoDisposeFutureProviderElement<Profile> with GetProfileRef {
  _GetProfileProviderElement(super.provider);

  @override
  String get profileId => (origin as GetProfileProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
