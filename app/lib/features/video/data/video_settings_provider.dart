import 'package:chat_app/features/video/domain/video_settings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_settings_provider.g.dart';

@Riverpod(keepAlive: true)
class VideoSettings extends _$VideoSettings {
  @override
  VideoSettingsState build() {
    return VideoSettingsState();
  }

  void updateSettings({
    String? token,
    String? roomId,
  }) {
    state = state.copyWith(
      token: token,
      roomId: roomId,
    );
  }
}
