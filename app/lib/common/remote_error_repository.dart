import 'package:chat_app/features/auth/application/user_access_service.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_error_repository.g.dart';

class RemoteErrorRepository {
  RemoteErrorRepository({required this.ref});

  final Ref ref;

  Future<void> setCurrentUser() async {
    final currentProfile = await ref.read(currentProfileStreamProvider.future);

    final userAccessService = await ref.read(userAccessServiceProvider.future);

    if (currentProfile == null || userAccessService == null) return;

    Sentry.configureScope(
      (scope) => scope
        ..setTag('access-level', userAccessService.userAccess.level.name)
        ..setUser(SentryUser(
            id: currentProfile.id,
            email: currentProfile.email,
            username: currentProfile.username)),
    );
  }

  void captureRemoteError(Object error, {StackTrace? stackTrace}) {
    // Sentry can await, but is too slow for request, so just fire and forget
    Sentry.captureException(error, stackTrace: stackTrace);
  }

  void captureRemoteErrorMessage(String message) {
    // Sentry can await, but is too slow for request, so just fire and forget
    Sentry.captureMessage(message, level: SentryLevel.error);
  }

  void addData(String identifier, dynamic data) {
    Sentry.configureScope((scope) => scope.setContexts(identifier, data));
  }
}

@riverpod
RemoteErrorRepository remoteError(RemoteErrorRef ref) {
  return RemoteErrorRepository(ref: ref);
}
