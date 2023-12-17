import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/paywall/view/products_list.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAccessValue = ref.watch(userAccessStreamProvider);

    return I18n(
      child: AsyncValueWidget(
        value: userAccessValue,
        data: (userAccess) => Scaffold(
          appBar: AppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Coins'.i18n),
                const SizedBox(width: 8),
                const Icon(
                  Icons.stars,
                  size: 15,
                  color: Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  userAccess.credits.toString(),
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
          backgroundColor: theme.colorScheme.primaryContainer,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Premium'.i18n,
                          style: theme.textTheme.headlineMedium!.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Chat without limits'.i18n,
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ProductsList(userAccess: userAccess),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
