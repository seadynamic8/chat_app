// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs_navigation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tabsNavigationControllerHash() =>
    r'52f524656c33e190f66a6a8feca93aa034e0f650';

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

abstract class _$TabsNavigationController
    extends BuildlessAutoDisposeNotifier<void> {
  late final void Function(String, String) showBanner;
  late final void Function() closeBanner;

  void build(
    void Function(String, String) showBanner,
    void Function() closeBanner,
  );
}

/// See also [TabsNavigationController].
@ProviderFor(TabsNavigationController)
const tabsNavigationControllerProvider = TabsNavigationControllerFamily();

/// See also [TabsNavigationController].
class TabsNavigationControllerFamily extends Family<void> {
  /// See also [TabsNavigationController].
  const TabsNavigationControllerFamily();

  /// See also [TabsNavigationController].
  TabsNavigationControllerProvider call(
    void Function(String, String) showBanner,
    void Function() closeBanner,
  ) {
    return TabsNavigationControllerProvider(
      showBanner,
      closeBanner,
    );
  }

  @override
  TabsNavigationControllerProvider getProviderOverride(
    covariant TabsNavigationControllerProvider provider,
  ) {
    return call(
      provider.showBanner,
      provider.closeBanner,
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
  String? get name => r'tabsNavigationControllerProvider';
}

/// See also [TabsNavigationController].
class TabsNavigationControllerProvider
    extends AutoDisposeNotifierProviderImpl<TabsNavigationController, void> {
  /// See also [TabsNavigationController].
  TabsNavigationControllerProvider(
    void Function(String, String) showBanner,
    void Function() closeBanner,
  ) : this._internal(
          () => TabsNavigationController()
            ..showBanner = showBanner
            ..closeBanner = closeBanner,
          from: tabsNavigationControllerProvider,
          name: r'tabsNavigationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tabsNavigationControllerHash,
          dependencies: TabsNavigationControllerFamily._dependencies,
          allTransitiveDependencies:
              TabsNavigationControllerFamily._allTransitiveDependencies,
          showBanner: showBanner,
          closeBanner: closeBanner,
        );

  TabsNavigationControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.showBanner,
    required this.closeBanner,
  }) : super.internal();

  final void Function(String, String) showBanner;
  final void Function() closeBanner;

  @override
  void runNotifierBuild(
    covariant TabsNavigationController notifier,
  ) {
    return notifier.build(
      showBanner,
      closeBanner,
    );
  }

  @override
  Override overrideWith(TabsNavigationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: TabsNavigationControllerProvider._internal(
        () => create()
          ..showBanner = showBanner
          ..closeBanner = closeBanner,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        showBanner: showBanner,
        closeBanner: closeBanner,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TabsNavigationController, void>
      createElement() {
    return _TabsNavigationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TabsNavigationControllerProvider &&
        other.showBanner == showBanner &&
        other.closeBanner == closeBanner;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, showBanner.hashCode);
    hash = _SystemHash.combine(hash, closeBanner.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TabsNavigationControllerRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `showBanner` of this provider.
  void Function(String, String) get showBanner;

  /// The parameter `closeBanner` of this provider.
  void Function() get closeBanner;
}

class _TabsNavigationControllerProviderElement
    extends AutoDisposeNotifierProviderElement<TabsNavigationController, void>
    with TabsNavigationControllerRef {
  _TabsNavigationControllerProviderElement(super.provider);

  @override
  void Function(String, String) get showBanner =>
      (origin as TabsNavigationControllerProvider).showBanner;
  @override
  void Function() get closeBanner =>
      (origin as TabsNavigationControllerProvider).closeBanner;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
