// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_lobby_item_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatLobbyItemControllerHash() =>
    r'1aa85d366e68686a71d1b75b0014293ecaf9b611';

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

abstract class _$ChatLobbyItemController
    extends BuildlessAutoDisposeAsyncNotifier<ChatLobbyItemState?> {
  late final String roomId;

  FutureOr<ChatLobbyItemState?> build(
    String roomId,
  );
}

/// See also [ChatLobbyItemController].
@ProviderFor(ChatLobbyItemController)
const chatLobbyItemControllerProvider = ChatLobbyItemControllerFamily();

/// See also [ChatLobbyItemController].
class ChatLobbyItemControllerFamily
    extends Family<AsyncValue<ChatLobbyItemState?>> {
  /// See also [ChatLobbyItemController].
  const ChatLobbyItemControllerFamily();

  /// See also [ChatLobbyItemController].
  ChatLobbyItemControllerProvider call(
    String roomId,
  ) {
    return ChatLobbyItemControllerProvider(
      roomId,
    );
  }

  @override
  ChatLobbyItemControllerProvider getProviderOverride(
    covariant ChatLobbyItemControllerProvider provider,
  ) {
    return call(
      provider.roomId,
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
  String? get name => r'chatLobbyItemControllerProvider';
}

/// See also [ChatLobbyItemController].
class ChatLobbyItemControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ChatLobbyItemController,
        ChatLobbyItemState?> {
  /// See also [ChatLobbyItemController].
  ChatLobbyItemControllerProvider(
    String roomId,
  ) : this._internal(
          () => ChatLobbyItemController()..roomId = roomId,
          from: chatLobbyItemControllerProvider,
          name: r'chatLobbyItemControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatLobbyItemControllerHash,
          dependencies: ChatLobbyItemControllerFamily._dependencies,
          allTransitiveDependencies:
              ChatLobbyItemControllerFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  ChatLobbyItemControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
  }) : super.internal();

  final String roomId;

  @override
  FutureOr<ChatLobbyItemState?> runNotifierBuild(
    covariant ChatLobbyItemController notifier,
  ) {
    return notifier.build(
      roomId,
    );
  }

  @override
  Override overrideWith(ChatLobbyItemController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatLobbyItemControllerProvider._internal(
        () => create()..roomId = roomId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChatLobbyItemController,
      ChatLobbyItemState?> createElement() {
    return _ChatLobbyItemControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatLobbyItemControllerProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatLobbyItemControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ChatLobbyItemState?> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _ChatLobbyItemControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatLobbyItemController,
        ChatLobbyItemState?> with ChatLobbyItemControllerRef {
  _ChatLobbyItemControllerProviderElement(super.provider);

  @override
  String get roomId => (origin as ChatLobbyItemControllerProvider).roomId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
