// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paywall_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paywallRepositoryHash() => r'e3629d48175578e388904f56952dbcce08070121';

/// See also [paywallRepository].
@ProviderFor(paywallRepository)
final paywallRepositoryProvider =
    AutoDisposeProvider<PaywallRepository>.internal(
  paywallRepository,
  name: r'paywallRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paywallRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PaywallRepositoryRef = AutoDisposeProviderRef<PaywallRepository>;
String _$paywallProductsHash() => r'9cd974accbab7362af84155418e45f8db8ad5e5c';

/// See also [paywallProducts].
@ProviderFor(paywallProducts)
final paywallProductsProvider =
    AutoDisposeFutureProvider<List<Product>>.internal(
  paywallProducts,
  name: r'paywallProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paywallProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PaywallProductsRef = AutoDisposeFutureProviderRef<List<Product>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
