import 'package:auto_route/auto_route.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class ErrorTalkerScreen extends StatelessWidget {
  const ErrorTalkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TalkerScreen(talker: talker);
  }
}
