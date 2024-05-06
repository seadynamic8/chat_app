import 'package:adapty_flutter/adapty_flutter.dart';

enum PaywallAccessLevel { active, inactive }

class PaywallProfile {
  PaywallProfile({required this.profile});

  final AdaptyProfile profile;

  bool get active => profile.accessLevels['premium']?.isActive ?? false;

  PaywallAccessLevel get accessLevel =>
      active ? PaywallAccessLevel.active : PaywallAccessLevel.inactive;

  @override
  String toString() {
    return profile.toString();
  }
}
