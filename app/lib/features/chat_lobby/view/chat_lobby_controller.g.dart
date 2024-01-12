// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_lobby_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatLobbyControllerHash() =>
    r'80bb51a702935ae13e1a0a30c3020f780d6c899e';

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

abstract class _$ChatLobbyController
    extends BuildlessAutoDisposeAsyncNotifier<PaginationState<Room>> {
  late final RoomType roomType;

  FutureOr<PaginationState<Room>> build(
    RoomType roomType,
  );
}

/// See also [ChatLobbyController].
@ProviderFor(ChatLobbyController)
const chatLobbyControllerProvider = ChatLobbyControllerFamily();

/// See also [ChatLobbyController].
class ChatLobbyControllerFamily
    extends Family<AsyncValue<PaginationState<Room>>> {
  /// See also [ChatLobbyController].
  const ChatLobbyControllerFamily();

  /// See also [ChatLobbyController].
  ChatLobbyControllerProvider call(
    RoomType roomType,
  ) {
    return ChatLobbyControllerProvider(
      roomType,
    );
  }

  @override
  ChatLobbyControllerProvider getProviderOverride(
    covariant ChatLobbyControllerProvider provider,
  ) {
    return call(
      provider.roomType,
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
  String? get name => r'chatLobbyControllerProvider';
}

/// See also [ChatLobbyController].
class ChatLobbyControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ChatLobbyController, PaginationState<Room>> {
  /// See also [ChatLobbyController].
  ChatLobbyControllerProvider(
    RoomType roomType,
  ) : this._internal(
          () => ChatLobbyController()..roomType = roomType,
          from: chatLobbyControllerProvider,
          name: r'chatLobbyControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatLobbyControllerHash,
          dependencies: ChatLobbyControllerFamily._dependencies,
          allTransitiveDependencies:
              ChatLobbyControllerFamily._allTransitiveDependencies,
          roomType: roomType,
        );

  ChatLobbyControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomType,
  }) : super.internal();

  final RoomType roomType;

  @override
  FutureOr<PaginationState<Room>> runNotifierBuild(
    covariant ChatLobbyController notifier,
  ) {
    return notifier.build(
      roomType,
    );
  }

  @override
  Override overrideWith(ChatLobbyController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatLobbyControllerProvider._internal(
        () => create()..roomType = roomType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomType: roomType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChatLobbyController,
      PaginationState<Room>> createElement() {
    return _ChatLobbyControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatLobbyControllerProvider && other.roomType == roomType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatLobbyControllerRef
    on AutoDisposeAsyncNotifierProviderRef<PaginationState<Room>> {
  /// The parameter `roomType` of this provider.
  RoomType get roomType;
}

class _ChatLobbyControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatLobbyController,
        PaginationState<Room>> with ChatLobbyControllerRef {
  _ChatLobbyControllerProviderElement(super.provider);

  @override
  RoomType get roomType => (origin as ChatLobbyControllerProvider).roomType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
