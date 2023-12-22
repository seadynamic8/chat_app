// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRoomScreenControllerHash() =>
    r'd5ea503014ab11313120caeab423fdcde03c28d8';

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
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, Profile>> {
  late final String otherProfileId;

  FutureOr<Map<String, Profile>> build(
    String otherProfileId,
  );
}

/// See also [ChatRoomScreenController].
@ProviderFor(ChatRoomScreenController)
const chatRoomScreenControllerProvider = ChatRoomScreenControllerFamily();

/// See also [ChatRoomScreenController].
class ChatRoomScreenControllerFamily
    extends Family<AsyncValue<Map<String, Profile>>> {
  /// See also [ChatRoomScreenController].
  const ChatRoomScreenControllerFamily();

  /// See also [ChatRoomScreenController].
  ChatRoomScreenControllerProvider call(
    String otherProfileId,
  ) {
    return ChatRoomScreenControllerProvider(
      otherProfileId,
    );
  }

  @override
  ChatRoomScreenControllerProvider getProviderOverride(
    covariant ChatRoomScreenControllerProvider provider,
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
  String? get name => r'chatRoomScreenControllerProvider';
}

/// See also [ChatRoomScreenController].
class ChatRoomScreenControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ChatRoomScreenController,
        Map<String, Profile>> {
  /// See also [ChatRoomScreenController].
  ChatRoomScreenControllerProvider(
    String otherProfileId,
  ) : this._internal(
          () => ChatRoomScreenController()..otherProfileId = otherProfileId,
          from: chatRoomScreenControllerProvider,
          name: r'chatRoomScreenControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatRoomScreenControllerHash,
          dependencies: ChatRoomScreenControllerFamily._dependencies,
          allTransitiveDependencies:
              ChatRoomScreenControllerFamily._allTransitiveDependencies,
          otherProfileId: otherProfileId,
        );

  ChatRoomScreenControllerProvider._internal(
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
  FutureOr<Map<String, Profile>> runNotifierBuild(
    covariant ChatRoomScreenController notifier,
  ) {
    return notifier.build(
      otherProfileId,
    );
  }

  @override
  Override overrideWith(ChatRoomScreenController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatRoomScreenControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ChatRoomScreenController,
      Map<String, Profile>> createElement() {
    return _ChatRoomScreenControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomScreenControllerProvider &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatRoomScreenControllerRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, Profile>> {
  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _ChatRoomScreenControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatRoomScreenController,
        Map<String, Profile>> with ChatRoomScreenControllerRef {
  _ChatRoomScreenControllerProviderElement(super.provider);

  @override
  String get otherProfileId =>
      (origin as ChatRoomScreenControllerProvider).otherProfileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
