import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/auth/data/current_profile_provider.dart';
import 'package:chat_app/features/auth/domain/profile.dart';
import 'package:chat_app/features/auth/view/auth/gender_selector.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
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
  final _today = DateTime.now();
  late final int _endYear;
  int _selectedDay = 1;
  int _selectedMonth = 1;
  late int _selectedYear;

  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();

    // Set 15 years ago as the initial year
    _endYear = _today.year - 15; // At least 14/15 years old to use this app
    _selectedYear = _endYear;
  }

  void _submit() {
    if (_selectedGender == null) {
      context.showErrorSnackBar('You need to select a gender!');
      return;
    }

    final selectedBirthDate =
        DateTime(_selectedYear, _selectedMonth, _selectedDay);

    ref.read(currentProfileProvider.notifier).updateValues({
      'birthdate': selectedBirthDate,
      'gender': _selectedGender,
    });

    context.router.push(const SignedupRouteTwo());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final datePickerBgColor = theme.colorScheme.secondary;

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
                Text(
                  'Please enter your birthdate:'.i18n,
                  style: theme.textTheme.headlineMedium!.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  color: datePickerBgColor,
                  padding: const EdgeInsets.all(8),
                  child: Theme(
                    data: theme.copyWith(
                      canvasColor: datePickerBgColor,
                    ),
                    child: DropdownDatePicker(
                      endYear: _endYear,
                      selectedDay: _selectedDay,
                      selectedMonth: _selectedMonth,
                      selectedYear: _selectedYear,
                      onChangedDay: (value) => _selectedDay = int.parse(value!),
                      onChangedMonth: (value) =>
                          _selectedMonth = int.parse(value!),
                      onChangedYear: (value) =>
                          _selectedYear = int.parse(value!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // GENDER
                GenderSelector(
                  selectedGender: _selectedGender,
                  updateSelectedGender: (Gender selectedGender) =>
                      setState(() => _selectedGender = selectedGender),
                ),

                ElevatedButton(
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
