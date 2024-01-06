import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasji_cuvaj/providers/auth_provider.dart';
import 'package:pasji_cuvaj/widgets/auth_control_widget.dart';
import 'package:pasji_cuvaj/providers/database_provider.dart';
import 'package:pasji_cuvaj/models/guardian_event.dart';
import 'dog_registration_screen.dart';


class GuardianEventScreen extends StatefulWidget {
  @override
  _GuardianEventScreenState createState() => _GuardianEventScreenState();
}

class _GuardianEventScreenState extends State<GuardianEventScreen> {
  final AuthProvider authProvider = AuthProvider();
  final DatabaseProvider databaseProvider = DatabaseProvider();

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

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
              'All dog guardians',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: databaseProvider.getAllGuardianEventsWithUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No guardian events available.');
                  } else {
                    List<Map<String, dynamic>> events = snapshot.data!;

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      GuardianEvent event = events[index]['event'];
                      String userName = events[index]['userName'];

                      if (event.maxDogs > 0 && DateTime.parse(event.toDate).isAfter(DateTime.now())) {
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'Guardian: $userName',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                ListTile(
                                  title: Text(
                                    'From: ${_formatDate(event.fromDate)} To: ${_formatDate(event.toDate)}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Location: ${event.location}\nAvailable dogs: ${event.maxDogs}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Center(
                                  child: Text(
                                    '\$${event.pricePerDay} per day',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to a new screen to show more detailed info
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventDetailsScreen(event: event),
                                      ),
                                    );
                                  },
                                  child: Text('More Info'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Dodano: Vrne prazno polje, če maxDogs ni večji od 0 ali toDate ni večji od trenutnega datuma
                        return Container();
                      }
                    },
                  );

                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailsScreen extends StatelessWidget {
  final GuardianEvent event;

  EventDetailsScreen({Key? key, required this.event}) : super(key: key);
  final DatabaseProvider databaseProvider = DatabaseProvider();
  final AuthProvider authProvider = AuthProvider();

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: databaseProvider.getGuardianName(event.guardianId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Event Details'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Event Details'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          String guardianName = snapshot.data ?? '';
          bool isCurrentUserOwner = authProvider.getCurrentUserUid() == event.guardianId;
          bool isLoggedIn = authProvider.isLoggedIn();

          return Scaffold(
            appBar: AppBar(
              title: Text('Event Details'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guardian: $guardianName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'From: ${_formatDate(event.fromDate)} To: ${_formatDate(event.toDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Location: ${event.location}\nRegion: ${event.region}\nAvailible dogs: ${event.maxDogs}\nHousing type: ${event.housingType}\nMaximum dog size: ${event.dogSize}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '${event.hasYard ? "Has yard" : "Doesn\'t have a yard"}',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '\$${event.pricePerDay} per day',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  if (!isCurrentUserOwner && isLoggedIn)
                    ElevatedButton(
                      onPressed: () {
                        print('Sending eventID:');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DogSubmissionScreen(eventID: event.id),
                          ),
                        );
                      },
                      child: Text('Submit a dog'),
                    ),
                  // Add more details as needed
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
