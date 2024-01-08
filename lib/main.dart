// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pasji_cuvaj/screens/events_screen.dart';
import 'package:pasji_cuvaj/screens/guardian_events_screen.dart';
import 'package:pasji_cuvaj/screens/my_guardian_events_screen.dart';
import 'firebase_options.dart';
import '/screens/auth/login.dart';
import '/screens/auth/register.dart';
import '/screens/create_guardian_event.dart';
import 'screens/dog_registration_screen.dart';
import 'package:pasji_cuvaj/screens/your_dogs.dart';
import 'package:pasji_cuvaj/screens/add_dog.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasji Cuvaj App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey, // Assign the navigatorKey
      initialRoute: '/guardian_event_screen', // Set the initial route to home
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/event_screen': (context) => EventScreen(),
        '/guardian_event_screen': (context) => GuardianEventScreen(),
        '/create_guardian_event_screen': (context) => CreateGuardianEventScreen(),
        '/your_dogs': (context) => YourDogs(),
        '/add_dog': (context) => AddDog(),
        '/dog_submission_screen': (context) => DogSubmissionScreen(eventID: ''),   
        '/my_guardian_events_screen': (context) => MyGuardianEventsScreen(),   
        },
    );
  }
}
