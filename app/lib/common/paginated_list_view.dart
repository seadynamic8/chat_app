import 'package:chat_app/common/error_message_widget.dart';
import 'package:chat_app/common/pagination_state.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PaginatedListView<T> extends StatelessWidget {
  const PaginatedListView({
    super.key,
    required this.scrollController,
    this.reverse = false,
    required this.getNextPage,
    required this.value,
    required this.data,
    this.beforeSlivers,
    this.emptyItemsMessage,
    required this.itemsLabel,
  });

  final ScrollController scrollController;
  final bool reverse;
  final Function getNextPage;
  final AsyncValue<PaginationState<T>> value;
  final Widget Function(PaginationState<T>) data; // * Has to return sliver
  final Widget? beforeSlivers; // Use MultiSliver to add multiple
  final String? emptyItemsMessage;
  final String itemsLabel;

  @override
  Widget build(BuildContext context) {
    void fetchNewItems() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;

      // Set it to update when only 30% of the screen left.
      final delta = MediaQuery.sizeOf(context).height * 0.30;

      if (maxScroll - currentScroll <= delta) {
        getNextPage();
      }
    }

    scrollController.addListener(fetchNewItems);

    return CustomScrollView(
      controller: scrollController,
      reverse: reverse,
      slivers: [
        if (beforeSlivers != null) beforeSlivers!,
        value.when(
          data: (state) => state.items.isEmpty && emptyItemsMessage != null
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Text(emptyItemsMessage!),
                  ),
                )
              : MultiSliver(
                  children: [
                    data(state),
                    if (state.isLastPage) noMoreItems(context),
                  ],
                ),
          loading: () => const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, st) {
            logError('paginate slivers', e, st);
            return SliverToBoxAdapter(
              child: Center(
                child: ErrorMessageWidget('Error: Something went wrong'.i18n),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget noMoreItems(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          '--- No more $itemsLabel ---'.i18n,
          style: theme.textTheme.labelLarge!.copyWith(
            color: theme.hintColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
