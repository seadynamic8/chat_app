import 'package:chat_app/common/alert_dialogs.dart';
import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/paywall/domain/product.dart';
import 'package:chat_app/features/paywall/view/payment_controller.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductTile extends ConsumerWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  void _selectProduct(BuildContext context, WidgetRef ref) async {
    ref.read(paymentControllerProvider.notifier).purchaseProduct(product);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final paymentState = ref.watch(paymentControllerProvider);

    ref.listen<AsyncValue<PaymentStatus>>(
      paymentControllerProvider,
      (_, state) => state.whenData((paymentStatus) {
        switch (paymentStatus) {
          case PaymentStatus.success:
            showAlertDialog(
                context: context,
                title: 'Awesome!'.i18n,
                content:
                    'Your account has been updated to premium status :)'.i18n);
            break;
          case PaymentStatus.failed:
            context.showErrorSnackBar(
                'Could not update to premium subscription right now, try again later'
                    .i18n);
            break;
          case PaymentStatus.none:
            break;
        }
      }),
    );

    final tile = ListTile(
      key: ValueKey(product.id),
      title: paymentState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.stars,
                  size: 20,
                  color: Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  'Premium',
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
      trailing: paymentState.isLoading
          ? null
          : Text(
              '\$${product.price} / month',
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white30),
      ),
      tileColor: theme.colorScheme.secondary.withAlpha(150),
      onTap: paymentState.isLoading ? null : () => _selectProduct(context, ref),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.only(bottom: 6),
      child: product.isHighlighted
          ? Badge(
              label: Text('Most Popular'.i18n),
              alignment: Alignment.topRight,
              offset: const Offset(-75, -5),
              child: tile,
            )
          : tile,
    );
  }
}
