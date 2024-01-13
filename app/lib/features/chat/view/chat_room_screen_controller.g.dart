// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRoomScreenControllerHash() =>
    r'990fd41a5fe319f7c08ed2ab35b74a8774938636';

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

abstract class _$ChatRoomScreenController
    extends BuildlessAutoDisposeAsyncNotifier<ChatRoom> {
  late final String roomId;
  late final String otherProfileId;

  FutureOr<ChatRoom> build(
    String roomId,
    String otherProfileId,
  );
}

/// See also [ChatRoomScreenController].
@ProviderFor(ChatRoomScreenController)
const chatRoomScreenControllerProvider = ChatRoomScreenControllerFamily();

/// See also [ChatRoomScreenController].
class ChatRoomScreenControllerFamily extends Family<AsyncValue<ChatRoom>> {
  /// See also [ChatRoomScreenController].
  const ChatRoomScreenControllerFamily();

  /// See also [ChatRoomScreenController].
  ChatRoomScreenControllerProvider call(
    String roomId,
    String otherProfileId,
  ) {
    return ChatRoomScreenControllerProvider(
      roomId,
      otherProfileId,
    );
  }

  @override
  ChatRoomScreenControllerProvider getProviderOverride(
    covariant ChatRoomScreenControllerProvider provider,
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
  String? get name => r'chatRoomScreenControllerProvider';
}

/// See also [ChatRoomScreenController].
class ChatRoomScreenControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ChatRoomScreenController,
        ChatRoom> {
  /// See also [ChatRoomScreenController].
  ChatRoomScreenControllerProvider(
    String roomId,
    String otherProfileId,
  ) : this._internal(
          () => ChatRoomScreenController()
            ..roomId = roomId
            ..otherProfileId = otherProfileId,
          from: chatRoomScreenControllerProvider,
          name: r'chatRoomScreenControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatRoomScreenControllerHash,
          dependencies: ChatRoomScreenControllerFamily._dependencies,
          allTransitiveDependencies:
              ChatRoomScreenControllerFamily._allTransitiveDependencies,
          roomId: roomId,
          otherProfileId: otherProfileId,
        );

  ChatRoomScreenControllerProvider._internal(
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
  FutureOr<ChatRoom> runNotifierBuild(
    covariant ChatRoomScreenController notifier,
  ) {
    return notifier.build(
      roomId,
      otherProfileId,
    );
  }

  @override
  Override overrideWith(ChatRoomScreenController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatRoomScreenControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ChatRoomScreenController, ChatRoom>
      createElement() {
    return _ChatRoomScreenControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomScreenControllerProvider &&
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

mixin ChatRoomScreenControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ChatRoom> {
  /// The parameter `roomId` of this provider.
  String get roomId;

  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _ChatRoomScreenControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatRoomScreenController,
        ChatRoom> with ChatRoomScreenControllerRef {
  _ChatRoomScreenControllerProviderElement(super.provider);

  @override
  String get roomId => (origin as ChatRoomScreenControllerProvider).roomId;
  @override
  String get otherProfileId =>
      (origin as ChatRoomScreenControllerProvider).otherProfileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
