import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/auth/view/common/birthdate_picker.dart';
import 'package:chat_app/features/auth/view/auth/gender_selector.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class SignedupScreenOne extends ConsumerStatefulWidget {
  const SignedupScreenOne({super.key});

  @override
  ConsumerState<SignedupScreenOne> createState() => _SignedupScreenOneState();
}

class _SignedupScreenOneState extends ConsumerState<SignedupScreenOne> {
  DateTime? _selectedBirthDate;
  Gender? _selectedGender;

  void _submit() {
    if (_selectedGender == null) {
      context.showErrorSnackBar('You need to select a gender!');
      return;
    }

    ref.read(currentProfileProvider.notifier).updateValues({
      'birthdate': _selectedBirthDate,
      'gender': _selectedGender,
    });

    context.router.push(const SignedupRouteTwo());
  }

  void _updateBirthdate(int year, int month, int day) {
    _selectedBirthDate = DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return I18n(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome!'.i18n,
                  style: theme.textTheme.headlineMedium!.copyWith(
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "To get you started quick, please fill out a few details. \n Don't worry, it will be quick =)"
                      .i18n,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // BIRTHDATE
                Text(
                  'Please enter your birthdate:'.i18n,
                  style: theme.textTheme.headlineMedium!.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                BirthdatePicker(
                  updateBirthdate: _updateBirthdate,
                ),
                const SizedBox(height: 20),

                // GENDER
                GenderSelector(
                  selectedGender: _selectedGender,
                  updateSelectedGender: (Gender selectedGender) =>
                      setState(() => _selectedGender = selectedGender),
                ),

                // NEXT BUTTON
                ElevatedButton(
                  key: K.signUpScreenOneNextButton,
                  onPressed: _submit,
                  child: Text('Next'.i18n),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
