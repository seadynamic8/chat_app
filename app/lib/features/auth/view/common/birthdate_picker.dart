import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';

class BirthdatePicker extends StatefulWidget {
  const BirthdatePicker({
    super.key,
    this.initialBirthdate,
    required this.updateBirthdate,
  });

  final DateTime? initialBirthdate;
  final void Function(int year, int month, int day) updateBirthdate;

  @override
  State<BirthdatePicker> createState() => _BirthdatePickerState();
}

class _BirthdatePickerState extends State<BirthdatePicker> {
  final _today = DateTime.now();
  int? _endYear;
  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;

  @override
  void initState() {
    super.initState();

    if (widget.initialBirthdate != null) {
      _selectedYear = widget.initialBirthdate!.year;
      _selectedMonth = widget.initialBirthdate!.month;
      _selectedDay = widget.initialBirthdate!.day;
    } else {
      // Set 15 years ago as the initial year
      _endYear = _today.year - 15; // At least 14/15 years old to use this app
      _selectedYear = _endYear;
      _selectedMonth = 1;
      _selectedDay = 1;
    }
  }

  void updateValues() {
    widget.updateBirthdate(_selectedYear!, _selectedMonth!, _selectedDay!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final datePickerBgColor = theme.colorScheme.secondary;

    return Container(
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
          onChangedDay: (value) {
            _selectedDay = int.parse(value!);
            updateValues();
          },
          onChangedMonth: (value) {
            _selectedMonth = int.parse(value!);
            updateValues();
          },
          onChangedYear: (value) {
            _selectedYear = int.parse(value!);
            updateValues();
          },
        ),
      ),
    );
  }
}
