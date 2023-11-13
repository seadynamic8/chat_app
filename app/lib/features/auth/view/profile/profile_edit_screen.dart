import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/auth/view/common/birthdate_picker.dart';
import 'package:chat_app/features/auth/view/common/profile_image_picker.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/string_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key, required this.profile});

  final Profile profile;

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _form = GlobalKey<FormState>();
  File? _selectedImage;
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final StringValidator usernameSubmitValidator =
      UsernameSubmitRegexValidator();
  DateTime? _selectedBirthdate;
  var _submitted = false;

  String get username => _usernameController.text.trim();
  String get bio => _bioController.text.trim();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.profile.username!;
    if (widget.profile.bio != null) {
      _bioController.text = widget.profile.bio!;
    }
  }

  void _submit() async {
    final router = context.router;
    setState(() => _submitted = true);

    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    Map<String, dynamic> updateValues = {};
    if (_selectedImage != null) {
      updateValues['avatarUrl'] = await _saveSelectedImage();
    }
    if (username.isNotEmpty) {
      updateValues['username'] = username;
    }
    if (_selectedBirthdate != null) {
      updateValues['birthdate'] = _selectedBirthdate!;
    }
    updateValues['bio'] = bio;

    await ref
        .read(currentProfileProvider.notifier)
        .saveProfileToDatabase(updateValues);

    router.pop();
  }

  Future<String> _saveSelectedImage() async {
    final imagePath =
        await ref.read(authRepositoryProvider).storeAvatar(_selectedImage!);
    return ref.read(authRepositoryProvider).getAvatarPublicURL(imagePath);
  }

  void _updateBirthdate(int year, int month, int day) {
    _selectedBirthdate = DateTime(year, month, day);
  }

  String? usernameErrorText(String username) {
    final bool showErrorText = !usernameSubmitValidator.isValid(username);
    final String errorText = 'Username needs 3-24 characters'.i18n;
    return showErrorText ? errorText : null;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return I18n(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'.i18n),
          actions: [
            IconButton(
              onPressed: _submit,
              icon: const Icon(Icons.check),
            ),
          ],
        ),
        body: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ListView(
              children: [
                // AVATAR
                ProfileImagePicker(
                  initialImageUrl: widget.profile.avatarUrl,
                  onPickImage: (pickedImage) => _selectedImage = pickedImage,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username'.i18n,
                  ),
                  autocorrect: false,
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  validator: (username) => usernameErrorText(username ?? ''),
                ),
                const SizedBox(height: 20),
                Text(
                  'Birthdate',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                BirthdatePicker(
                  initialBirthdate: widget.profile.birthdate,
                  updateBirthdate: _updateBirthdate,
                ),
                const SizedBox(height: 15),
                // BIO
                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    labelText: 'Bio'.i18n,
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: false,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
