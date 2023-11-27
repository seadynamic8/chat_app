import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/data/resolver_provider.dart';
import 'package:chat_app/features/auth/view/auth/user_input_validation.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen>
    with UserInputValidation {
  final _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _submitted = false;

  String get password => _passwordController.text.trim();

  void _submit() async {
    setState(() => _submitted = true);

    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    try {
      await ref.read(authRepositoryProvider).updateUser(password: password);

      ref.read(resolverProvider.notifier).resolveNext(true);
      ref.invalidate(resolverProvider);
    } on AuthException catch (error) {
      if (!context.mounted) return;
      context.showErrorSnackBar(error.message);
    } catch (error) {
      if (!context.mounted) return;
      logger.e(error.toString());
      context.showErrorSnackBar(unexpectedErrorMessage);
    }
  }

  void _passwordEditingComplete() {
    if (canChangePassword(PasswordChangeType.newPassword, password)) {
      _submit();
    }
  }

  String? _passwordValidtor(String password) {
    final showErrorText =
        !canChangePassword(PasswordChangeType.newPassword, password);
    return passwordErrorText(showErrorText, password);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return I18n(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please put in your new password:'.i18n,
                    key: K.resetPasswordPrompt,
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // PASSWORD
                  TextFormField(
                    key: K.resetPasswordField,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _passwordEditingComplete,
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (password) => _passwordValidtor(password ?? ''),
                  ),
                  const SizedBox(width: 16, height: 16),

                  // NAV BUTTONS
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        key: K.resetPasswordSubmitButton,
                        onPressed: _submit,
                        child: Text('Update password'.i18n),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
