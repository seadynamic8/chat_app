import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/home/application/notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_screen_controller.g.dart';

@riverpod
class SettingsScreenController extends _$SettingsScreenController {
  @override
  void build() {}

  Future<void> logOut() async {
    await ref.read(notificationServiceProvider).deleteToken();

    await ref.read(authRepositoryProvider).signOut();
  }
}
