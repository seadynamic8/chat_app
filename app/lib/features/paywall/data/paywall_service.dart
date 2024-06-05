import 'dart:async';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/home/application/current_user_id_provider.dart';
import 'package:chat_app/features/paywall/data/paywall_repository.dart';
import 'package:chat_app/features/paywall/domain/paywall_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_service.g.dart';

class PaywallService {
  PaywallService({required this.ref, required this.paywallRepository});

  final Ref ref;
  final PaywallRepository paywallRepository;
  StreamSubscription<PaywallProfile>? _subscription;

  Future<void> initialize() async {
    await paywallRepository.setLogLvel();
    paywallRepository.activate();
    await paywallRepository.identifyCurrentUser();

    _subscription = await _listenForSubscriptionExpiredOnline();

    // Chheck userAccess first here, to avoid unnecessary network call to Adapty.
    final userAccess = await _getUserAccess();
    if (userAccess == null) return;
    if (userAccess.level != AccessLevel.premium) return;

    // don't await here, we don't want to block the app
    _downgradeUserAccessWhenExpiredOffline(userAccess);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }

  Future<UserAccess?> _getUserAccess() async {
    return await ref.read(userAccessStreamProvider.future);
  }

  Future<StreamSubscription<PaywallProfile>>
      _listenForSubscriptionExpiredOnline() async {
    return paywallRepository
        .watchProfileUpdates()
        .listen((paywallProfile) async {
      if (paywallProfile.loggedIn == false || paywallProfile.active) return;

      final userAccess = await ref.read(userAccessStreamProvider.future);
      if (userAccess == null) {
        throw Exception('UserAccess is null');
      }
      if (userAccess.level != AccessLevel.premium) return;

      _downgradeUserAccessIfSubscriptionExpired(userAccess, paywallProfile);
    });
  }

  Future<void> _downgradeUserAccessWhenExpiredOffline(
      UserAccess userAccess) async {
    final paywallProfile = await paywallRepository.getPaywallProfile();
    _downgradeUserAccessIfSubscriptionExpired(userAccess, paywallProfile);
  }

  Future<void> _downgradeUserAccessIfSubscriptionExpired(
      UserAccess userAccess, PaywallProfile paywallProfile) async {
    if (paywallProfile.active == false &&
        userAccess.level == AccessLevel.premium) {
      await _updateAccessToStandard(userAccess);
    }
  }

  Future<void> _updateAccessToStandard(UserAccess userAccess) async {
    final currentUserId = ref.read(currentUserIdProvider)!;
    await ref.read(authRepositoryProvider).updateUserAccess(
          currentUserId,
          userAccess.copyWith(level: AccessLevel.standard),
        );
  }
}

@riverpod
PaywallService paywallService(PaywallServiceRef ref) {
  final paywallRepository = ref.watch(paywallRepositoryProvider);
  final paywallService =
      PaywallService(ref: ref, paywallRepository: paywallRepository);
  paywallService.initialize();
  ref.onDispose(() => paywallService.dispose());
  return paywallService;
}
