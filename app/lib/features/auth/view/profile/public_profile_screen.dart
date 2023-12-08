import 'package:chat_app/common/async_value_widget.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/chat_lobby/application/chat_lobby_service.dart';
import 'package:chat_app/features/home/application/online_presences.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:chat_app/utils/user_online_status.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:locale_names/locale_names.dart';

@RoutePage()
class PublicProfileScreen extends ConsumerWidget with UserOnlineStatus {
  const PublicProfileScreen(
      {super.key, @PathParam('id') required this.profileId});

  final String profileId;

  bool isCurrentUser(WidgetRef ref) {
    return profileId == ref.watch(authRepositoryProvider).currentUserId!;
  }

  void _joinChatRoom(BuildContext context, WidgetRef ref) async {
    final router = context.router;

    final room =
        await ref.read(chatLobbyServiceProvider).findOrCreateRoom(profileId);

    router.replaceAll([
      const ChatNavigation(),
      const ChatLobbyRoute(),
      ChatRoomRoute(roomId: room.id, otherProfileId: profileId),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileValue = ref.watch(profileStreamProvider(profileId));

    return I18n(
      child: AsyncValueWidget(
        value: profileValue,
        data: (profile) {
          final onlinePresences = ref.watch(onlinePresencesProvider);
          final userStatus = getUserOnlineStatus(onlinePresences, profile.id!);

          return Scaffold(
            key: K.publicProfile,
            body: ListView(
              children: [
                Stack(
                  children: [
                    // Main User Image
                    Container(
                      key: K.publicProfileAvatarCoverImg,
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                      ),
                      width: double.infinity,
                      height: 400,
                      child: profile.avatarUrl != null
                          ? Image.network(profile.avatarUrl!, fit: BoxFit.cover)
                          : Padding(
                              padding: const EdgeInsets.all(70.0),
                              child: Image.asset(
                                defaultAvatarImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    // Back Button
                    Positioned(
                      left: 5,
                      top: 10,
                      child: IconButton(
                        key: K.publicProfileBackButton,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          context.router.pop();
                        },
                      ),
                    ),
                    // Username (and online status)
                  ],
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // USERNAME
                      Text(
                        profile.username ?? '',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 15),

                      // ONLINE STATUS
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: userStatus.color,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Text(userStatus.name,
                            style: theme.textTheme.labelMedium),
                      )
                      // TODO: Follow button
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // GENDER AND AGE
                      Chip(
                        avatar: Icon(profile.gender == Gender.male
                            ? Icons.male
                            : Icons.female),
                        label: Text(profile.age ?? ''),
                      ),
                      const SizedBox(width: 12),

                      // COUNTRY
                      CountryFlag.fromCountryCode(
                        profile.country!,
                        height: 15,
                        width: 25,
                      ),
                      const SizedBox(width: 5),
                      Text(Locale.fromSubtags(countryCode: profile.country!)
                          .nativeDisplayCountry),
                    ],
                  ),
                ),

                // BIO
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(profile.bio ?? 'Nothing here yet 😀'),
                ),

                // TODO: How many follows
                // TODO: Posts (or Moments)
              ],
            ),
            floatingActionButton: isCurrentUser(ref)
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.extended(
                        key: K.publicProfileSendMsgButton,
                        icon: const Icon(Icons.message),
                        label: const Text('Send Message'),
                        heroTag: 'tag1',
                        onPressed: () => _joinChatRoom(context, ref),
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
          );
        },
      ),
    );
  }
}
