import 'package:chat_app/features/chat/data/translate_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'translation_service.g.dart';

class TranslationService {
  TranslationService({
    required this.translateRepository,
  });

  final TranslateRepository translateRepository;

  Future<String?> getTranslation(String messageText) async {
    // TODO: Need to update this to update this  to use user profile locale
    // final languageCode = I18n.language; // Current locale
    // also, if message locale is the same as (user's locale), then return
    const languageCode = 'es'; // For testing, use Spanish

    return await translateRepository.translate(
        text: messageText, toLangCode: languageCode);
  }
}

@riverpod
TranslationService translationService(TranslationServiceRef ref) {
  final translateRepository = ref.read(translateRepositoryProvider);
  return TranslationService(translateRepository: translateRepository);
}
