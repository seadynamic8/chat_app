import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/data/resolver_provider.dart';
import 'package:chat_app/features/auth/view/auth/profile_image_picker.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/string_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class SignedupScreenTwo extends ConsumerStatefulWidget {
  const SignedupScreenTwo({super.key});

  @override
  ConsumerState<SignedupScreenTwo> createState() => _SignedupScreenTwoState();
}

class _SignedupScreenTwoState extends ConsumerState<SignedupScreenTwo> {
  final _form = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final StringValidator usernameSubmitValidator =
      UsernameSubmitRegexValidator();
  File? _selectedImage;
  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  var _submitted = false;

  String get username => _usernameController.text.trim();

  void _submit() async {
    setState(() => _submitted = true);

    if (!_form.currentState!.validate()) return;

    Map<String, dynamic> updateValues = {};
    if (username.isNotEmpty) {
      updateValues['username'] = username;
    }
    if (_selectedImage != null) {
      updateValues = await _saveSelectedImage(updateValues);
    }

    await ref
        .read(currentProfileProvider.notifier)
        .saveProfileToDatabase(updateValues);

    // Tell Autorouter to go to next route
    ref.read(resolverProvider.notifier).resolveNext(true);
    ref.invalidate(resolverProvider);
  }

  Future<Map<String, dynamic>> _saveSelectedImage(
      Map<String, dynamic> updateValues) async {
    final currentProfileId = ref.read(currentProfileProvider).id!;
    final imagePath = '$currentProfileId.jpg';
    await ref
        .read(authRepositoryProvider)
        .storeAvatar(imagePath, _selectedImage!);
    final imageUrlPath =
        ref.read(authRepositoryProvider).getAvatarPublicURL(imagePath);

    updateValues['avatarUrl'] = imageUrlPath;
    return updateValues;
  }

  void _usernameEditingComplete() {
    if (canSubmitUsername(username)) {
      _submit();
    }
  }

  bool canSubmitUsername(String username) {
    return usernameSubmitValidator.isValid(username);
  }

  String? usernameErrorText(String username) {
    final bool showErrorText = !canSubmitUsername(username);
    final String errorText = 'Username needs 3-24 characters'.i18n;
    return showErrorText ? errorText : null;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    // _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return I18n(
      child: Scaffold(
        body: KeyboardDismissOnTap(
          child: Center(
            child: Form(
              key: _form,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.2),
                children: [
                  // AVATAR
                  ProfileImagePicker(
                      onPickImage: (pickedImage) =>
                          _selectedImage = pickedImage),

                  // USERNAME
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username *'.i18n,
                      helperStyle: theme.textTheme.labelMedium!.copyWith(
                        color: Colors.grey,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _usernameEditingComplete(),
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (username) => usernameErrorText(username ?? ''),
                  ),
                  const SizedBox(height: 20),

                  // NAV BUTTONS
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => context.router.pop(),
                        child: Text('Back'.i18n),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text('Finish'.i18n),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
