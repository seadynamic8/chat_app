import 'dart:io';

import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    // We can restrict size and type on Supbase bucket
    final image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      imageQuality: 90,
      requestFullMetadata: true,
    );

    if (image == null) {
      logger.e('Failed to pick image');
      if (!context.mounted) return;
      context.showErrorSnackBar('Failed to pick image.');
      return;
    }

    setState(() {
      _pickedImage = File(image.path);
    });
    widget.onPickImage(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Please choose an image:'.i18n,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: _pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage(defaultAvatarImage),
                  foregroundImage:
                      _pickedImage == null ? null : FileImage(_pickedImage!),
                  radius: 70,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Icon(
                      Icons.edit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 35),
      ],
    );
  }
}
