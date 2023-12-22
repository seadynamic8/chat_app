import 'dart:ui';

import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/chat/data/translate_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'translation_service.g.dart';

class TranslationService {
  TranslationService({
    required this.ref,
    required this.translateRepository,
  });

  final Ref ref;
  final TranslateRepository translateRepository;

  Future<String?> getTranslation(
      Locale otherProfileLocale, String messageText) async {
    final currentProfile = await ref.read(currentProfileStreamProvider.future);
    final currentProfileLang = currentProfile.language!.languageCode;
    final otherProfileLang = otherProfileLocale.languageCode;

    return await translateRepository.translate(
        text: messageText,
        toLangCode: currentProfileLang,
        fromLangCode: otherProfileLang);
  }
}

@riverpod
TranslationService translationService(TranslationServiceRef ref) {
  final translateRepository = ref.read(translateRepositoryProvider);
  return TranslationService(ref: ref, translateRepository: translateRepository);
}
