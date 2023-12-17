import 'package:chat_app/common/alert_dialogs.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/paywall/data/paywall_repository.dart';
import 'package:chat_app/features/paywall/domain/product.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductTile extends ConsumerWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.userAccess,
  });

  final Product product;
  final UserAccess userAccess;

  void _selectProduct(BuildContext context, WidgetRef ref) async {
    final purchased =
        await ref.read(paywallRepositoryProvider).makePurchase(product);

    if (purchased) {
      final currentProfileId = ref.read(currentProfileProvider).id!;
      await ref.read(authRepositoryProvider).updateAccessLevel(
            currentProfileId,
            userAccess.copyWith(
                level: AccessLevel.premium,
                credits: userAccess.credits + product.quantity),
          );

      if (!context.mounted) return;
      showAlertDialog(
          context: context,
          title: 'Awesome!'.i18n,
          content:
              '${product.quantity} coins have been added to your account :)'
                  .i18n);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final tile = ListTile(
      key: ValueKey(product.id),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.stars,
            size: 20,
            color: Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            '${product.quantity}',
            style: theme.textTheme.labelLarge!.copyWith(
              color: theme.colorScheme.onSecondary,
            ),
          ),
        ],
      ),
      trailing: Text(
        '\$${product.price}',
        style: theme.textTheme.labelLarge!.copyWith(
          color: theme.colorScheme.onSecondary,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white30),
      ),
      tileColor: theme.colorScheme.secondary.withAlpha(150),
      onTap: () => _selectProduct(context, ref),
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
