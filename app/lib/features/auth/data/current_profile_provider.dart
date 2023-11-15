import 'dart:ui';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_profile_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentProfile extends _$CurrentProfile {
  @override
  Profile build() {
    return Profile(
      // Set language and country to system at first
      language: Locale(I18n.locale.languageCode),
      country: I18n.locale.countryCode,
    );
  }

  void set(Profile profile) {
    state = profile;
  }

  Future<void> load() async {
    if (state.username == null) {
      final currentUserId = ref.read(authRepositoryProvider).currentUserId!;
      state = await ref.read(authRepositoryProvider).getProfile(currentUserId);
    }
  }

  void updateValues(Map<String, dynamic> newValues) {
    state = state.copyWithMap(newValues);
  }

  // Not sure to put it here, maybe controller, but don't want to create one for now.
  Future<void> saveProfileToDatabase(Map<String, dynamic> newValues) async {
    // Save to it's own state first
    updateValues(newValues);

    await ref.read(authRepositoryProvider).updateProfile(state);
  }
}
