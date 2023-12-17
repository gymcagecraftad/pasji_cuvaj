// auth_control_widget.dart
import 'package:flutter/material.dart';

class AuthControlWidget extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback onLogout;

  AuthControlWidget({
    required this.isLoggedIn,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: Text('Pasji Cuvaj App'),
      actions: [
        isLoggedIn
            ? IconButton(
                onPressed: onLogout,
                icon: Icon(Icons.logout),
              )
            : Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
      ],
    );
  }
}
