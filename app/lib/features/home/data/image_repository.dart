import 'dart:io';

import 'package:chat_app/utils/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_repository.g.dart';

enum ImgSource {
  camera,
  gallery;

  static ImageSource convert(ImgSource imgSource) {
    return switch (imgSource) {
      ImgSource.camera => ImageSource.camera,
      ImgSource.gallery => ImageSource.gallery,
    };
  }
}

class ImageRepository {
  ImageRepository({required this.imagePicker});

  final ImagePicker imagePicker;

  Future<File?> pickImage({
    ImgSource? source,
    double? maxWidth = 1000,
    int? imageQuality = 90,
    bool? requestFullMetadata,
  }) async {
    final image = await imagePicker.pickImage(
      source: ImgSource.convert(source ?? ImgSource.gallery),
      maxWidth: maxWidth,
      imageQuality: imageQuality,
      requestFullMetadata: requestFullMetadata ?? true,
    );

    if (image == null) {
      logger.e('Failed to pick image');
      return null;
    }
    return File(image.path);
  }
}

@riverpod
ImageRepository imageRepository(ImageRepositoryRef ref) {
  final imagePicker = ImagePicker();
  return ImageRepository(imagePicker: imagePicker);
}
