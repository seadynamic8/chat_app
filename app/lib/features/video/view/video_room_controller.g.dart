// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_room_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoRoomControllerHash() =>
    r'5ee8b32f420659545578c23fb2ab6b390470d0a2';

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
  late final String otherProfileId;

  FutureOr<VideoRoomState> build(
    String otherProfileId,
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
    String otherProfileId,
  ) {
    return VideoRoomControllerProvider(
      otherProfileId,
    );
  }

  @override
  VideoRoomControllerProvider getProviderOverride(
    covariant VideoRoomControllerProvider provider,
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
  String? get name => r'videoRoomControllerProvider';
}

/// See also [VideoRoomController].
class VideoRoomControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    VideoRoomController, VideoRoomState> {
  /// See also [VideoRoomController].
  VideoRoomControllerProvider(
    String otherProfileId,
  ) : this._internal(
          () => VideoRoomController()..otherProfileId = otherProfileId,
          from: videoRoomControllerProvider,
          name: r'videoRoomControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$videoRoomControllerHash,
          dependencies: VideoRoomControllerFamily._dependencies,
          allTransitiveDependencies:
              VideoRoomControllerFamily._allTransitiveDependencies,
          otherProfileId: otherProfileId,
        );

  VideoRoomControllerProvider._internal(
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
  FutureOr<VideoRoomState> runNotifierBuild(
    covariant VideoRoomController notifier,
  ) {
    return notifier.build(
      otherProfileId,
    );
  }

  @override
  Override overrideWith(VideoRoomController Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideoRoomControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<VideoRoomController, VideoRoomState>
      createElement() {
    return _VideoRoomControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoRoomControllerProvider &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VideoRoomControllerRef
    on AutoDisposeAsyncNotifierProviderRef<VideoRoomState> {
  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _VideoRoomControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VideoRoomController,
        VideoRoomState> with VideoRoomControllerRef {
  _VideoRoomControllerProviderElement(super.provider);

  @override
  String get otherProfileId =>
      (origin as VideoRoomControllerProvider).otherProfileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
