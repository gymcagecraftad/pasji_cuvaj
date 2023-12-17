// home_screen.dart
import 'package:flutter/material.dart';
import 'package:pasji_cuvaj/widgets/auth_control_widget.dart';
import '/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthProvider authProvider = AuthProvider();

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = authProvider.isLoggedIn();
    String welcomeMessage = isLoggedIn
        ? 'Welcome, ${authProvider.getCurrentUserDisplayName()}!'
        : 'Welcome to Pasji Cuvaj!';
    
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
              welcomeMessage,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            if (!isLoggedIn)...[
              SizedBox(height: 20),
            Text(
              'Pasji Cuvaj is a platform connecting dog owners with trusted dog sitters. Whether you need someone to take care of your furry friend or you want to offer your services, you are in the right place!',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            ],
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/event_screen');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Dog Owners Sitting Events',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              'Explore dog sitting offers posted by dog owners who need their dogs taken care of.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/guardian_event_screen');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Dog Sitter Events',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              'Need your puppy to be taken care of? Explore all of our dog sitter sitting posts.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (isLoggedIn)...[
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create_event_screen');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  'Create a dog owner event',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create_guardian_event_screen');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  'Create a dog guardian event',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
