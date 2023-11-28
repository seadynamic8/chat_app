import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class AuthVerifyScreen extends ConsumerStatefulWidget {
  const AuthVerifyScreen({
    super.key,
    required this.email,
    this.isResetPassword = false,
  });

  final String email;
  final bool isResetPassword;

  @override
  ConsumerState<AuthVerifyScreen> createState() => _AuthVerifyScreenState();
}

class _AuthVerifyScreenState extends ConsumerState<AuthVerifyScreen> {
  final _pinController = TextEditingController();

  void _submit(String pin) async {
    final router = context.router;
    try {
      final response = await ref.watch(authRepositoryProvider).verifyOTP(
            email: widget.email,
            pinCode: pin,
            authOtpType: widget.isResetPassword
                ? AuthOtpType.recovery
                : AuthOtpType.signup,
          );

      // Verified (logged in) and created user with generated username
      if (response != null) {
        // Use replace here, so that users can't come back here
        if (widget.isResetPassword) {
          router.replace(const ResetPasswordRoute());
        } else {
          // Navigate to user creation process to fill out profile
          router.replace(const SignedupRouteOne());
        }
      }
    } on AuthException catch (error) {
      if (!context.mounted) return;
      if (error.message == 'Token has expired or is invalid') {
        context.showErrorSnackBar('Code has expired or is invalid!');
      }
      context.showErrorSnackBar(error.message);
    } catch (error) {
      if (!context.mounted) return;
      logger.e(error.toString());
      context.showErrorSnackBar(unexpectedErrorMessage);
    }
  }

  void _resendOTP() async {
    final authRepository = ref.read(authRepositoryProvider);
    if (widget.isResetPassword) {
      await authRepository.resetPassword(widget.email);
    } else {
      await authRepository.resendOTP(
          authOtpType: AuthOtpType.signup, email: widget.email);
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Colors.black26;
    final borderColor = theme.secondaryHeaderColor;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromARGB(255, 170, 124, 255),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: borderColor),
          boxShadow: const [
            BoxShadow(color: Colors.black45),
          ]),
    );

    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Verify PIN'.i18n),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 30,
                ),
                const SizedBox(height: 20),
                Text(
                  'Verify PIN'.i18n,
                  style: theme.textTheme.headlineMedium!.copyWith(
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Please check your email for a PIN verification code.'.i18n,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 25),

                // PIN CODE INPUT
                Pinput(
                  key: K.authVerifyFormPinput,
                  controller: _pinController,
                  defaultPinTheme: defaultPinTheme,
                  length: 6,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onCompleted: _submit,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 12),

                // ACTION BUTTONS
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      key: K.authVerifyFormClearButton,
                      onPressed: () {
                        _pinController.clear();
                      },
                      child: Text('Clear'.i18n),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      key: K.authVerifyFormResendButton,
                      onPressed: _resendOTP,
                      child: Text('Resend code'.i18n),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
