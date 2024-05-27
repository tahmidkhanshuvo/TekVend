import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input fields for email/username and password
            const TextField(
              decoration: InputDecoration(labelText: 'Email/Username'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                // Implement sign-in logic
              },
              child: const Text('Sign In'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to sign-up screen
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
