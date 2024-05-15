import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/search/view/search_controller.dart';
import 'package:chat_app/features/search/view/search_results.dart';
import 'package:chat_app/utils/debouncer.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_extension.dart';

@RoutePage()
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final debounceTime = const Duration(milliseconds: 500);

  String get searchText => _searchController.text.trim();

  void _search() {
    if (searchText.isEmpty) {
      ref.read(searchControllerProvider.notifier).reset();
      return;
    }

    final debouncer = Debouncer(delay: debounceTime);
    debouncer.run(() async {
      await ref
          .read(searchControllerProvider.notifier)
          .searchInitialProfiles(searchText);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getNextPage = ref
        .read(searchControllerProvider.notifier)
        .searchNextProfiles(searchText);

    return I18n(
      child: SafeArea(
        child: Scaffold(
          key: K.searchScreen,
          appBar: AppBar(
            title: TextField(
              key: K.searchScreenSearchField,
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by Username....',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _search(),
            ),
          ),
          body: SearchResults(getNextPage: () => getNextPage),
        ),
      ),
    );
  }
}
