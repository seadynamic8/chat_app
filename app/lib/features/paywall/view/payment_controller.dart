import 'package:chat_app/features/auth/application/access_level_service.dart';
import 'package:chat_app/features/paywall/data/paywall_repository.dart';
import 'package:chat_app/features/paywall/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_controller.g.dart';

enum PaymentStatus { none, success, failed }

@riverpod
class PaymentController extends _$PaymentController {
  @override
  FutureOr<PaymentStatus> build() {
    return PaymentStatus.none;
  }

  void purchaseProduct(Product product) async {
    state = const AsyncLoading();

    final success =
        await ref.read(paywallRepositoryProvider).makePurchase(product);

    if (success) {
      await _updateAccessToPremium();
      state = const AsyncData(PaymentStatus.success);
    } else {
      state = const AsyncData(PaymentStatus.failed);
    }
  }

  Future<void> _updateAccessToPremium() async {
    final userAccessService = await ref.read(accessLevelServiceProvider.future);
    await userAccessService.updateAccessToPremium();
  }
}
