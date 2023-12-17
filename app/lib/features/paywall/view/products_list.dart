import 'package:chat_app/features/auth/domain/user_access.dart';
import 'package:chat_app/features/paywall/view/paywall_screen_controller.dart';
import 'package:chat_app/features/paywall/view/product_tile.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsList extends ConsumerWidget {
  const ProductsList({super.key, required this.userAccess});

  final UserAccess userAccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsValue = ref.watch(paywallScreenControllerProvider);

    return productsValue.when(
      data: (products) => products != null
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: products.length,
                (context, index) {
                  final product = products[index];

                  return ProductTile(product: product, userAccess: userAccess);
                },
              ),
            )
          : SliverToBoxAdapter(
              child: Text('Error gettting coins list'.i18n),
            ),
      loading: () => const SliverToBoxAdapter(
        child: CircularProgressIndicator(),
      ),
      error: (e, st) => SliverToBoxAdapter(
        child: Text('Error gettting coins list'.i18n),
      ),
    );
  }
}
