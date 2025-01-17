// ignore: unused_import
import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/paywall/data/paywall_repository.dart';
import 'package:chat_app/features/paywall/view/product_tile.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsList extends ConsumerWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final productsValue = ref.watch(paywallProductsProvider);

    return productsValue.when(
      data: (products) => Expanded(
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return ProductTile(product: product);
          },
        ),
      ),
      loading: () => Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.onSurface,
        ),
      ),
      error: (e, st) => Text('Error gettting coins list'.i18n),
    );
  }
}
