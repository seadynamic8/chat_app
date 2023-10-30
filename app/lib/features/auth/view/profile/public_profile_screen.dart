import 'package:chat_app/common/async_value_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/search/data/search_repository.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class PublicProfileScreen extends ConsumerWidget {
  const PublicProfileScreen(
      {super.key, @PathParam('id') required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileValue = ref.watch(getProfileProvider(profileId));

    return I18n(
      child: Scaffold(
        body: AsyncValueWidget(
          value: profileValue,
          data: (profile) => ListView(
            children: [
              Stack(
                children: [
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
                  Positioned(
                    bottom: 40,
                    left: 40,
                    child: Text(
                      profile.username ?? '',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 20,
                          ),
                    ),
                  ),
                  // TODO: Follow button
                ],
              ),
              // TODO: Age, Gender, Location
              // TODO: How many follows
              // TODO: Posts (or Moments)
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              icon: const Icon(Icons.message),
              label: const Text('Send Message'),
              onPressed: () {},
            ),
            FloatingActionButton.extended(
              icon: const Icon(Icons.video_call),
              label: const Text('Call now'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
