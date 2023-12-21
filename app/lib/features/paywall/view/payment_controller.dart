import 'package:chat_app/features/auth/application/access_level_service.dart';
import 'package:chat_app/features/paywall/data/paywall_repository.dart';
import 'package:chat_app/features/paywall/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_controller.g.dart';

@riverpod
class PaymentController extends _$PaymentController {
  @override
  FutureOr<void> build() {}

  Future<bool> purchaseCredits(Product product) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _buyAndUpdateCredits(product));
    return !state.hasError;
  }

  Future<void> _buyAndUpdateCredits(Product product) async {
    await ref.read(paywallRepositoryProvider).makePurchase(product);

    final userAccess = await ref.read(accessLevelServiceProvider.future);
    await userAccess.updateAccessCredits(product.quantity);
  }
}
