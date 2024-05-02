// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_profile_buttons_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$publicProfileButtonsControllerHash() =>
    r'56320b7f6dde53bcf74d79c118a326f7a8d84484';

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

abstract class _$PublicProfileButtonsController
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String otherProfileId;

  FutureOr<bool> build(
    String otherProfileId,
  );
}

/// See also [PublicProfileButtonsController].
@ProviderFor(PublicProfileButtonsController)
const publicProfileButtonsControllerProvider =
    PublicProfileButtonsControllerFamily();

/// See also [PublicProfileButtonsController].
class PublicProfileButtonsControllerFamily extends Family<AsyncValue<bool>> {
  /// See also [PublicProfileButtonsController].
  const PublicProfileButtonsControllerFamily();

  /// See also [PublicProfileButtonsController].
  PublicProfileButtonsControllerProvider call(
    String otherProfileId,
  ) {
    return PublicProfileButtonsControllerProvider(
      otherProfileId,
    );
  }

  @override
  PublicProfileButtonsControllerProvider getProviderOverride(
    covariant PublicProfileButtonsControllerProvider provider,
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
  String? get name => r'publicProfileButtonsControllerProvider';
}

/// See also [PublicProfileButtonsController].
class PublicProfileButtonsControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PublicProfileButtonsController,
        bool> {
  /// See also [PublicProfileButtonsController].
  PublicProfileButtonsControllerProvider(
    String otherProfileId,
  ) : this._internal(
          () =>
              PublicProfileButtonsController()..otherProfileId = otherProfileId,
          from: publicProfileButtonsControllerProvider,
          name: r'publicProfileButtonsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$publicProfileButtonsControllerHash,
          dependencies: PublicProfileButtonsControllerFamily._dependencies,
          allTransitiveDependencies:
              PublicProfileButtonsControllerFamily._allTransitiveDependencies,
          otherProfileId: otherProfileId,
        );

  PublicProfileButtonsControllerProvider._internal(
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
  FutureOr<bool> runNotifierBuild(
    covariant PublicProfileButtonsController notifier,
  ) {
    return notifier.build(
      otherProfileId,
    );
  }

  @override
  Override overrideWith(PublicProfileButtonsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PublicProfileButtonsControllerProvider._internal(
        () => create()..otherProfileId = otherProfileId,
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
  AutoDisposeAsyncNotifierProviderElement<PublicProfileButtonsController, bool>
      createElement() {
    return _PublicProfileButtonsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicProfileButtonsControllerProvider &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PublicProfileButtonsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _PublicProfileButtonsControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        PublicProfileButtonsController,
        bool> with PublicProfileButtonsControllerRef {
  _PublicProfileButtonsControllerProviderElement(super.provider);

  @override
  String get otherProfileId =>
      (origin as PublicProfileButtonsControllerProvider).otherProfileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
