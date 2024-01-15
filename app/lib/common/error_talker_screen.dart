import 'package:auto_route/auto_route.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class ErrorTalkerScreen extends ConsumerWidget {
  const ErrorTalkerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TalkerScreen(talker: talker);
  }
}
