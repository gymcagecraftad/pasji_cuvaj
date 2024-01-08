// login_screen.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:pasji_cuvaj/providers/auth_provider.dart';
import 'package:pasji_cuvaj/widgets/auth_control_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthProvider authProvider = AuthProvider();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AuthControlWidget(
          isLoggedIn: authProvider.isLoggedIn(), // Check if the user is logged in
          onLogout: () async {
            await authProvider.signOut();
            // Optionally, navigate to the login screen or handle post-logout logic
            setState(() {
            });
          },
          myevent: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                firebase_auth.User? user =
                    await authProvider.signInWithEmailAndPassword(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

                if (user != null) {
                   Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/guardian_event_screen',
                    (route) => false,
                  );
                } else {
                  setState(() {
                    errorMessage = 'Login failed. Please check your credentials.';
                  });
                }
              },
              child: Text('Login'),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
