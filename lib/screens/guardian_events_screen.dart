import 'package:flutter/material.dart';
import 'package:pasji_cuvaj/providers/auth_provider.dart';
import 'package:pasji_cuvaj/widgets/auth_control_widget.dart';

class GuardianEventScreen extends StatefulWidget{
  @override
  _GuardianEventScreenState createState() => _GuardianEventScreenState();
}

class _GuardianEventScreenState extends State<GuardianEventScreen>{
  final AuthProvider authProvider = AuthProvider();

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = authProvider.isLoggedIn();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AuthControlWidget(
          isLoggedIn: isLoggedIn,
          onLogout: () async {
            await authProvider.signOut();
            setState(() {
              // Trigger a rebuild of the HomeScreen widget
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'All dog guardians events',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }  
}