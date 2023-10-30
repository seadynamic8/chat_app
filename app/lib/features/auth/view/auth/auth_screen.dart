import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/auth/view/auth/auth_form_state.dart';
import 'package:chat_app/features/auth/view/auth/auth_screen_controller.dart';
import 'package:chat_app/features/auth/view/auth/string_validators.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen(
      {super.key, required this.formType, required this.onAuthResult});

  // Default form type to use
  final AuthFormType formType;

  // Callback for AutoRoute to redirect on success
  final void Function(bool isSuccess) onAuthResult;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  var _submitted = false;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get username => _usernameController.text.trim();
  String get password => _passwordController.text.trim();

  void _submit() async {
    setState(() => _submitted = true);

    if (!_form.currentState!.validate()) return;

    try {
      final response = await ref
          .read(authScreenControllerProvider(widget.formType).notifier)
          .submit(email: email, password: password, username: username);

      if (response.value != null) widget.onAuthResult(true);
    } on AuthException catch (error) {
      if (!context.mounted) return;
      context.showErrorSnackBar(error.message);
    } catch (error) {
      if (!context.mounted) return;
      logger.e(error.toString());
      context.showErrorSnackBar(unexpectedErrorMessage);
    }
  }

  void _emailEditingComplete(AuthFormState state) {
    if (state.canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _usernameEditingComplete(AuthFormState state) {
    if (!state.canSubmitEmail(email)) {
      _node.previousFocus();
    } else if (state.canSubmitUsername(username)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete(AuthFormState state) {
    if (!state.canSubmitUsername(username)) {
      _node.previousFocus();
    } else if (state.canSubmitPassword(password)) {
      _submit();
    }
  }

  void _updateFormType(AuthFormType formType) {
    ref
        .read(authScreenControllerProvider(widget.formType).notifier)
        .updateFormType(formType);

    _passwordController.clear();
  }

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authScreenControllerProvider(widget.formType));

    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(state.title),
          ),
          body: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              children: [
                TextFormField(
                  key: K.authFormEmailField,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email'.i18n,
                    hintText: 'name@example.com',
                    enabled: !state.value.isLoading,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => _emailEditingComplete(state),
                  inputFormatters: <TextInputFormatter>[
                    ValidatorInputFormatter(
                        editingValidator: EmailEditingRegexValidator())
                  ],
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  validator: (email) => state.emailErrorText(email ?? ''),
                  // state.emailErrorText(email ?? ''),
                ),
                if (state.formType == AuthFormType.signup)
                  const SizedBox(width: 16, height: 16),
                if (state.formType == AuthFormType.signup)
                  TextFormField(
                    key: K.authFormUsernameField,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username*'.i18n,
                      helperText:
                          'If blank, random username will be used (can be updated later)'
                              .i18n,
                      enabled: !state.value.isLoading,
                    ),
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _usernameEditingComplete(state),
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (username) =>
                        state.usernameErrorText(username ?? ''),
                  ),
                const SizedBox(width: 16, height: 16),
                TextFormField(
                  key: K.authFormPasswordField,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: state.passwordLabelText,
                    enabled: !state.value.isLoading,
                  ),
                  obscureText: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => _passwordEditingComplete(state),
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  validator: (password) =>
                      state.passwordErrorText(password ?? ''),
                ),
                const SizedBox(width: 16, height: 16),
                ElevatedButton(
                  key: K.authFormSubmitButton,
                  onPressed: state.value.isLoading ? null : _submit,
                  child: state.value.isLoading
                      ? const CircularProgressIndicator()
                      : Text(state.primaryButtonText),
                ),
                const SizedBox(width: 16, height: 16),
                TextButton(
                  key: K.authFormTypeToggle,
                  onPressed: state.value.isLoading
                      ? null
                      : () => _updateFormType(state.secondaryActionFormType),
                  child: state.value.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          state.secondaryButtonText,
                          textAlign: TextAlign.center,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
