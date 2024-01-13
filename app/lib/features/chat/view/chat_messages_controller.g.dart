// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_messages_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatMessagesControllerHash() =>
    r'0d8e5c020da761dd04f1fb96d20de3f09c602dfe';

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

abstract class _$ChatMessagesController
    extends BuildlessAutoDisposeAsyncNotifier<PaginationState<Message>> {
  late final ChatRoom chatRoom;

  FutureOr<PaginationState<Message>> build(
    ChatRoom chatRoom,
  );
}

/// See also [ChatMessagesController].
@ProviderFor(ChatMessagesController)
const chatMessagesControllerProvider = ChatMessagesControllerFamily();

/// See also [ChatMessagesController].
class ChatMessagesControllerFamily
    extends Family<AsyncValue<PaginationState<Message>>> {
  /// See also [ChatMessagesController].
  const ChatMessagesControllerFamily();

  /// See also [ChatMessagesController].
  ChatMessagesControllerProvider call(
    ChatRoom chatRoom,
  ) {
    return ChatMessagesControllerProvider(
      chatRoom,
    );
  }

  @override
  ChatMessagesControllerProvider getProviderOverride(
    covariant ChatMessagesControllerProvider provider,
  ) {
    return call(
      provider.chatRoom,
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
  String? get name => r'chatMessagesControllerProvider';
}

/// See also [ChatMessagesController].
class ChatMessagesControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ChatMessagesController,
        PaginationState<Message>> {
  /// See also [ChatMessagesController].
  ChatMessagesControllerProvider(
    ChatRoom chatRoom,
  ) : this._internal(
          () => ChatMessagesController()..chatRoom = chatRoom,
          from: chatMessagesControllerProvider,
          name: r'chatMessagesControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMessagesControllerHash,
          dependencies: ChatMessagesControllerFamily._dependencies,
          allTransitiveDependencies:
              ChatMessagesControllerFamily._allTransitiveDependencies,
          chatRoom: chatRoom,
        );

  ChatMessagesControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatRoom,
  }) : super.internal();

  final ChatRoom chatRoom;

  @override
  FutureOr<PaginationState<Message>> runNotifierBuild(
    covariant ChatMessagesController notifier,
  ) {
    return notifier.build(
      chatRoom,
    );
  }

  @override
  Override overrideWith(ChatMessagesController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesControllerProvider._internal(
        () => create()..chatRoom = chatRoom,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatRoom: chatRoom,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChatMessagesController,
      PaginationState<Message>> createElement() {
    return _ChatMessagesControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesControllerProvider &&
        other.chatRoom == chatRoom;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatRoom.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatMessagesControllerRef
    on AutoDisposeAsyncNotifierProviderRef<PaginationState<Message>> {
  /// The parameter `chatRoom` of this provider.
  ChatRoom get chatRoom;
}

class _ChatMessagesControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatMessagesController,
        PaginationState<Message>> with ChatMessagesControllerRef {
  _ChatMessagesControllerProviderElement(super.provider);

  @override
  ChatRoom get chatRoom => (origin as ChatMessagesControllerProvider).chatRoom;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
