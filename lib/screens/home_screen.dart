import 'package:flutter/material.dart';
import 'package:pasji_cuvaj/widgets/auth_control_widget.dart';
import '/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthProvider authProvider = AuthProvider();
  int _selectedIndex = 0;
  static const int numberOfItems = 4;

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
              _selectedIndex = 0; // Reset to default index when logging out
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
                'Pasji Cuvaj is a platform connecting dog owners with dog sitters. Whether you need someone to take care of your furry friend or you want to offer your services, you are in the right place!',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 30),
            Text(
              'Need your puppy to be taken care of? Explore all of our dog sitter sitting posts.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Dog Sitter Events',
          ),
          if (isLoggedIn)
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Create Dog Guardian Event',
            ),
          if (isLoggedIn)
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'My Dogs',
            ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: const Color.fromARGB(255, 42, 42, 41),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;

            // Ensure that the index is within a valid range
            if (_selectedIndex < 0) {
              _selectedIndex = 0;
            } else if (_selectedIndex >= numberOfItems) {
              _selectedIndex = numberOfItems - 1;
            }

            switch (_selectedIndex) {
              case 0:
                Navigator.pushNamed(context, '/home');
                break;
              case 1:
                Navigator.pushNamed(context, '/guardian_event_screen');
                break;
              case 2:
                if (isLoggedIn) {
                  Navigator.pushNamed(context, '/create_guardian_event_screen');
                } else {
                  // Handle not logged in scenario
                  // You may want to show a login screen or display a message
                }
                break;
              case 3:
                if (isLoggedIn) {
                  Navigator.pushNamed(context, '/your_dogs');
                }
                break;
            }
          });
        },
      ),
    );
  }
}
