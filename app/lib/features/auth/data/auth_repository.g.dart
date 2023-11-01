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
String _$authRepositoryHash() => r'19330163c4b4d15fbdf307885d1f886386311816';

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
String _$currentProfileHash() => r'ba027875d3087399a1c7c3f2cb07d7662aa5b768';

/// See also [currentProfile].
@ProviderFor(currentProfile)
final currentProfileProvider = AutoDisposeFutureProvider<Profile>.internal(
  currentProfile,
  name: r'currentProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentProfileRef = AutoDisposeFutureProviderRef<Profile>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
