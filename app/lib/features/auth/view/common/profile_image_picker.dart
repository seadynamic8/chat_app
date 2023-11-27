import 'dart:io';

import 'package:chat_app/features/home/data/image_repository.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileImagePicker extends ConsumerStatefulWidget {
  const ProfileImagePicker({
    super.key,
    this.initialImageUrl,
    required this.onPickImage,
    this.source,
    this.maxWidth,
    this.imageQuality,
    this.requestFullMetadata,
  });

  final String? initialImageUrl;
  final void Function(File pickedImage) onPickImage;
  final ImgSource? source;
  final double? maxWidth;
  final int? imageQuality;
  final bool? requestFullMetadata;

  @override
  ConsumerState<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends ConsumerState<ProfileImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final image = await ref.read(imageRepositoryProvider).pickImage(
          source: widget.source,
          maxWidth: widget.maxWidth,
          imageQuality: widget.imageQuality,
          requestFullMetadata: widget.requestFullMetadata,
        );

    if (image == null) {
      logger.w('Unable to pick image.');
      return;
    }

    setState(() {
      _pickedImage = File(image.path);
    });
    widget.onPickImage(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        key: K.signUpImagePicker,
        onTap: _pickImage,
        child: Stack(
          children: [
            if (_pickedImage != null)
              CircleAvatar(
                backgroundImage: const AssetImage(defaultAvatarImage),
                foregroundImage:
                    _pickedImage == null ? null : FileImage(_pickedImage!),
                radius: 70,
              ),
            if (_pickedImage == null)
              CircleAvatar(
                backgroundImage: const AssetImage(defaultAvatarImage),
                foregroundImage: widget.initialImageUrl != null
                    ? NetworkImage(widget.initialImageUrl!)
                    : null,
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
    );
  }
}
