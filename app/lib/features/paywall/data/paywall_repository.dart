import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:chat_app/features/paywall/domain/product.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_repository.g.dart';

class PaywallRepository {
  final adapty = Adapty();

  Future<void> initialize(String currentUserId) async {
    try {
      await adapty.setLogLevel(AdaptyLogLevel.info);
      adapty.activate();
      await adapty.identify(currentUserId);
    } on AdaptyError catch (adaptyError, st) {
      await logError('AdaptyError initialize(): $adaptyError', adaptyError, st);
    } catch (error, st) {
      await logError('initialize()', error, st);
    }
  }

  Future<AdaptyProfile> getProfile() async {
    try {
      return await adapty.getProfile();
    } on AdaptyError catch (adaptyError, st) {
      await logError('AdaptyError getProfile(): $adaptyError', adaptyError, st);
      rethrow;
    } catch (error, st) {
      await logError('getProfile()', error, st);
      rethrow;
    }
  }

  Future<AdaptyPaywall> getPaywall() async {
    try {
      return await adapty.getPaywall(id: 'main', locale: 'en');
    } on AdaptyError catch (adaptyError, st) {
      await logError('AdaptyError getPaywall(): $adaptyError', adaptyError, st);
      rethrow;
    } catch (error, st) {
      await logError('getPaywall()', error, st);
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
      await logError(
          'AdaptyError getPaywallProducts(): $adaptyError', adaptyError, st);
      rethrow;
    } catch (error, st) {
      await logError('getPaywallProducts()', error, st);
      rethrow;
    }
  }

  // Adapty API docs say to check access level to confirm, but when using
  // consumable, it doesn't change (empty value).  So unless it errors,
  // for now, assume that it was a successful purchase.
  Future<void> makePurchase(Product product) async {
    try {
      await adapty.makePurchase(product: product.adaptyProduct);
    } on AdaptyError catch (adaptyError, st) {
      logger.w('AdaptyError makePurchase(): $adaptyError',
          error: adaptyError, stackTrace: st);
      rethrow;
    } catch (error, st) {
      await logError('makePurchase()', error, st);
      rethrow;
    }
  }

  Future<void> paywallLogout() async {
    try {
      await adapty.logout();
    } on AdaptyError catch (adaptyError, st) {
      await logError(
          'AdaptyError paywallLogout(): $adaptyError', adaptyError, st);
    } catch (error, st) {
      await logError('paywallLogout()', error, st);
    }
  }
}

@riverpod
PaywallRepository paywallRepository(PaywallRepositoryRef ref) {
  return PaywallRepository();
}

@riverpod
FutureOr<List<Product>> paywallProducts(PaywallProductsRef ref) async {
  final paywallRepository = ref.watch(paywallRepositoryProvider);
  final paywall = await ref.read(paywallRepositoryProvider).getPaywall();
  return paywallRepository.getPaywallProducts(paywall);
}
