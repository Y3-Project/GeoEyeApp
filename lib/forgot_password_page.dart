import 'package:flutter/material.dart';
import 'package:flutter_app_firebase_login/forgot_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Reset Password", style: TextStyle(fontSize: 25)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Enter the email you signed-up with to reset your password",
            textAlign: TextAlign.center,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Email"),
            controller: emailController,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid email'
                    : null,
          ),
          ElevatedButton.icon(
            onPressed: () {
              resetPassword();
            },
            icon: const Icon(Icons.email_outlined),
            label: const Text('Reset Password'),
          )
        ]),
      ),
    );
  }

  Future<void> resetPassword() async {
    try
    {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      const snack = SnackBar(content: Text('Password Reset Email Sent'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
      Navigator.of(context).popUntil((route) => route.isActive);
    }on FirebaseAuthException catch(e)
    {
      const error = SnackBar(content: Text('An error occurred'));
      ScaffoldMessenger.of(context).showSnackBar(error);
      Navigator.of(context).pop();

    }
  }
}
