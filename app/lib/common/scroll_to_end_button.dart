import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';

enum ScrollDirection { top, bottom }

class ScrollToEndButton extends StatelessWidget {
  const ScrollToEndButton({
    super.key,
    required this.scrollController,
    required this.direction,
  });

  final ScrollController scrollController;
  final ScrollDirection direction;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        double scrollOffset = scrollController.offset;

        return scrollOffset > MediaQuery.sizeOf(context).height * 0.5
            ? FloatingActionButton(
                tooltip: 'Scroll to ${direction.name}'.i18n,
                mini: true,
                onPressed: () {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Icon(direction == ScrollDirection.top
                    ? Icons.arrow_upward
                    : Icons.arrow_downward),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
