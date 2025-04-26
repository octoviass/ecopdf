import 'package:flutter/material.dart';
import 'package:myapp/google_sign_in.dart';
import 'package:myapp/pdf_editor_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png', // Replace with your logo path
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to EcoPDF!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                final success = await GoogleSignInProvider().signInWithGoogle();
                // Navigate to the PdfEditorScreen after successful sign in
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const PdfEditorScreen()),
                );

              },
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}