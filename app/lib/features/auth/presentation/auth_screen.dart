import 'package:auto_route/auto_route.dart';
import 'package:chat_app/common/error_snackbar.dart';
import 'package:chat_app/features/auth/presentation/auth_form_state.dart';
import 'package:chat_app/features/auth/presentation/auth_screen_controller.dart';
import 'package:chat_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen(
      {super.key, required this.formType, required this.onAuthResult});

  final AuthFormType formType;
  final void Function(bool isSuccess) onAuthResult;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _form = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  void _signIn() async {
    if (!_form.currentState!.validate()) return;

    try {
      final response = await ref
          .read(authScreenControllerProvider(widget.formType).notifier)
          .authenticate(email, password);

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

  @override
  void dispose() {
    _emailController.dispose();
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
            title: const Text('Log In'),
          ),
          body: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(width: 16, height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(width: 16, height: 16),
                ElevatedButton(
                  onPressed: state.value.isLoading ? null : _signIn,
                  child: state.value.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
