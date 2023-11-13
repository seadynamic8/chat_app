import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/auth/view/auth/gender_select_button.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.updateSelectedGender,
  });

  final Gender? selectedGender;
  final void Function(Gender selectedGender) updateSelectedGender;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Please select your gender:'.i18n,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GenderSelectButton(
              gender: Gender.male,
              isSelected: selectedGender == Gender.male,
              onChanged: updateSelectedGender,
            ),
            GenderSelectButton(
              gender: Gender.female,
              isSelected: selectedGender == Gender.female,
              onChanged: updateSelectedGender,
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
