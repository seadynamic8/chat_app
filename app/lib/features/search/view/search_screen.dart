import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/common/chat_online_status_icon.dart';
import 'package:chat_app/features/search/view/search_controller.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/debouncer.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  void _search() {
    final searchText = _searchController.text.trim();

    if (searchText.isEmpty) {
      ref.read(searchControllerProvider.notifier).clearProfiles();
      return;
    }

    final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));

    debouncer.run(() =>
        ref.read(searchControllerProvider.notifier).searchProfiles(searchText));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profilesValue = ref.watch(searchControllerProvider);

    return I18n(
      child: SafeArea(
        child: Scaffold(
          key: K.searchScreen,
          appBar: AppBar(
            title: TextField(
              key: K.searchScreenSearchField,
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search....',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _search(),
            ),
          ),
          body: AsyncValueWidget(
            value: profilesValue,
            data: (profiles) => ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];

                return ListTile(
                  key: K.searchScreenResultTile,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            AssetImage(profile.avatarUrl ?? defaultAvatarImage),
                        radius: 20,
                      ),
                      ChatOnlineStatusIcon(userId: profile.id!)
                    ],
                  ),
                  title: Text(
                    profile.username ?? '',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  onTap: () => context.router
                      .push(PublicProfileRoute(profileId: profile.id!)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
