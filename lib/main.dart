// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pasji_cuvaj/screens/events_screen.dart';
import 'package:pasji_cuvaj/screens/guardian_events_screen.dart';
import 'firebase_options.dart';
import '/screens/home_screen.dart';
import '/screens/auth/login.dart';
import '/screens/auth/register.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final HomeScreen homeScreen = HomeScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasji Cuvaj App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey, // Assign the navigatorKey
      initialRoute: '/home', // Set the initial route to home
      routes: {
        '/home': (context) => homeScreen,
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/event_screen': (context) => EventScreen(),
        '/guardian_event_screen': (context) => GuardianEventScreen()
      },
    );
  }
}
