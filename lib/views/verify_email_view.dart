import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Email")),
      body: Column(
        children: [
          const Text(
            "We've sent you an email, please open it to verify your account",
          ),
          const Text("If you didn't get email then click on this button"),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                const AuthEventSendEmailVerification(),
              );
            },
            child: const Text("Send Email Verification"),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }
}
