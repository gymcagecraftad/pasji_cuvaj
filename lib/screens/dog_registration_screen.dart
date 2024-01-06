import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasji_cuvaj/providers/database_provider.dart';
import 'package:pasji_cuvaj/providers/auth_provider.dart';

class DogSubmissionScreen extends StatefulWidget {
  final String eventID;

  DogSubmissionScreen({Key? key, required this.eventID}) : super(key: key);

  @override
  _DogSubmissionScreenState createState() => _DogSubmissionScreenState();
}

class _DogSubmissionScreenState extends State<DogSubmissionScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(Duration(days: 3));
  String? selectedDog;
  String? selectedDogId;
  final AuthProvider authProvider = AuthProvider();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a Dog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(height: 8.0),
            Text(
              'Select Date Range:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text('From:'),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(DateFormat('yyyy-MM-dd').format(fromDate)),
                ),
              ],
            ),
            Row(
              children: [
                Text('To:'),
                SizedBox(width: 24.0),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(DateFormat('yyyy-MM-dd').format(toDate)),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Text(
              'Select Dog:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            FutureBuilder<List<Map<String, String>>>(
              future: DatabaseProvider().getDogsByCurrentUser(authProvider.getCurrentUserUid() ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No dogs available');
                } else {
                  return DropdownButton<String>(
                    hint: Text('Select Dog'),
                    value: selectedDog,
                    items: snapshot.data!
                      .map((dog) => DropdownMenuItem<String>(
                        value: dog['dogName']!,
                        child: Text(dog['dogName']!),
                      ))
                      .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDog = value;
                        selectedDogId = snapshot.data!
                            .firstWhere((dog) => dog['dogName'] == value)['dogId'];
                      });
                    },
                  );
                }
              },
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: selectedDog != null ? _submitDog : null,
              // Disable the button if no dog is selected
              child: Text('Submit Dog'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate : toDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isFrom ? fromDate : toDate)) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  Future<void> _submitDog() async {
    try {
      Map<String, DateTime> eventDates =
          await DatabaseProvider().getEventDates(widget.eventID);

      DateTime startDate = eventDates['startDate']!;
      DateTime endDate = eventDates['endDate']!;

      if ((fromDate.isAfter(startDate) || fromDate.isAtSameMomentAs(startDate)) &&
          (toDate.isBefore(endDate) || toDate.isAtSameMomentAs(endDate))) {
        // Check if the selected date range is within the event date range
        print('Selected Dog: $selectedDog, Selected Dog ID: $selectedDogId');
        print('Selected Date Range: $fromDate to $toDate');
        // Continue with dog submission logic...

        // Add logic to save the data to the 'event_registered_dogs' table
        // ...

        // Update the event by decrementing maxDogs
        await DatabaseProvider().updateEventMaxDogs(widget.eventID);
        // After saving the data and updating the event, navigate back to the home screen
        Navigator.pushNamed(context, '/guardian_event_screen');
      } else {
        print('Error: Selected date range must be within the event date range.');
      }
    } catch (e) {
      print('Error submitting dog: $e');
    }
  }


}
