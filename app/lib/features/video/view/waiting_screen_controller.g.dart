// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiting_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waitingScreenControllerHash() =>
    r'4a11138d9ff7620920fd9594820a5cfa6c28a706';

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

abstract class _$WaitingScreenController
    extends BuildlessAutoDisposeNotifier<void> {
  late final Profile otherProfile;
  late final void Function(String) initiateCall;
  late final void Function() cancelWait;

  void build(
    Profile otherProfile,
    void Function(String) initiateCall,
    void Function() cancelWait,
  );
}

/// See also [WaitingScreenController].
@ProviderFor(WaitingScreenController)
const waitingScreenControllerProvider = WaitingScreenControllerFamily();

/// See also [WaitingScreenController].
class WaitingScreenControllerFamily extends Family<void> {
  /// See also [WaitingScreenController].
  const WaitingScreenControllerFamily();

  /// See also [WaitingScreenController].
  WaitingScreenControllerProvider call(
    Profile otherProfile,
    void Function(String) initiateCall,
    void Function() cancelWait,
  ) {
    return WaitingScreenControllerProvider(
      otherProfile,
      initiateCall,
      cancelWait,
    );
  }

  @override
  WaitingScreenControllerProvider getProviderOverride(
    covariant WaitingScreenControllerProvider provider,
  ) {
    return call(
      provider.otherProfile,
      provider.initiateCall,
      provider.cancelWait,
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
  String? get name => r'waitingScreenControllerProvider';
}

/// See also [WaitingScreenController].
class WaitingScreenControllerProvider
    extends AutoDisposeNotifierProviderImpl<WaitingScreenController, void> {
  /// See also [WaitingScreenController].
  WaitingScreenControllerProvider(
    Profile otherProfile,
    void Function(String) initiateCall,
    void Function() cancelWait,
  ) : this._internal(
          () => WaitingScreenController()
            ..otherProfile = otherProfile
            ..initiateCall = initiateCall
            ..cancelWait = cancelWait,
          from: waitingScreenControllerProvider,
          name: r'waitingScreenControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$waitingScreenControllerHash,
          dependencies: WaitingScreenControllerFamily._dependencies,
          allTransitiveDependencies:
              WaitingScreenControllerFamily._allTransitiveDependencies,
          otherProfile: otherProfile,
          initiateCall: initiateCall,
          cancelWait: cancelWait,
        );

  WaitingScreenControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.otherProfile,
    required this.initiateCall,
    required this.cancelWait,
  }) : super.internal();

  final Profile otherProfile;
  final void Function(String) initiateCall;
  final void Function() cancelWait;

  @override
  void runNotifierBuild(
    covariant WaitingScreenController notifier,
  ) {
    return notifier.build(
      otherProfile,
      initiateCall,
      cancelWait,
    );
  }

  @override
  Override overrideWith(WaitingScreenController Function() create) {
    return ProviderOverride(
      origin: this,
      override: WaitingScreenControllerProvider._internal(
        () => create()
          ..otherProfile = otherProfile
          ..initiateCall = initiateCall
          ..cancelWait = cancelWait,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        otherProfile: otherProfile,
        initiateCall: initiateCall,
        cancelWait: cancelWait,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WaitingScreenController, void>
      createElement() {
    return _WaitingScreenControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WaitingScreenControllerProvider &&
        other.otherProfile == otherProfile &&
        other.initiateCall == initiateCall &&
        other.cancelWait == cancelWait;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfile.hashCode);
    hash = _SystemHash.combine(hash, initiateCall.hashCode);
    hash = _SystemHash.combine(hash, cancelWait.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WaitingScreenControllerRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `otherProfile` of this provider.
  Profile get otherProfile;

  /// The parameter `initiateCall` of this provider.
  void Function(String) get initiateCall;

  /// The parameter `cancelWait` of this provider.
  void Function() get cancelWait;
}

class _WaitingScreenControllerProviderElement
    extends AutoDisposeNotifierProviderElement<WaitingScreenController, void>
    with WaitingScreenControllerRef {
  _WaitingScreenControllerProviderElement(super.provider);

  @override
  Profile get otherProfile =>
      (origin as WaitingScreenControllerProvider).otherProfile;
  @override
  void Function(String) get initiateCall =>
      (origin as WaitingScreenControllerProvider).initiateCall;
  @override
  void Function() get cancelWait =>
      (origin as WaitingScreenControllerProvider).cancelWait;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
