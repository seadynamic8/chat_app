import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/auth/view/auth/auth_form_state.dart';
import 'package:chat_app/features/auth/view/auth/auth_screen_controller.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/exceptions.dart';
import 'package:chat_app/utils/string_validators.dart';
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
  const AuthScreen({super.key, required this.formType, required this.resolver});

  final AuthFormType formType;
  final NavigationResolver resolver;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  var _submitted = false;
  var _passwordObscured = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  void _submit(AuthFormState state) async {
    setState(() => _submitted = true);

    if (!_form.currentState!.validate()) return;

    final router = context.router;

    final responseValue = await ref
        .read(authScreenControllerProvider(widget.formType).notifier)
        .submit(email: email, password: password);

    responseValue.when(
      data: (responseSuccess) {
        if (responseSuccess) {
          if (state.formType == AuthFormType.login) {
            widget.resolver.resolveNext(true, reevaluateNext: false);
          } else {
            router.push(AuthVerifyRoute(email: email));
          }
        } else {
          logger.e('AuthScreen: Failed to submit auth');
        }
      },
      error: (error, st) {
        if (!context.mounted) return;

        switch (error) {
          case DuplicateEmailException _:
            context.showErrorSnackBar(error.message);
          case UnknownEmailSignin _:
            context.showErrorSnackBar(error.message);
          case AuthException _:
            context.showErrorSnackBar(error.message);
          default:
            logError('_submit()', error, st);
            context.showErrorSnackBar(unexpectedErrorMessage);
        }
      },
      loading: () => null,
    );
  }

  void _emailEditingComplete(AuthFormState state) {
    if (state.canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete(AuthFormState state) {
    if (state.canSubmitPassword(password)) {
      _submit(state);
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
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                // EMAIL
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
                ),
                const SizedBox(width: 16, height: 16),

                // PASSWORD
                TextFormField(
                  key: K.authFormPasswordField,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: state.passwordLabelText,
                    enabled: !state.value.isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 18,
                      ),
                      onPressed: () => setState(
                          () => _passwordObscured = !_passwordObscured),
                    ),
                  ),
                  obscureText: _passwordObscured,
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

                // FORGOT PASSWORD
                if (state.formType == AuthFormType.login)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      key: K.authFormForgotPasswordBtn,
                      onPressed: () => context.router.push(ForgotPasswordRoute(
                          previousEmail: _emailController.text)),
                      child: Text(
                        'Forgot Password?'.i18n,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.buttonTheme.colorScheme!.primary
                              .withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),

                // SUBMIT BUTTON
                ElevatedButton(
                  key: K.authFormSubmitButton,
                  onPressed:
                      state.value.isLoading ? null : () => _submit(state),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.buttonTheme.colorScheme!.onPrimary,
                  ),
                  child: state.value.isLoading
                      ? const CircularProgressIndicator()
                      : Text(state.primaryButtonText),
                ),
                const SizedBox(width: 16, height: 16),

                // LOGIN OR SIGNUP TOGGLE
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
