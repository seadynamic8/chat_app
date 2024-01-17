import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/view/auth/user_input_validation.dart';
import 'package:chat_app/i18n/localizations.dart';
import 'package:chat_app/routing/app_router.gr.dart';
import 'package:chat_app/utils/keys.dart';
import 'package:chat_app/utils/string_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, required this.previousEmail});

  final String previousEmail;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with UserInputValidation {
  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  var _submitted = false;

  String get email => _emailController.text.trim();

  @override
  void initState() {
    super.initState();

    _emailController.text = widget.previousEmail;
  }

  void _submit() async {
    setState(() => _submitted = true);

    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    final router = context.router;

    await ref.read(authRepositoryProvider).resetPassword(email);

    router.push(AuthVerifyRoute(email: email, isResetPassword: true));
  }

  void _emailEditingComplete() {
    if (canSubmitEmail(email)) _submit();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                    'Please put in your email below and we will send you a code to reset password:'
                        .i18n,
                    key: K.forgotPasswordPrompt,
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // EMAIL
                  TextFormField(
                    key: K.forgotPasswordEmailField,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email'.i18n,
                      hintText: 'name@example.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: _emailEditingComplete,
                    inputFormatters: <TextInputFormatter>[
                      ValidatorInputFormatter(
                          editingValidator: EmailEditingRegexValidator())
                    ],
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (email) => emailErrorText(email ?? ''),
                  ),
                  const SizedBox(height: 20),

                  // NAV BUTTONS
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        key: K.forgotPasswordBackButton,
                        onPressed: () => context.router.pop(),
                        child: Text('Back'.i18n),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        key: K.forgotPasswordSubmitButton,
                        onPressed: _submit,
                        child: Text('Send code'.i18n),
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
