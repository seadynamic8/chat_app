// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsHash() => r'6fd0120c59f3cebac92bdb2731bad20faf771e9a';

/// See also [notifications].
@ProviderFor(notifications)
final notificationsProvider =
    AutoDisposeProvider<NotificationRepository>.internal(
  notifications,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationsRef = AutoDisposeProviderRef<NotificationRepository>;
String _$initialMessageHash() => r'0bd9a7dd50bec2e5cf020e5fa78a19277fa2bbc7';

/// See also [initialMessage].
@ProviderFor(initialMessage)
final initialMessageProvider =
    AutoDisposeFutureProvider<NotificationMessage?>.internal(
  initialMessage,
  name: r'initialMessageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initialMessageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InitialMessageRef = AutoDisposeFutureProviderRef<NotificationMessage?>;
String _$clickedBackgroundMessagesHash() =>
    r'f904fcdf9c2784977f7d1fbbaff68c1607259bf0';

/// See also [clickedBackgroundMessages].
@ProviderFor(clickedBackgroundMessages)
final clickedBackgroundMessagesProvider =
    AutoDisposeStreamProvider<NotificationMessage>.internal(
  clickedBackgroundMessages,
  name: r'clickedBackgroundMessagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clickedBackgroundMessagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ClickedBackgroundMessagesRef
    = AutoDisposeStreamProviderRef<NotificationMessage>;
String _$foregroundMessagesHash() =>
    r'c7c9ecbfbef5923495fb76a01a875b6cec9e9035';

/// See also [foregroundMessages].
@ProviderFor(foregroundMessages)
final foregroundMessagesProvider =
    AutoDisposeStreamProvider<NotificationMessage>.internal(
  foregroundMessages,
  name: r'foregroundMessagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$foregroundMessagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ForegroundMessagesRef
    = AutoDisposeStreamProviderRef<NotificationMessage>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
