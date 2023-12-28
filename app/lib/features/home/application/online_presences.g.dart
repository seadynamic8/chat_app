// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_presences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lobbySubscribedChannelHash() =>
    r'756f795b251720c5da2b63853cfe14ba83442bc6';

/// See also [lobbySubscribedChannel].
@ProviderFor(lobbySubscribedChannel)
final lobbySubscribedChannelProvider =
    FutureProvider<ChannelRepository>.internal(
  lobbySubscribedChannel,
  name: r'lobbySubscribedChannelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lobbySubscribedChannelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LobbySubscribedChannelRef = FutureProviderRef<ChannelRepository>;
String _$onlinePresencesHash() => r'2a1d5270e677fce46309d2518ab9a39c7f4d1a96';

/// See also [OnlinePresences].
@ProviderFor(OnlinePresences)
final onlinePresencesProvider =
    NotifierProvider<OnlinePresences, Map<String, OnlineState>>.internal(
  OnlinePresences.new,
  name: r'onlinePresencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onlinePresencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OnlinePresences = Notifier<Map<String, OnlineState>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
