// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_lobby_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatLobbyRepositoryHash() =>
    r'6353457f7e51d00052283cb7c5187421a680be9e';

/// See also [chatLobbyRepository].
@ProviderFor(chatLobbyRepository)
final chatLobbyRepositoryProvider =
    AutoDisposeProvider<ChatLobbyRepository>.internal(
  chatLobbyRepository,
  name: r'chatLobbyRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatLobbyRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatLobbyRepositoryRef = AutoDisposeProviderRef<ChatLobbyRepository>;
String _$findRoomWithUserHash() => r'098a1cb842322a4c3e42705f75a0a227c46271b8';

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

/// See also [findRoomWithUser].
@ProviderFor(findRoomWithUser)
const findRoomWithUserProvider = FindRoomWithUserFamily();

/// See also [findRoomWithUser].
class FindRoomWithUserFamily extends Family<AsyncValue<Room?>> {
  /// See also [findRoomWithUser].
  const FindRoomWithUserFamily();

  /// See also [findRoomWithUser].
  FindRoomWithUserProvider call(
    String otherProfileId,
  ) {
    return FindRoomWithUserProvider(
      otherProfileId,
    );
  }

  @override
  FindRoomWithUserProvider getProviderOverride(
    covariant FindRoomWithUserProvider provider,
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
  String? get name => r'findRoomWithUserProvider';
}

/// See also [findRoomWithUser].
class FindRoomWithUserProvider extends AutoDisposeFutureProvider<Room?> {
  /// See also [findRoomWithUser].
  FindRoomWithUserProvider(
    String otherProfileId,
  ) : this._internal(
          (ref) => findRoomWithUser(
            ref as FindRoomWithUserRef,
            otherProfileId,
          ),
          from: findRoomWithUserProvider,
          name: r'findRoomWithUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$findRoomWithUserHash,
          dependencies: FindRoomWithUserFamily._dependencies,
          allTransitiveDependencies:
              FindRoomWithUserFamily._allTransitiveDependencies,
          otherProfileId: otherProfileId,
        );

  FindRoomWithUserProvider._internal(
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
  Override overrideWith(
    FutureOr<Room?> Function(FindRoomWithUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FindRoomWithUserProvider._internal(
        (ref) => create(ref as FindRoomWithUserRef),
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
  AutoDisposeFutureProviderElement<Room?> createElement() {
    return _FindRoomWithUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FindRoomWithUserProvider &&
        other.otherProfileId == otherProfileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, otherProfileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FindRoomWithUserRef on AutoDisposeFutureProviderRef<Room?> {
  /// The parameter `otherProfileId` of this provider.
  String get otherProfileId;
}

class _FindRoomWithUserProviderElement
    extends AutoDisposeFutureProviderElement<Room?> with FindRoomWithUserRef {
  _FindRoomWithUserProviderElement(super.provider);

  @override
  String get otherProfileId =>
      (origin as FindRoomWithUserProvider).otherProfileId;
}

String _$allRoomsHash() => r'ca10ad8cf67662689131a42bc098f054e21f0e45';

/// See also [allRooms].
@ProviderFor(allRooms)
const allRoomsProvider = AllRoomsFamily();

/// See also [allRooms].
class AllRoomsFamily extends Family<AsyncValue<List<Room>>> {
  /// See also [allRooms].
  const AllRoomsFamily();

  /// See also [allRooms].
  AllRoomsProvider call(
    int page,
    int range,
  ) {
    return AllRoomsProvider(
      page,
      range,
    );
  }

  @override
  AllRoomsProvider getProviderOverride(
    covariant AllRoomsProvider provider,
  ) {
    return call(
      provider.page,
      provider.range,
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
  String? get name => r'allRoomsProvider';
}

/// See also [allRooms].
class AllRoomsProvider extends AutoDisposeFutureProvider<List<Room>> {
  /// See also [allRooms].
  AllRoomsProvider(
    int page,
    int range,
  ) : this._internal(
          (ref) => allRooms(
            ref as AllRoomsRef,
            page,
            range,
          ),
          from: allRoomsProvider,
          name: r'allRoomsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allRoomsHash,
          dependencies: AllRoomsFamily._dependencies,
          allTransitiveDependencies: AllRoomsFamily._allTransitiveDependencies,
          page: page,
          range: range,
        );

  AllRoomsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.range,
  }) : super.internal();

  final int page;
  final int range;

  @override
  Override overrideWith(
    FutureOr<List<Room>> Function(AllRoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllRoomsProvider._internal(
        (ref) => create(ref as AllRoomsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        range: range,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Room>> createElement() {
    return _AllRoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllRoomsProvider &&
        other.page == page &&
        other.range == range;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AllRoomsRef on AutoDisposeFutureProviderRef<List<Room>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `range` of this provider.
  int get range;
}

class _AllRoomsProviderElement
    extends AutoDisposeFutureProviderElement<List<Room>> with AllRoomsRef {
  _AllRoomsProviderElement(super.provider);

  @override
  int get page => (origin as AllRoomsProvider).page;
  @override
  int get range => (origin as AllRoomsProvider).range;
}

String _$unReadOnlyRoomsHash() => r'4444489e873ec10466a1b2c9d57ce54c3ec59de2';

/// See also [unReadOnlyRooms].
@ProviderFor(unReadOnlyRooms)
const unReadOnlyRoomsProvider = UnReadOnlyRoomsFamily();

/// See also [unReadOnlyRooms].
class UnReadOnlyRoomsFamily extends Family<AsyncValue<List<Room>>> {
  /// See also [unReadOnlyRooms].
  const UnReadOnlyRoomsFamily();

  /// See also [unReadOnlyRooms].
  UnReadOnlyRoomsProvider call(
    int page,
    int range,
  ) {
    return UnReadOnlyRoomsProvider(
      page,
      range,
    );
  }

  @override
  UnReadOnlyRoomsProvider getProviderOverride(
    covariant UnReadOnlyRoomsProvider provider,
  ) {
    return call(
      provider.page,
      provider.range,
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
  String? get name => r'unReadOnlyRoomsProvider';
}

/// See also [unReadOnlyRooms].
class UnReadOnlyRoomsProvider extends AutoDisposeFutureProvider<List<Room>> {
  /// See also [unReadOnlyRooms].
  UnReadOnlyRoomsProvider(
    int page,
    int range,
  ) : this._internal(
          (ref) => unReadOnlyRooms(
            ref as UnReadOnlyRoomsRef,
            page,
            range,
          ),
          from: unReadOnlyRoomsProvider,
          name: r'unReadOnlyRoomsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$unReadOnlyRoomsHash,
          dependencies: UnReadOnlyRoomsFamily._dependencies,
          allTransitiveDependencies:
              UnReadOnlyRoomsFamily._allTransitiveDependencies,
          page: page,
          range: range,
        );

  UnReadOnlyRoomsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.range,
  }) : super.internal();

  final int page;
  final int range;

  @override
  Override overrideWith(
    FutureOr<List<Room>> Function(UnReadOnlyRoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UnReadOnlyRoomsProvider._internal(
        (ref) => create(ref as UnReadOnlyRoomsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        range: range,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Room>> createElement() {
    return _UnReadOnlyRoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UnReadOnlyRoomsProvider &&
        other.page == page &&
        other.range == range;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UnReadOnlyRoomsRef on AutoDisposeFutureProviderRef<List<Room>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `range` of this provider.
  int get range;
}

class _UnReadOnlyRoomsProviderElement
    extends AutoDisposeFutureProviderElement<List<Room>>
    with UnReadOnlyRoomsRef {
  _UnReadOnlyRoomsProviderElement(super.provider);

  @override
  int get page => (origin as UnReadOnlyRoomsProvider).page;
  @override
  int get range => (origin as UnReadOnlyRoomsProvider).range;
}

String _$requestedRoomsHash() => r'd4ed0a8432502000ac4a155209b9cf9112bc885a';

/// See also [requestedRooms].
@ProviderFor(requestedRooms)
const requestedRoomsProvider = RequestedRoomsFamily();

/// See also [requestedRooms].
class RequestedRoomsFamily extends Family<AsyncValue<List<Room>>> {
  /// See also [requestedRooms].
  const RequestedRoomsFamily();

  /// See also [requestedRooms].
  RequestedRoomsProvider call(
    int page,
    int range,
  ) {
    return RequestedRoomsProvider(
      page,
      range,
    );
  }

  @override
  RequestedRoomsProvider getProviderOverride(
    covariant RequestedRoomsProvider provider,
  ) {
    return call(
      provider.page,
      provider.range,
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
  String? get name => r'requestedRoomsProvider';
}

/// See also [requestedRooms].
class RequestedRoomsProvider extends AutoDisposeFutureProvider<List<Room>> {
  /// See also [requestedRooms].
  RequestedRoomsProvider(
    int page,
    int range,
  ) : this._internal(
          (ref) => requestedRooms(
            ref as RequestedRoomsRef,
            page,
            range,
          ),
          from: requestedRoomsProvider,
          name: r'requestedRoomsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$requestedRoomsHash,
          dependencies: RequestedRoomsFamily._dependencies,
          allTransitiveDependencies:
              RequestedRoomsFamily._allTransitiveDependencies,
          page: page,
          range: range,
        );

  RequestedRoomsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.range,
  }) : super.internal();

  final int page;
  final int range;

  @override
  Override overrideWith(
    FutureOr<List<Room>> Function(RequestedRoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RequestedRoomsProvider._internal(
        (ref) => create(ref as RequestedRoomsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        range: range,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Room>> createElement() {
    return _RequestedRoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RequestedRoomsProvider &&
        other.page == page &&
        other.range == range;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RequestedRoomsRef on AutoDisposeFutureProviderRef<List<Room>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `range` of this provider.
  int get range;
}

class _RequestedRoomsProviderElement
    extends AutoDisposeFutureProviderElement<List<Room>>
    with RequestedRoomsRef {
  _RequestedRoomsProviderElement(super.provider);

  @override
  int get page => (origin as RequestedRoomsProvider).page;
  @override
  int get range => (origin as RequestedRoomsProvider).range;
}

String _$messagesUsersInsertHash() =>
    r'ec4947dd37054d2cb9ea33ecda037136ca5c748b';

/// See also [messagesUsersInsert].
@ProviderFor(messagesUsersInsert)
final messagesUsersInsertProvider = AutoDisposeStreamProvider<Message>.internal(
  messagesUsersInsert,
  name: r'messagesUsersInsertProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$messagesUsersInsertHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MessagesUsersInsertRef = AutoDisposeStreamProviderRef<Message>;
String _$messagesUsersUpdateHash() =>
    r'74b1e0e2cdcc14a725473b19f053915b50d60fa4';

/// See also [messagesUsersUpdate].
@ProviderFor(messagesUsersUpdate)
final messagesUsersUpdateProvider = AutoDisposeStreamProvider<Message>.internal(
  messagesUsersUpdate,
  name: r'messagesUsersUpdateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$messagesUsersUpdateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MessagesUsersUpdateRef = AutoDisposeStreamProviderRef<Message>;
String _$newUnReadRoomHash() => r'4a0bd609dc8ea00eaace31148923c8b2e147a2b6';

/// See also [newUnReadRoom].
@ProviderFor(newUnReadRoom)
final newUnReadRoomProvider = AutoDisposeStreamProvider<Room>.internal(
  newUnReadRoom,
  name: r'newUnReadRoomProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newUnReadRoomHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NewUnReadRoomRef = AutoDisposeStreamProviderRef<Room>;
String _$newUnReadJoinedRoomHash() =>
    r'503316ca88dc0f59ed641c85f46745677c1da23d';

/// See also [newUnReadJoinedRoom].
@ProviderFor(newUnReadJoinedRoom)
final newUnReadJoinedRoomProvider = AutoDisposeStreamProvider<Room>.internal(
  newUnReadJoinedRoom,
  name: r'newUnReadJoinedRoomProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newUnReadJoinedRoomHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NewUnReadJoinedRoomRef = AutoDisposeStreamProviderRef<Room>;
String _$newReadRoomHash() => r'86a7ca7390e31079ebed0d769e974ce60fd1ad07';

/// See also [newReadRoom].
@ProviderFor(newReadRoom)
final newReadRoomProvider = AutoDisposeStreamProvider<Room>.internal(
  newReadRoom,
  name: r'newReadRoomProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$newReadRoomHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NewReadRoomRef = AutoDisposeStreamProviderRef<Room>;
String _$unReadMessageCountStreamHash() =>
    r'61faa8e7d094cc24745bc56db8e842677d80fee6';

/// See also [unReadMessageCountStream].
@ProviderFor(unReadMessageCountStream)
const unReadMessageCountStreamProvider = UnReadMessageCountStreamFamily();

/// See also [unReadMessageCountStream].
class UnReadMessageCountStreamFamily extends Family<AsyncValue<int>> {
  /// See also [unReadMessageCountStream].
  const UnReadMessageCountStreamFamily();

  /// See also [unReadMessageCountStream].
  UnReadMessageCountStreamProvider call([
    String? roomId,
  ]) {
    return UnReadMessageCountStreamProvider(
      roomId,
    );
  }

  @override
  UnReadMessageCountStreamProvider getProviderOverride(
    covariant UnReadMessageCountStreamProvider provider,
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
  String? get name => r'unReadMessageCountStreamProvider';
}

/// See also [unReadMessageCountStream].
class UnReadMessageCountStreamProvider extends AutoDisposeStreamProvider<int> {
  /// See also [unReadMessageCountStream].
  UnReadMessageCountStreamProvider([
    String? roomId,
  ]) : this._internal(
          (ref) => unReadMessageCountStream(
            ref as UnReadMessageCountStreamRef,
            roomId,
          ),
          from: unReadMessageCountStreamProvider,
          name: r'unReadMessageCountStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$unReadMessageCountStreamHash,
          dependencies: UnReadMessageCountStreamFamily._dependencies,
          allTransitiveDependencies:
              UnReadMessageCountStreamFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  UnReadMessageCountStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
  }) : super.internal();

  final String? roomId;

  @override
  Override overrideWith(
    Stream<int> Function(UnReadMessageCountStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UnReadMessageCountStreamProvider._internal(
        (ref) => create(ref as UnReadMessageCountStreamRef),
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
  AutoDisposeStreamProviderElement<int> createElement() {
    return _UnReadMessageCountStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UnReadMessageCountStreamProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UnReadMessageCountStreamRef on AutoDisposeStreamProviderRef<int> {
  /// The parameter `roomId` of this provider.
  String? get roomId;
}

class _UnReadMessageCountStreamProviderElement
    extends AutoDisposeStreamProviderElement<int>
    with UnReadMessageCountStreamRef {
  _UnReadMessageCountStreamProviderElement(super.provider);

  @override
  String? get roomId => (origin as UnReadMessageCountStreamProvider).roomId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
