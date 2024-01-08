import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasji_cuvaj/providers/auth_provider.dart';
import 'package:pasji_cuvaj/widgets/auth_control_widget.dart';
import 'package:pasji_cuvaj/providers/database_provider.dart';
import 'package:pasji_cuvaj/models/guardian_event.dart';
import 'package:pasji_cuvaj/widgets/bottom_navigation_bar.dart';

class MyGuardianEventsScreen extends StatefulWidget {
  @override
  _MyGuardianEventsScreenState createState() => _MyGuardianEventsScreenState();
}

class _MyGuardianEventsScreenState extends State<MyGuardianEventsScreen> {
  final AuthProvider authProvider = AuthProvider();
  final DatabaseProvider databaseProvider = DatabaseProvider();

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = authProvider.isLoggedIn();
    String? currentUserUid = authProvider.getCurrentUserUid();
    int _selectedIndex = 1;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AuthControlWidget(
          isLoggedIn: isLoggedIn,
          onLogout: () async {
            await authProvider.signOut();
            setState(() {
              _selectedIndex = 1;
            });
          },
          myevent: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'My Dog Guardian Events',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<GuardianEvent>>(
                future: databaseProvider.getMyGuardianEvents(currentUserUid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: RefreshProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No guardian events available.');
                  } else {
                    List<GuardianEvent> events = snapshot.data!;

                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        GuardianEvent event = events[index];

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
                                    'From: ${_formatDate(event.fromDate)} To: ${_formatDate(event.toDate)}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _showMoreInfoDialog(context, event);
                                      },
                                      child: Text('More Info'),
                                    ),
                                    SizedBox(width: 8.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        _showEditDialog(context, event);
                                      },
                                      child: Text('Edit'),
                                    ),
                                    SizedBox(width: 8.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(context, event);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isLoggedIn ? CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabTapped: (index) {
          setState(() {
          });
        },
      ) : null,
    );
  }
   // Function to show a confirmation dialog before deleting an event
  Future<void> _showDeleteConfirmationDialog(BuildContext context, GuardianEvent event) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this event?'),
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
              child: Text('Delete'),
              onPressed: () {
                // Call the function to delete the event
                _deleteEvent(event);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to delete the event
  void _deleteEvent(GuardianEvent event) {
    // Call the delete function in your DatabaseProvider
    databaseProvider.deleteGuardianEvent(event.id);
    // Optionally, you can also update your UI to reflect the changes
    setState(() {
      // Remove the event from the local list
    });
    // Inform the user that the event has been deleted (you can use a snackbar or toast for this)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Event deleted successfully'),
    ));
  }
  // Function to show a dialog for editing an event
  Future<void> _showEditDialog(BuildContext context, GuardianEvent event) async {
    // You can create a TextEditingController for each field you want to edit
    TextEditingController locationController = TextEditingController(text: event.location);
    TextEditingController maxDogsController = TextEditingController(text: event.maxDogs.toString());
    TextEditingController pricePerDayController = TextEditingController(text: event.pricePerDay.toString());

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Event'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                TextFormField(
                  controller: maxDogsController,
                  decoration: InputDecoration(labelText: 'Max Dogs'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: pricePerDayController,
                  decoration: InputDecoration(labelText: 'Price Per Day'),
                  keyboardType: TextInputType.number,
                ),
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
              child: Text('Save'),
              onPressed: () {
                // Call the function to update the event
                _updateEvent(event, locationController.text, maxDogsController.text, pricePerDayController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // Function to update the event
  void _updateEvent(GuardianEvent event, String newLocation, String newMaxDogs, String newPricePerDay) {
    // Update the event with new values
    event.location = newLocation;
    event.maxDogs = int.parse(newMaxDogs);
    event.pricePerDay = double.parse(newPricePerDay);

    // Call the update function in your DatabaseProvider
    databaseProvider.updateGuardianEvent(event);
    // Optionally, you can also update your UI to reflect the changes
    setState(() {
      // Update the event in the local list
    });
    // Inform the user that the event has been updated (you can use a snackbar or toast for this)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Event updated successfully'),
    ));
  }
    // Function to show more info dialog
  Future<void> _showMoreInfoDialog(BuildContext context, GuardianEvent event) async {
    List<Map<String, dynamic>> dogsInfo = await databaseProvider.getDogsInEvent(event.id);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dogs in Event'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var dogInfo in dogsInfo)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dog: ${dogInfo['dogName']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Age: ${dogInfo['dogAge']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Breed: ${dogInfo['selectedBreed']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'From: ${_formatDate(dogInfo['fromDate'])} To: ${_formatDate(dogInfo['toDate'])}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Email of the owner: ${dogInfo['email']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
