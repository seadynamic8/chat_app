import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:flutter/material.dart';

class GenderSelectButton extends StatefulWidget {
  const GenderSelectButton({
    super.key,
    required this.gender,
    required this.isSelected,
    required this.onChanged,
  });

  final Gender gender;
  final bool isSelected;
  final void Function(Gender selectedGender) onChanged;

  @override
  State<GenderSelectButton> createState() => _GenderSelectButtonState();
}

class _GenderSelectButtonState extends State<GenderSelectButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedColor = widget.isSelected
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;

    final genderName = widget.gender.name;
    final genderNameString =
        genderName[0].toUpperCase() + genderName.substring(1);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: selectedColor,
          ),
          child: IconButton(
            onPressed: () {
              widget.onChanged(widget.gender);
            },
            icon:
                Icon(widget.gender == Gender.male ? Icons.male : Icons.female),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          genderNameString,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: selectedColor,
          ),
        ),
      ],
    );
  }
}
