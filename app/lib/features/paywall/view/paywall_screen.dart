import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/paywall/view/products_list.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_extension.dart';

@RoutePage()
class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return I18n(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Subscription'.i18n),
        ),
        backgroundColor: theme.colorScheme.primaryContainer,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Premium'.i18n,
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'After the free trial ($trialMaxMins minutes):'.i18n,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '- Unlimited video calls with translation'.i18n,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 15),
              const ProductsList(),
            ],
          ),
        ),
      ),
    );
  }
}
