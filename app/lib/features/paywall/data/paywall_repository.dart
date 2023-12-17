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
      logger.e('AdaptyError: $adaptyError');
    } catch (error) {
      logger.e('PaywallRepo activate error: $error');
    }
  }

  Future<AdaptyProfile?> getProfile() async {
    try {
      final profile = await adapty.getProfile();
      return profile;
    } on AdaptyError catch (adaptyError) {
      logger.e('AdaptyError: $adaptyError');
    } catch (error) {
      logger.e('PaywallRepo getProfile error: $error');
    }
    return null;
  }

  Future<AdaptyPaywall?> getPaywall() async {
    try {
      final paywall = await adapty.getPaywall(id: 'main', locale: 'en');
      return paywall;
    } on AdaptyError catch (adaptyError) {
      logger.e('AdaptyError: $adaptyError');
    } catch (error) {
      logger.e('PaywallRepo getPaywall error: $error');
    }
    return null;
  }

  Future<List<Product>?> getPaywallProducts(AdaptyPaywall paywall) async {
    try {
      final paywallProducts = await adapty.getPaywallProducts(paywall: paywall);
      return paywallProducts
          .map((paywallProduct) => Product(adaptyProduct: paywallProduct))
          .toList();
    } on AdaptyError catch (adaptyError) {
      logger.e('AdaptyError: $adaptyError');
    } catch (error) {
      logger.e('PaywallRepo getPaywallProducts error: $error');
    }
    return null;
  }

  Future<bool> makePurchase(Product product) async {
    try {
      final paywallProfile =
          await adapty.makePurchase(product: product.adaptyProduct);
      return paywallProfile?.accessLevels['premium']?.isActive ?? false;
    } on AdaptyError catch (adaptyError) {
      logger.e('AdaptyError: $adaptyError');
    } catch (error) {
      logger.e('PaywallRepo makePurchase error: $error');
    }
    return false;
  }

  Future<void> paywallLogout() async {
    try {
      await adapty.logout();
    } on AdaptyError catch (adaptyError) {
      logger.e('AdaptyError: $adaptyError');
    } catch (error) {
      logger.e('PaywallRepo paywallLogout error: $error');
    }
  }
}

@riverpod
PaywallRepository paywallRepository(PaywallRepositoryRef ref) {
  return PaywallRepository();
}
