// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseHash() => r'd2c76c8455442fcc1da2405d92d2e55b47bcaeb6';

/// See also [supabase].
@ProviderFor(supabase)
final supabaseProvider = Provider<SupabaseClient>.internal(
  supabase,
  name: r'supabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$supabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupabaseRef = ProviderRef<SupabaseClient>;
String _$authRepositoryHash() => r'a40a84abda126a0001e5e6c00e78bb0bb9d6a877';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$currentSessionHash() => r'7ba54c6064a6ce7b0eb5262b489021c1017c5aa9';

/// See also [currentSession].
@ProviderFor(currentSession)
final currentSessionProvider = Provider<Session?>.internal(
  currentSession,
  name: r'currentSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentSessionRef = ProviderRef<Session?>;
String _$authStateChangesHash() => r'8ecee23e1696539e0ec184eaf34c7a3bb35414f8';

/// See also [authStateChanges].
@ProviderFor(authStateChanges)
final authStateChangesProvider = StreamProvider<AuthState>.internal(
  authStateChanges,
  name: r'authStateChangesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateChangesRef = StreamProviderRef<AuthState>;
String _$currentProfileStreamHash() =>
    r'ed8ed1b48b5346dd9731c8a1c576a3641efbe5ee';

/// See also [currentProfileStream].
@ProviderFor(currentProfileStream)
final currentProfileStreamProvider =
    AutoDisposeStreamProvider<Profile>.internal(
  currentProfileStream,
  name: r'currentProfileStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentProfileStreamRef = AutoDisposeStreamProviderRef<Profile>;
String _$profileStreamHash() => r'ef2c4e91841ba671aa44d8d60dcd12bc52413427';

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

/// See also [profileStream].
@ProviderFor(profileStream)
const profileStreamProvider = ProfileStreamFamily();

/// See also [profileStream].
class ProfileStreamFamily extends Family<AsyncValue<Profile>> {
  /// See also [profileStream].
  const ProfileStreamFamily();

  /// See also [profileStream].
  ProfileStreamProvider call(
    String profileId,
  ) {
    return ProfileStreamProvider(
      profileId,
    );
  }

  @override
  ProfileStreamProvider getProviderOverride(
    covariant ProfileStreamProvider provider,
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
  String? get name => r'profileStreamProvider';
}

/// See also [profileStream].
class ProfileStreamProvider extends AutoDisposeStreamProvider<Profile> {
  /// See also [profileStream].
  ProfileStreamProvider(
    String profileId,
  ) : this._internal(
          (ref) => profileStream(
            ref as ProfileStreamRef,
            profileId,
          ),
          from: profileStreamProvider,
          name: r'profileStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileStreamHash,
          dependencies: ProfileStreamFamily._dependencies,
          allTransitiveDependencies:
              ProfileStreamFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  ProfileStreamProvider._internal(
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
    Stream<Profile> Function(ProfileStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProfileStreamProvider._internal(
        (ref) => create(ref as ProfileStreamRef),
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
  AutoDisposeStreamProviderElement<Profile> createElement() {
    return _ProfileStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileStreamProvider && other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProfileStreamRef on AutoDisposeStreamProviderRef<Profile> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ProfileStreamProviderElement
    extends AutoDisposeStreamProviderElement<Profile> with ProfileStreamRef {
  _ProfileStreamProviderElement(super.provider);

  @override
  String get profileId => (origin as ProfileStreamProvider).profileId;
}

String _$profileChangesHash() => r'90298a00b8b94da106e0a9b5ed058824672ca7f3';

/// See also [profileChanges].
@ProviderFor(profileChanges)
const profileChangesProvider = ProfileChangesFamily();

/// See also [profileChanges].
class ProfileChangesFamily extends Family<AsyncValue<Profile>> {
  /// See also [profileChanges].
  const ProfileChangesFamily();

  /// See also [profileChanges].
  ProfileChangesProvider call(
    String profileId,
  ) {
    return ProfileChangesProvider(
      profileId,
    );
  }

  @override
  ProfileChangesProvider getProviderOverride(
    covariant ProfileChangesProvider provider,
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
  String? get name => r'profileChangesProvider';
}

/// See also [profileChanges].
class ProfileChangesProvider extends AutoDisposeStreamProvider<Profile> {
  /// See also [profileChanges].
  ProfileChangesProvider(
    String profileId,
  ) : this._internal(
          (ref) => profileChanges(
            ref as ProfileChangesRef,
            profileId,
          ),
          from: profileChangesProvider,
          name: r'profileChangesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileChangesHash,
          dependencies: ProfileChangesFamily._dependencies,
          allTransitiveDependencies:
              ProfileChangesFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  ProfileChangesProvider._internal(
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
    Stream<Profile> Function(ProfileChangesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProfileChangesProvider._internal(
        (ref) => create(ref as ProfileChangesRef),
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
  AutoDisposeStreamProviderElement<Profile> createElement() {
    return _ProfileChangesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileChangesProvider && other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProfileChangesRef on AutoDisposeStreamProviderRef<Profile> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ProfileChangesProviderElement
    extends AutoDisposeStreamProviderElement<Profile> with ProfileChangesRef {
  _ProfileChangesProviderElement(super.provider);

  @override
  String get profileId => (origin as ProfileChangesProvider).profileId;
}

String _$currentBlockingChangesHash() =>
    r'14f235ba92ade7ca1c8037396cf9d6b3ae7b6efa';

/// See also [currentBlockingChanges].
@ProviderFor(currentBlockingChanges)
const currentBlockingChangesProvider = CurrentBlockingChangesFamily();

/// See also [currentBlockingChanges].
class CurrentBlockingChangesFamily extends Family<AsyncValue<bool>> {
  /// See also [currentBlockingChanges].
  const CurrentBlockingChangesFamily();

  /// See also [currentBlockingChanges].
  CurrentBlockingChangesProvider call(
    String otherProfileId,
  ) {
    return CurrentBlockingChangesProvider(
      otherProfileId,
    );
  }

  @override
  CurrentBlockingChangesProvider getProviderOverride(
    covariant CurrentBlockingChangesProvider provider,
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
  String? get name => r'currentBlockingChangesProvider';
}

/// See also [currentBlockingChanges].
class CurrentBlockingChangesProvider extends AutoDisposeStreamProvider<bool> {
  /// See also [currentBlockingChanges].
  CurrentBlockingChangesProvider(
    String otherProfileId,
  ) : this._internal(
          (ref) => currentBlockingChanges(
            ref as CurrentBlockingChangesRef,
            otherProfileId,
          ),
          from: currentBlockingChangesProvider,
          name: r'currentBlockingChangesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentBlockingChangesHash,
          dependencies: CurrentBlockingChangesFamily._dependencies,
          allTransitiveDependencies:
              CurrentBlockingChangesFamily._allTransitiveDependencies,
          otherProfileId: otherProfileId,
        );

  CurrentBlockingChangesProvider._internal(
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
    Stream<bool> Function(CurrentBlockingChangesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentBlockingChangesProvider._internal(
        (ref) => create(ref as CurrentBlockingChangesRef),
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
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _CurrentBlockingChangesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentBlockingChangesProvider &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CurrentBlockingChangesRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _CurrentBlockingChangesProviderElement
    extends AutoDisposeStreamProviderElement<bool>
    with CurrentBlockingChangesRef {
  _CurrentBlockingChangesProviderElement(super.provider);

  @override
  String get otherProfileId =>
      (origin as CurrentBlockingChangesProvider).otherProfileId;
}

String _$otherBlockingChangesHash() =>
    r'6e6a532c9f8f9b404e880c31b24d207dc9a5648e';

/// See also [otherBlockingChanges].
@ProviderFor(otherBlockingChanges)
const otherBlockingChangesProvider = OtherBlockingChangesFamily();

/// See also [otherBlockingChanges].
class OtherBlockingChangesFamily extends Family<AsyncValue<bool>> {
  /// See also [otherBlockingChanges].
  const OtherBlockingChangesFamily();

  /// See also [otherBlockingChanges].
  OtherBlockingChangesProvider call(
    String otherProfileId,
  ) {
    return OtherBlockingChangesProvider(
      otherProfileId,
    );
  }

  @override
  OtherBlockingChangesProvider getProviderOverride(
    covariant OtherBlockingChangesProvider provider,
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
  String? get name => r'otherBlockingChangesProvider';
}

/// See also [otherBlockingChanges].
class OtherBlockingChangesProvider extends AutoDisposeStreamProvider<bool> {
  /// See also [otherBlockingChanges].
  OtherBlockingChangesProvider(
    String otherProfileId,
  ) : this._internal(
          (ref) => otherBlockingChanges(
            ref as OtherBlockingChangesRef,
            otherProfileId,
          ),
          from: otherBlockingChangesProvider,
          name: r'otherBlockingChangesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$otherBlockingChangesHash,
          dependencies: OtherBlockingChangesFamily._dependencies,
          allTransitiveDependencies:
              OtherBlockingChangesFamily._allTransitiveDependencies,
          otherProfileId: otherProfileId,
        );

  OtherBlockingChangesProvider._internal(
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
    Stream<bool> Function(OtherBlockingChangesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OtherBlockingChangesProvider._internal(
        (ref) => create(ref as OtherBlockingChangesRef),
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
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _OtherBlockingChangesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OtherBlockingChangesProvider &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OtherBlockingChangesRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _OtherBlockingChangesProviderElement
    extends AutoDisposeStreamProviderElement<bool>
    with OtherBlockingChangesRef {
  _OtherBlockingChangesProviderElement(super.provider);

  @override
  String get otherProfileId =>
      (origin as OtherBlockingChangesProvider).otherProfileId;
}

String _$blockedByChangesHash() => r'878fb3e193bb8389a0dad48bb3f5c53760c69f4f';

/// See also [blockedByChanges].
@ProviderFor(blockedByChanges)
const blockedByChangesProvider = BlockedByChangesFamily();

/// See also [blockedByChanges].
class BlockedByChangesFamily extends Family<AsyncValue<BlockState>> {
  /// See also [blockedByChanges].
  const BlockedByChangesFamily();

  /// See also [blockedByChanges].
  BlockedByChangesProvider call(
    String otherProfileId,
  ) {
    return BlockedByChangesProvider(
      otherProfileId,
    );
  }

  @override
  BlockedByChangesProvider getProviderOverride(
    covariant BlockedByChangesProvider provider,
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
  String? get name => r'blockedByChangesProvider';
}

/// See also [blockedByChanges].
class BlockedByChangesProvider extends AutoDisposeFutureProvider<BlockState> {
  /// See also [blockedByChanges].
  BlockedByChangesProvider(
    String otherProfileId,
  ) : this._internal(
          (ref) => blockedByChanges(
            ref as BlockedByChangesRef,
            otherProfileId,
          ),
          from: blockedByChangesProvider,
          name: r'blockedByChangesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$blockedByChangesHash,
          dependencies: BlockedByChangesFamily._dependencies,
          allTransitiveDependencies:
              BlockedByChangesFamily._allTransitiveDependencies,
          otherProfileId: otherProfileId,
        );

  BlockedByChangesProvider._internal(
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
    FutureOr<BlockState> Function(BlockedByChangesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BlockedByChangesProvider._internal(
        (ref) => create(ref as BlockedByChangesRef),
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
  AutoDisposeFutureProviderElement<BlockState> createElement() {
    return _BlockedByChangesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BlockedByChangesProvider &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BlockedByChangesRef on AutoDisposeFutureProviderRef<BlockState> {
  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _BlockedByChangesProviderElement
    extends AutoDisposeFutureProviderElement<BlockState>
    with BlockedByChangesRef {
  _BlockedByChangesProviderElement(super.provider);

  @override
  String get otherProfileId =>
      (origin as BlockedByChangesProvider).otherProfileId;
}

String _$userAccessStreamHash() => r'41a6938e48d40848084fed0124fa2e70fc135dfc';

/// See also [userAccessStream].
@ProviderFor(userAccessStream)
final userAccessStreamProvider = AutoDisposeStreamProvider<UserAccess>.internal(
  userAccessStream,
  name: r'userAccessStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userAccessStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserAccessStreamRef = AutoDisposeStreamProviderRef<UserAccess>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
