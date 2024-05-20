import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:chat_app/utils/constants.dart';

enum PaywallAccessLevel { active, inactive }

class PaywallProfile {
  PaywallProfile({required this.profile});

  final AdaptyProfile profile;

  bool get loggedIn => profile.customerUserId != null;

  bool get subscribed => profile.accessLevels.isNotEmpty;

  bool get active =>
      profile.accessLevels[adaptyAccessLevelId]?.isActive ?? false;

  PaywallAccessLevel get accessLevel =>
      active ? PaywallAccessLevel.active : PaywallAccessLevel.inactive;

  @override
  String toString() {
    return profile.toString();
  }
}
