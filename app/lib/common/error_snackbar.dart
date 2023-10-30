import 'package:flutter/material.dart';

// Error message to display the user when unexpected error occurs.
const unexpectedErrorMessage = 'Unexpected error occurred.';

extension ShowSnackBar on BuildContext {
  void showSnackBar(String errorMessage,
      {Color backgroundColor = Colors.white}) {
    if (!mounted) return;
    final sMessenger = ScaffoldMessenger.of(this);
    sMessenger.clearSnackBars();
    sMessenger.showSnackBar(SnackBar(
      content: Text(errorMessage),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar(String errorMessage) {
    showSnackBar(errorMessage, backgroundColor: Colors.red);
  }
}