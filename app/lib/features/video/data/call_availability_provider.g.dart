// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_availability_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$callAvailabilityHash() => r'3cf72dac18a52917766496bba206e0283e32a31e';

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

abstract class _$CallAvailability
    extends BuildlessAutoDisposeAsyncNotifier<CallAvailabilityState> {
  late final String otherProfileId;

  FutureOr<CallAvailabilityState> build(
    String otherProfileId,
  );
}

/// See also [CallAvailability].
@ProviderFor(CallAvailability)
const callAvailabilityProvider = CallAvailabilityFamily();

/// See also [CallAvailability].
class CallAvailabilityFamily extends Family<AsyncValue<CallAvailabilityState>> {
  /// See also [CallAvailability].
  const CallAvailabilityFamily();

  /// See also [CallAvailability].
  CallAvailabilityProvider call(
    String otherProfileId,
  ) {
    return CallAvailabilityProvider(
      otherProfileId,
    );
  }

  @override
  CallAvailabilityProvider getProviderOverride(
    covariant CallAvailabilityProvider provider,
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
  String? get name => r'callAvailabilityProvider';
}

/// See also [CallAvailability].
class CallAvailabilityProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CallAvailability, CallAvailabilityState> {
  /// See also [CallAvailability].
  CallAvailabilityProvider(
    String otherProfileId,
  ) : this._internal(
          () => CallAvailability()..otherProfileId = otherProfileId,
          from: callAvailabilityProvider,
          name: r'callAvailabilityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$callAvailabilityHash,
          dependencies: CallAvailabilityFamily._dependencies,
          allTransitiveDependencies:
              CallAvailabilityFamily._allTransitiveDependencies,
          otherProfileId: otherProfileId,
        );

  CallAvailabilityProvider._internal(
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
  FutureOr<CallAvailabilityState> runNotifierBuild(
    covariant CallAvailability notifier,
  ) {
    return notifier.build(
      otherProfileId,
    );
  }

  @override
  Override overrideWith(CallAvailability Function() create) {
    return ProviderOverride(
      origin: this,
      override: CallAvailabilityProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<CallAvailability,
      CallAvailabilityState> createElement() {
    return _CallAvailabilityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CallAvailabilityProvider &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CallAvailabilityRef
    on AutoDisposeAsyncNotifierProviderRef<CallAvailabilityState> {
  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _CallAvailabilityProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CallAvailability,
        CallAvailabilityState> with CallAvailabilityRef {
  _CallAvailabilityProviderElement(super.provider);

  @override
  String get otherProfileId =>
      (origin as CallAvailabilityProvider).otherProfileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
