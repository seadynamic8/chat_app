import 'package:chat_app/features/paywall/data/paywall_repository.dart';
import 'package:chat_app/features/paywall/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_screen_controller.g.dart';

@riverpod
class PaywallScreenController extends _$PaywallScreenController {
  @override
  FutureOr<List<Product>?> build() async {
    final paywall = await ref.read(paywallRepositoryProvider).getPaywall();
    if (paywall == null) return null;

    final paywallProducts =
        await ref.read(paywallRepositoryProvider).getPaywallProducts(paywall);
    if (paywallProducts == null) return null;

    return paywallProducts;
  }
}
