import 'package:flutter/material.dart';

class CheckBoxFormField extends FormField<bool> {
  CheckBoxFormField({
    super.key,
    required Widget title,
    required void Function(bool?) onChanged,
    required bool? value,
    super.autovalidateMode,
    super.validator,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.leading,
  }) : super(
          builder: (FormFieldState<bool> state) {
            return CheckboxListTile.adaptive(
              title: title,
              subtitle: state.hasError
                  ? Builder(
                      builder: (BuildContext context) => Text(
                        state.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                  : null,
              value: value,
              onChanged: (value) {
                onChanged(value);
                state.didChange(value);
              },
              controlAffinity: controlAffinity,
              dense: state.hasError,
              visualDensity:
                  const VisualDensity(horizontal: VisualDensity.minimumDensity),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            );
          },
        );
}
