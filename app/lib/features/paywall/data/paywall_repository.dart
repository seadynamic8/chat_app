import 'dart:async';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/paywall/domain/paywall_profile.dart';
import 'package:chat_app/features/paywall/domain/product.dart';
import 'package:chat_app/utils/exceptions.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_repository.g.dart';

class PaywallRepository {
  PaywallRepository({required this.ref});

  final Ref ref;
  final adapty = Adapty();

  Future<void> initialize() async {
    try {
      await adapty.setLogLevel(AdaptyLogLevel.info);
      adapty.activate();

      final currentUserId = ref.read(currentUserIdProvider)!;
      await adapty.identify(currentUserId);
    } on AdaptyError catch (adaptyError, st) {
      logger.error('AdaptyError initialize(): $adaptyError', adaptyError, st);
    } catch (error, st) {
      logger.error('initialize()', error, st);
    }
  }

  Future<PaywallProfile> getProfile() async {
    try {
      final adaptyProfile = await adapty.getProfile();
      return PaywallProfile(profile: adaptyProfile);
    } on AdaptyError catch (adaptyError, st) {
      logger.error('AdaptyError getProfile(): $adaptyError', adaptyError, st);
      rethrow;
    } catch (error, st) {
      logger.error('getProfile()', error, st);
      rethrow;
    }
  }

  Stream<PaywallProfile> watchProfileUpdates() {
    final streamController = StreamController<PaywallProfile>();

    adapty.didUpdateProfileStream.listen((adaptyProfile) {
      streamController.add(PaywallProfile(profile: adaptyProfile));
    });

    return streamController.stream;
  }

  Future<AdaptyPaywall> getPaywall() async {
    try {
      return await adapty.getPaywall(
          placementId: 'main-subscription', locale: 'en');
    } on AdaptyError catch (adaptyError, st) {
      logger.error('AdaptyError getPaywall(): $adaptyError', adaptyError, st);
      rethrow;
    } catch (error, st) {
      logger.error('getPaywall()', error, st);
      rethrow;
    }
  }

  Future<List<Product>> getPaywallProducts(AdaptyPaywall paywall) async {
    try {
      final paywallProducts = await adapty.getPaywallProducts(paywall: paywall);

      return paywallProducts
          .map((paywallProduct) => Product(adaptyProduct: paywallProduct))
          .toList();
    } on AdaptyError catch (adaptyError, st) {
      if (adaptyError.code == 103) {
        logger.w('Billing service unavailable');
        throw BillingServiceUnavailable();
      }
      logger.error(
          'AdaptyError getPaywallProducts(): $adaptyError', adaptyError, st);
      rethrow;
    } catch (error, st) {
      logger.error('getPaywallProducts()', error, st);
      rethrow;
    }
  }

  Future<void> logShowPaywall(AdaptyPaywall paywall) async {
    try {
      await adapty.logShowPaywall(paywall: paywall);
    } on AdaptyError catch (adaptyError, st) {
      logger.error(
          'AdaptyError logShowPaywall(): $adaptyError', adaptyError, st);
    } catch (error, st) {
      logger.error('logShowPaywall()', error, st);
    }
  }

  Future<bool> makePurchase(Product product) async {
    try {
      final profile = await adapty.makePurchase(product: product.adaptyProduct);

      if (profile?.accessLevels['premium']?.isActive ?? false) {
        return true;
      }
    } on AdaptyError catch (adaptyError, st) {
      logger.w('AdaptyError makePurchase(): $adaptyError',
          error: adaptyError, stackTrace: st);
      rethrow;
    } catch (error, st) {
      logger.error('makePurchase()', error, st);
      rethrow;
    }
    return false;
  }

  Future<void> paywallLogout() async {
    try {
      await adapty.logout();
    } on AdaptyError catch (adaptyError, st) {
      logger.error(
          'AdaptyError paywallLogout(): $adaptyError', adaptyError, st);
    } catch (error, st) {
      logger.error('paywallLogout()', error, st);
    }
  }
}

@riverpod
PaywallRepository paywallRepository(PaywallRepositoryRef ref) {
  final paywallRepository = PaywallRepository(ref: ref);
  ref.onDispose(() => paywallRepository.paywallLogout());
  return paywallRepository;
}

@riverpod
FutureOr<List<Product>> paywallProducts(PaywallProductsRef ref) async {
  final paywallRepository = ref.watch(paywallRepositoryProvider);
  final paywall = await paywallRepository.getPaywall();

  paywallRepository.logShowPaywall(paywall);

  return paywallRepository.getPaywallProducts(paywall);
}
