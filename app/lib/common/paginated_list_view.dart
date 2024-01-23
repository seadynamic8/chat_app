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
    this.state, // Either use state or value
    this.value,
    required this.data,
    this.beforeSlivers,
    this.emptyItemsMessage,
    required this.itemsLabel,
  });

  final ScrollController scrollController;
  final bool reverse;
  final Function getNextPage;
  final PaginationState<T>? state; // Either use state or value
  final AsyncValue<PaginationState<T>>? value;
  final Widget Function(PaginationState<T>) data; // * Has to return sliver
  final Widget? beforeSlivers; // Use MultiSliver to add multiple
  final String? emptyItemsMessage;
  final String itemsLabel;

  void fetchNewItems(double screenHeight) {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    // Set it to update when only 30% of the screen left.
    final delta = screenHeight * 0.30;

    if (maxScroll - currentScroll <= delta) {
      getNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    scrollController.addListener(() => fetchNewItems(screenHeight));

    Widget getMainSliver(PaginationState<T> state) {
      return state.items.isEmpty && emptyItemsMessage != null
          ? SliverFillRemaining(
              child: Center(
                child: Text(emptyItemsMessage!),
              ),
            )
          : MultiSliver(
              children: [
                data(state),
                if (state.isLastPage) noMoreItems(context),
              ],
            );
    }

    return CustomScrollView(
      controller: scrollController,
      reverse: reverse,
      slivers: [
        if (beforeSlivers != null) beforeSlivers!,
        if (state != null) getMainSliver(state!),
        if (value != null)
          value!.when(
            data: (state) => getMainSliver(state),
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
