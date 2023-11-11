// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_tile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoTileControllerHash() =>
    r'28b12ecf1609c2969dd37d71bbad5e604e619714';

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

abstract class _$VideoTileController
    extends BuildlessAutoDisposeNotifier<VideoStream?> {
  late final VideoParticipant videoParticipant;

  VideoStream? build(
    VideoParticipant videoParticipant,
  );
}

/// See also [VideoTileController].
@ProviderFor(VideoTileController)
const videoTileControllerProvider = VideoTileControllerFamily();

/// See also [VideoTileController].
class VideoTileControllerFamily extends Family<VideoStream?> {
  /// See also [VideoTileController].
  const VideoTileControllerFamily();

  /// See also [VideoTileController].
  VideoTileControllerProvider call(
    VideoParticipant videoParticipant,
  ) {
    return VideoTileControllerProvider(
      videoParticipant,
    );
  }

  @override
  VideoTileControllerProvider getProviderOverride(
    covariant VideoTileControllerProvider provider,
  ) {
    return call(
      provider.videoParticipant,
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
  String? get name => r'videoTileControllerProvider';
}

/// See also [VideoTileController].
class VideoTileControllerProvider
    extends AutoDisposeNotifierProviderImpl<VideoTileController, VideoStream?> {
  /// See also [VideoTileController].
  VideoTileControllerProvider(
    VideoParticipant videoParticipant,
  ) : this._internal(
          () => VideoTileController()..videoParticipant = videoParticipant,
          from: videoTileControllerProvider,
          name: r'videoTileControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$videoTileControllerHash,
          dependencies: VideoTileControllerFamily._dependencies,
          allTransitiveDependencies:
              VideoTileControllerFamily._allTransitiveDependencies,
          videoParticipant: videoParticipant,
        );

  VideoTileControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.videoParticipant,
  }) : super.internal();

  final VideoParticipant videoParticipant;

  @override
  VideoStream? runNotifierBuild(
    covariant VideoTileController notifier,
  ) {
    return notifier.build(
      videoParticipant,
    );
  }

  @override
  Override overrideWith(VideoTileController Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideoTileControllerProvider._internal(
        () => create()..videoParticipant = videoParticipant,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        videoParticipant: videoParticipant,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<VideoTileController, VideoStream?>
      createElement() {
    return _VideoTileControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoTileControllerProvider &&
        other.videoParticipant == videoParticipant;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, videoParticipant.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VideoTileControllerRef on AutoDisposeNotifierProviderRef<VideoStream?> {
  /// The parameter `videoParticipant` of this provider.
  VideoParticipant get videoParticipant;
}

class _VideoTileControllerProviderElement
    extends AutoDisposeNotifierProviderElement<VideoTileController,
        VideoStream?> with VideoTileControllerRef {
  _VideoTileControllerProviderElement(super.provider);

  @override
  VideoParticipant get videoParticipant =>
      (origin as VideoTileControllerProvider).videoParticipant;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
