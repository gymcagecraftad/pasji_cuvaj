// register_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:pasji_cuvaj/widgets/auth_control_widget.dart';
import '/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthProvider authProvider = AuthProvider();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
            SizedBox(height: 16.0,),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0,),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0,),
            TextFormField(
              controller: surnameController,
              decoration: InputDecoration(labelText: 'Surmame'),
            ),
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
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  setState(() {
                    errorMessage = 'Passwords do not match. Please check again.';
                  });
                  return;
                }

                firebase_auth.User? user =
                    await authProvider.registerWithEmailAndPassword(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  nameController.text.trim(),
                  surnameController.text.trim(),
                  usernameController.text.trim()
                );

                if (user != null) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/guardian_event_screen',
                    (route) => false,
                  );;
                } else {
                  setState(() {
                    errorMessage = 'Registration failed. Please try again.';
                  });
                }
              },
              child: Text('Register'),
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
