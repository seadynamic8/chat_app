import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({super.key, required this.textColor});

  final _privacyUrl = 'https://dazzely.com/privacy.html';
  final _termsUrl = 'https://dazzely.com/terms.html';

  final Color textColor;

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      logger.error('Settings Launch URL', Exception('Could not launch $url'),
          StackTrace.current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => _launchUrl(Uri.parse(_termsUrl)),
          child: Text(
            'Terms of Service'.i18n,
            style: theme.textTheme.bodySmall!.copyWith(
              color: textColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'and'.i18n,
          style: theme.textTheme.bodySmall!.copyWith(
            color: textColor,
          ),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: () => _launchUrl(Uri.parse(_privacyUrl)),
          child: Text(
            'Privacy Policy'.i18n,
            style: theme.textTheme.bodySmall!.copyWith(
              color: textColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
