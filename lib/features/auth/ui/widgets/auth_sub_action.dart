import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthSubAction extends StatefulWidget {
  final bool isSignUp;

  const AuthSubAction({super.key, required this.isSignUp});

  @override
  State<AuthSubAction> createState() => _AuthSubActionState();
}

class _AuthSubActionState extends State<AuthSubAction> {
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer();
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onTap() {
      context.go(widget.isSignUp ? Routes.signIn : Routes.signUp);
    }

    return RichText(
      text: TextSpan(
        text: '${widget.isSignUp ? 'Already' : 'Don\'t'} have an account? ',
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: widget.isSignUp ? 'Sign In' : 'Sign Up',
            style: TextStyle(
              color: AppPallet.gradient2,
              fontWeight: FontWeight.w700,
            ),
            recognizer: _tapGestureRecognizer..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
