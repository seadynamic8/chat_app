// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_messages_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatMessagesControllerHash() =>
    r'5c2da0ac4f32cd00e874b29446b7e2547d141a6e';

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
  late final String roomId;
  late final Map<String, Profile> profiles;

  FutureOr<PaginationState<Message>> build(
    String roomId,
    Map<String, Profile> profiles,
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
    String roomId,
    Map<String, Profile> profiles,
  ) {
    return ChatMessagesControllerProvider(
      roomId,
      profiles,
    );
  }

  @override
  ChatMessagesControllerProvider getProviderOverride(
    covariant ChatMessagesControllerProvider provider,
  ) {
    return call(
      provider.roomId,
      provider.profiles,
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
    String roomId,
    Map<String, Profile> profiles,
  ) : this._internal(
          () => ChatMessagesController()
            ..roomId = roomId
            ..profiles = profiles,
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
          profiles: profiles,
        );

  ChatMessagesControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
    required this.profiles,
  }) : super.internal();

  final String roomId;
  final Map<String, Profile> profiles;

  @override
  FutureOr<PaginationState<Message>> runNotifierBuild(
    covariant ChatMessagesController notifier,
  ) {
    return notifier.build(
      roomId,
      profiles,
    );
  }

  @override
  Override overrideWith(ChatMessagesController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesControllerProvider._internal(
        () => create()
          ..roomId = roomId
          ..profiles = profiles,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
        profiles: profiles,
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
        other.roomId == roomId &&
        other.profiles == profiles;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);
    hash = _SystemHash.combine(hash, profiles.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatMessagesControllerRef
    on AutoDisposeAsyncNotifierProviderRef<PaginationState<Message>> {
  /// The parameter `roomId` of this provider.
  String get roomId;

  /// The parameter `profiles` of this provider.
  Map<String, Profile> get profiles;
}

class _ChatMessagesControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatMessagesController,
        PaginationState<Message>> with ChatMessagesControllerRef {
  _ChatMessagesControllerProviderElement(super.provider);

  @override
  String get roomId => (origin as ChatMessagesControllerProvider).roomId;
  @override
  Map<String, Profile> get profiles =>
      (origin as ChatMessagesControllerProvider).profiles;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
