// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_room_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoRoomControllerHash() =>
    r'067a8e7e626c2d4e294678104fceaefde756d7ee';

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

abstract class _$VideoRoomController
    extends BuildlessAutoDisposeAsyncNotifier<VideoRoomState> {
  late final bool isCaller;

  FutureOr<VideoRoomState> build(
    bool isCaller,
  );
}

/// See also [VideoRoomController].
@ProviderFor(VideoRoomController)
const videoRoomControllerProvider = VideoRoomControllerFamily();

/// See also [VideoRoomController].
class VideoRoomControllerFamily extends Family<AsyncValue<VideoRoomState>> {
  /// See also [VideoRoomController].
  const VideoRoomControllerFamily();

  /// See also [VideoRoomController].
  VideoRoomControllerProvider call(
    bool isCaller,
  ) {
    return VideoRoomControllerProvider(
      isCaller,
    );
  }

  @override
  VideoRoomControllerProvider getProviderOverride(
    covariant VideoRoomControllerProvider provider,
  ) {
    return call(
      provider.isCaller,
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
  String? get name => r'videoRoomControllerProvider';
}

/// See also [VideoRoomController].
class VideoRoomControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    VideoRoomController, VideoRoomState> {
  /// See also [VideoRoomController].
  VideoRoomControllerProvider(
    bool isCaller,
  ) : this._internal(
          () => VideoRoomController()..isCaller = isCaller,
          from: videoRoomControllerProvider,
          name: r'videoRoomControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$videoRoomControllerHash,
          dependencies: VideoRoomControllerFamily._dependencies,
          allTransitiveDependencies:
              VideoRoomControllerFamily._allTransitiveDependencies,
          isCaller: isCaller,
        );

  VideoRoomControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isCaller,
  }) : super.internal();

  final bool isCaller;

  @override
  FutureOr<VideoRoomState> runNotifierBuild(
    covariant VideoRoomController notifier,
  ) {
    return notifier.build(
      isCaller,
    );
  }

  @override
  Override overrideWith(VideoRoomController Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideoRoomControllerProvider._internal(
        () => create()..isCaller = isCaller,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isCaller: isCaller,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VideoRoomController, VideoRoomState>
      createElement() {
    return _VideoRoomControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoRoomControllerProvider && other.isCaller == isCaller;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isCaller.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VideoRoomControllerRef
    on AutoDisposeAsyncNotifierProviderRef<VideoRoomState> {
  /// The parameter `isCaller` of this provider.
  bool get isCaller;
}

class _VideoRoomControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VideoRoomController,
        VideoRoomState> with VideoRoomControllerRef {
  _VideoRoomControllerProviderElement(super.provider);

  @override
  bool get isCaller => (origin as VideoRoomControllerProvider).isCaller;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
