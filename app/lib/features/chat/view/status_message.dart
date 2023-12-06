import 'package:flutter/material.dart';

class StatusMessage extends StatelessWidget {
  const StatusMessage({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          content,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: Colors.white60,
          ),
        ),
      ),
    );
  }
}
