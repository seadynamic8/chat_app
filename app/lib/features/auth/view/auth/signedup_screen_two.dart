import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/data/resolver_provider.dart';
import 'package:chat_app/features/auth/view/common/profile_image_picker.dart';
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
    _form.currentState!.save();

    Map<String, dynamic> updateValues = {};
    if (username.isNotEmpty) {
      updateValues['username'] = username;
    }
    if (_selectedImage != null) {
      updateValues['avatarUrl'] = await _saveSelectedImage();
    }

    await ref
        .read(currentProfileProvider.notifier)
        .saveProfileToDatabase(updateValues);

    // Tell Autorouter to go to next route
    ref.read(resolverProvider.notifier).resolveNext(true);
    ref.invalidate(resolverProvider);
  }

  Future<String> _saveSelectedImage() async {
    final imagePath =
        await ref.read(authRepositoryProvider).storeAvatar(_selectedImage!);
    return ref.read(authRepositoryProvider).getAvatarPublicURL(imagePath);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuerySize = MediaQuery.sizeOf(context);

    return I18n(
      child: Scaffold(
        body: KeyboardDismissOnTap(
          child: Center(
            child: Form(
              key: _form,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuerySize.width * 0.2),
                children: [
                  // AVATAR
                  Text(
                    'Please choose an image:'.i18n,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  ProfileImagePicker(
                      onPickImage: (pickedImage) =>
                          _selectedImage = pickedImage),
                  const SizedBox(height: 35),

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
