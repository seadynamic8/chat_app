import 'package:auto_route/auto_route.dart';
import 'package:chat_app/env/environment.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AuthNavigation extends ConsumerWidget {
  const AuthNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProd = ref.watch(environmentProvider).envType == EnvType.production;
    return Column(
      children: [
        const Expanded(child: AutoRouter()),
        if (!isProd)
          TextButton(
            onPressed: () {
              context.router.push(const ErrorTalkerRoute());
            },
            child: const Text('Diagnostics'),
          ),
      ],
    );
  }
}
