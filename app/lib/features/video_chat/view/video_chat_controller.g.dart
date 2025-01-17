// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoChatControllerHash() =>
    r'23a961e8af6e1bf4a7d8c3921728590b1d93d798';

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

abstract class _$VideoChatController
    extends BuildlessAutoDisposeAsyncNotifier<List<VideoChatMessage>> {
  late final String otherProfileId;

  FutureOr<List<VideoChatMessage>> build(
    String otherProfileId,
  );
}

/// See also [VideoChatController].
@ProviderFor(VideoChatController)
const videoChatControllerProvider = VideoChatControllerFamily();

/// See also [VideoChatController].
class VideoChatControllerFamily
    extends Family<AsyncValue<List<VideoChatMessage>>> {
  /// See also [VideoChatController].
  const VideoChatControllerFamily();

  /// See also [VideoChatController].
  VideoChatControllerProvider call(
    String otherProfileId,
  ) {
    return VideoChatControllerProvider(
      otherProfileId,
    );
  }

  @override
  VideoChatControllerProvider getProviderOverride(
    covariant VideoChatControllerProvider provider,
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
  String? get name => r'videoChatControllerProvider';
}

/// See also [VideoChatController].
class VideoChatControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    VideoChatController, List<VideoChatMessage>> {
  /// See also [VideoChatController].
  VideoChatControllerProvider(
    String otherProfileId,
  ) : this._internal(
          () => VideoChatController()..otherProfileId = otherProfileId,
          from: videoChatControllerProvider,
          name: r'videoChatControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$videoChatControllerHash,
          dependencies: VideoChatControllerFamily._dependencies,
          allTransitiveDependencies:
              VideoChatControllerFamily._allTransitiveDependencies,
          otherProfileId: otherProfileId,
        );

  VideoChatControllerProvider._internal(
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
  FutureOr<List<VideoChatMessage>> runNotifierBuild(
    covariant VideoChatController notifier,
  ) {
    return notifier.build(
      otherProfileId,
    );
  }

  @override
  Override overrideWith(VideoChatController Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideoChatControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<VideoChatController,
      List<VideoChatMessage>> createElement() {
    return _VideoChatControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoChatControllerProvider &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VideoChatControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<VideoChatMessage>> {
  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _VideoChatControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VideoChatController,
        List<VideoChatMessage>> with VideoChatControllerRef {
  _VideoChatControllerProviderElement(super.provider);

  @override
  String get otherProfileId =>
      (origin as VideoChatControllerProvider).otherProfileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
