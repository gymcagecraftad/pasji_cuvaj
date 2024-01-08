// auth_control_widget.dart
import 'package:flutter/material.dart';

class AuthControlWidget extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback onLogout;
  final bool myevent;

  AuthControlWidget({
    required this.isLoggedIn,
    required this.onLogout,
    required this.myevent,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: Text('Pasji Cuvaj App'),
      actions: [
        isLoggedIn
            ? Row(
                children: [
                  myevent
                      ? IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/create_guardian_event_screen');
                          },
                          icon: Icon(Icons.add),
                        )
                      : IconButton(
                          onPressed: () {
                            _confirmLogout(context); // Show confirmation dialog
                          },
                          icon: Icon(Icons.logout),
                        ),
                ],
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

  // Function to show a confirmation dialog before logging out
  Future<void> _confirmLogout(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () {
                // Call the log out function
                onLogout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
