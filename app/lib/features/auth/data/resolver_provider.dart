import 'package:auto_route/auto_route.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolver_provider.g.dart';

@Riverpod(keepAlive: true)
class Resolver extends _$Resolver {
  @override
  NavigationResolver? build() {
    return null;
  }

  void set(NavigationResolver resolver) {
    state = resolver;
  }

  void resolveNext(bool continueNav, {bool reevaluateNext = false}) {
    if (state == null) {
      logger.e('Resolver is null!');
      return;
    }

    state!.resolveNext(continueNav, reevaluateNext: reevaluateNext);
  }
}