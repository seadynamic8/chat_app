import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/view/profile/public_profile_controller.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/user_online_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/search/data/search_repository.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class PublicProfileScreen extends ConsumerWidget with UserOnlineStatus {
  const PublicProfileScreen(
      {super.key, @PathParam('id') required this.profileId});

  final String profileId;

  bool isCurrentUser(WidgetRef ref) {
    return profileId == ref.watch(authRepositoryProvider).currentUserId!;
  }

  void _goToChatRoom(BuildContext context, WidgetRef ref) async {
    final routerContext = context.router;

    final room = await ref
        .read(publicProfileControllerProvider.notifier)
        .findOrCreateRoom(profileId);

    routerContext
        .push(ChatRoomRoute(roomId: room.id, otherProfileId: profileId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileValue = ref.watch(getProfileProvider(profileId));

    return I18n(
      child: Scaffold(
        body: AsyncValueWidget(
            value: profileValue,
            data: (profile) {
              final onlinePresences = ref.watch(onlinePresencesProvider);
              final userStatus =
                  getUserOnlineStatus(onlinePresences, profile.username!);

              return ListView(
                children: [
                  Stack(
                    children: [
                      // Main User Image
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                        ),
                        width: double.infinity,
                        height: 400,
                        child: Padding(
                          padding: const EdgeInsets.all(70.0),
                          child: Image.asset(
                            profile.avatarUrl ??
                                'assets/images/user_default_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Back Button
                      Positioned(
                        left: 5,
                        top: 10,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            context.router.pop();
                          },
                        ),
                      ),
                      // Username (and online status)
                      Positioned(
                        bottom: 25,
                        left: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              profile.username ?? '',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: userStatus.color,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: Text(userStatus.name,
                                  style: theme.textTheme.labelMedium),
                            )
                          ],
                        ),
                      ),
                      // TODO: Follow button
                    ],
                  ),
                  // TODO: Age, Gender, Location
                  // TODO: How many follows
                  // TODO: Posts (or Moments)
                ],
              );
            }),
        floatingActionButton: isCurrentUser(ref)
            ? null
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    icon: const Icon(Icons.message),
                    label: const Text('Send Message'),
                    heroTag: 'tag1',
                    onPressed: () => _goToChatRoom(context, ref),
                  ),
                  // TODO: Add Follow Button
                  // FloatingActionButton.extended(
                  //   icon: const Icon(Icons.follow),
                  //   label: const Text('Follow'),
                  //   heroTag: 'tag2',
                  //   onPressed: () {},
                  // )
                ],
              ),
        floatingActionButtonLocation: isCurrentUser(ref)
            ? null
            : FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
