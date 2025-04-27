import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/ui/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/ui/widgets/auth_button.dart';
import 'package:blog_app/features/auth/ui/widgets/auth_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onSubmit() {
      if (_formKey.currentState!.validate()) {
        context.read<AuthBloc>().add(
          AuthSignIn(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) showSnackBar(context, state.message);
              },
              builder: (context, state) {
                if (state is AuthCurrentUserLoading) return const Loader();
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 24,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Column(
                        spacing: 16,
                        children: [
                          AuthField(
                            hintText: 'Email',
                            controller: _emailController,
                          ),
                          AuthField(
                            hintText: 'Password',
                            controller: _passwordController,
                            isPassword: true,
                          ),
                          AuthButton(label: 'Sign In', onPressed: onSubmit),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color: AppPallet.gradient2,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () => context.go(Routes.signUp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
