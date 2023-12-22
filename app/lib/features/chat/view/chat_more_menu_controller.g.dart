// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_more_menu_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatMoreMenuControllerHash() =>
    r'3254ebc91e8f99067907f9733a289fb2a916bb21';

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

abstract class _$ChatMoreMenuController
    extends BuildlessAutoDisposeAsyncNotifier<ChatBlockAction> {
  late final String roomId;
  late final String otherProfileId;

  FutureOr<ChatBlockAction> build(
    String roomId,
    String otherProfileId,
  );
}

/// See also [ChatMoreMenuController].
@ProviderFor(ChatMoreMenuController)
const chatMoreMenuControllerProvider = ChatMoreMenuControllerFamily();

/// See also [ChatMoreMenuController].
class ChatMoreMenuControllerFamily extends Family<AsyncValue<ChatBlockAction>> {
  /// See also [ChatMoreMenuController].
  const ChatMoreMenuControllerFamily();

  /// See also [ChatMoreMenuController].
  ChatMoreMenuControllerProvider call(
    String roomId,
    String otherProfileId,
  ) {
    return ChatMoreMenuControllerProvider(
      roomId,
      otherProfileId,
    );
  }

  @override
  ChatMoreMenuControllerProvider getProviderOverride(
    covariant ChatMoreMenuControllerProvider provider,
  ) {
    return call(
      provider.roomId,
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
  String? get name => r'chatMoreMenuControllerProvider';
}

/// See also [ChatMoreMenuController].
class ChatMoreMenuControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ChatMoreMenuController,
        ChatBlockAction> {
  /// See also [ChatMoreMenuController].
  ChatMoreMenuControllerProvider(
    String roomId,
    String otherProfileId,
  ) : this._internal(
          () => ChatMoreMenuController()
            ..roomId = roomId
            ..otherProfileId = otherProfileId,
          from: chatMoreMenuControllerProvider,
          name: r'chatMoreMenuControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMoreMenuControllerHash,
          dependencies: ChatMoreMenuControllerFamily._dependencies,
          allTransitiveDependencies:
              ChatMoreMenuControllerFamily._allTransitiveDependencies,
          roomId: roomId,
          otherProfileId: otherProfileId,
        );

  ChatMoreMenuControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
    required this.otherProfileId,
  }) : super.internal();

  final String roomId;
  final String otherProfileId;

  @override
  FutureOr<ChatBlockAction> runNotifierBuild(
    covariant ChatMoreMenuController notifier,
  ) {
    return notifier.build(
      roomId,
      otherProfileId,
    );
  }

  @override
  Override overrideWith(ChatMoreMenuController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatMoreMenuControllerProvider._internal(
        () => create()
          ..roomId = roomId
          ..otherProfileId = otherProfileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
        otherProfileId: otherProfileId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChatMoreMenuController,
      ChatBlockAction> createElement() {
    return _ChatMoreMenuControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMoreMenuControllerProvider &&
        other.roomId == roomId &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatMoreMenuControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ChatBlockAction> {
  /// The parameter `roomId` of this provider.
  String get roomId;

  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _ChatMoreMenuControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatMoreMenuController,
        ChatBlockAction> with ChatMoreMenuControllerRef {
  _ChatMoreMenuControllerProviderElement(super.provider);

  @override
  String get roomId => (origin as ChatMoreMenuControllerProvider).roomId;
  @override
  String get otherProfileId =>
      (origin as ChatMoreMenuControllerProvider).otherProfileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
