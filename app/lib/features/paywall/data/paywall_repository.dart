import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:chat_app/features/paywall/domain/product.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_repository.g.dart';

class PaywallRepository {
  final adapty = Adapty();

  void initialize(String currentUserId) {
    try {
      adapty.setLogLevel(AdaptyLogLevel.info);
      adapty.activate();
      adapty.identify(currentUserId);
    } on AdaptyError catch (adaptyError) {
      logger.e('AdaptyError initialize(): $adaptyError');
    } catch (error) {
      logger.e('PaywallRepo initialize() error: $error');
    }
  }

  Future<AdaptyProfile> getProfile() async {
    try {
      return await adapty.getProfile();
    } on AdaptyError catch (adaptyError) {
      logger.e('AdaptyError getProfile(): $adaptyError');
      rethrow;
    } catch (error) {
      logger.e('PaywallRepo getProfile() error: $error');
      rethrow;
    }
  }

  Future<AdaptyPaywall> getPaywall() async {
    try {
      return await adapty.getPaywall(id: 'main', locale: 'en');
    } on AdaptyError catch (adaptyError) {
      logger.e('AdaptyError getPaywall(): $adaptyError');
      rethrow;
    } catch (error) {
      logger.e('PaywallRepo getPaywall() error: $error');
      rethrow;
    }
  }

  Future<List<Product>> getPaywallProducts(AdaptyPaywall paywall) async {
    try {
      final paywallProducts = await adapty.getPaywallProducts(paywall: paywall);
      return paywallProducts
          .map((paywallProduct) => Product(adaptyProduct: paywallProduct))
          .toList();
    } on AdaptyError catch (adaptyError) {
      logger.e('AdaptyError getPaywallProducts(): $adaptyError');
      rethrow;
    } catch (error) {
      logger.e('PaywallRepo getPaywallProducts() error: $error');
      rethrow;
    }
  }

  // Adapty API docs say to check access level to confirm, but when using
  // consumable, it doesn't change (empty value).  So unless it errors,
  // for now, assume that it was a successful purchase.
  Future<void> makePurchase(Product product) async {
    try {
      await adapty.makePurchase(product: product.adaptyProduct);
    } on AdaptyError catch (adaptyError) {
      logger.w('AdaptyError makePurchase(): $adaptyError');
      rethrow;
    } catch (error) {
      logger.e('PaywallRepo makePurchase() error: $error');
      rethrow;
    }
  }

  Future<void> paywallLogout() async {
    try {
      await adapty.logout();
    } on AdaptyError catch (adaptyError) {
      logger.e('AdaptyError paywallLogout(): $adaptyError');
    } catch (error) {
      logger.e('PaywallRepo paywallLogout() error: $error');
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
