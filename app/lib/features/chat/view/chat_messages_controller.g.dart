// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_messages_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatMessagesControllerHash() =>
    r'5a35d5c867d3a14b20e58e48d77053a0fc78f825';

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
    extends BuildlessAutoDisposeNotifier<PagingController<int, Message>> {
  late final String roomId;

  PagingController<int, Message> build(
    String roomId,
  );
}

/// See also [ChatMessagesController].
@ProviderFor(ChatMessagesController)
const chatMessagesControllerProvider = ChatMessagesControllerFamily();

/// See also [ChatMessagesController].
class ChatMessagesControllerFamily
    extends Family<PagingController<int, Message>> {
  /// See also [ChatMessagesController].
  const ChatMessagesControllerFamily();

  /// See also [ChatMessagesController].
  ChatMessagesControllerProvider call(
    String roomId,
  ) {
    return ChatMessagesControllerProvider(
      roomId,
    );
  }

  @override
  ChatMessagesControllerProvider getProviderOverride(
    covariant ChatMessagesControllerProvider provider,
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
  String? get name => r'chatMessagesControllerProvider';
}

/// See also [ChatMessagesController].
class ChatMessagesControllerProvider extends AutoDisposeNotifierProviderImpl<
    ChatMessagesController, PagingController<int, Message>> {
  /// See also [ChatMessagesController].
  ChatMessagesControllerProvider(
    String roomId,
  ) : this._internal(
          () => ChatMessagesController()..roomId = roomId,
          from: chatMessagesControllerProvider,
          name: r'chatMessagesControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMessagesControllerHash,
          dependencies: ChatMessagesControllerFamily._dependencies,
          allTransitiveDependencies:
              ChatMessagesControllerFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  ChatMessagesControllerProvider._internal(
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
  PagingController<int, Message> runNotifierBuild(
    covariant ChatMessagesController notifier,
  ) {
    return notifier.build(
      roomId,
    );
  }

  @override
  Override overrideWith(ChatMessagesController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<ChatMessagesController,
      PagingController<int, Message>> createElement() {
    return _ChatMessagesControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesControllerProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatMessagesControllerRef
    on AutoDisposeNotifierProviderRef<PagingController<int, Message>> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _ChatMessagesControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ChatMessagesController,
        PagingController<int, Message>> with ChatMessagesControllerRef {
  _ChatMessagesControllerProviderElement(super.provider);

  @override
  String get roomId => (origin as ChatMessagesControllerProvider).roomId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
