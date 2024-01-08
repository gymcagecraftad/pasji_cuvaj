import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasji_cuvaj/providers/auth_provider.dart';
import 'package:pasji_cuvaj/widgets/auth_control_widget.dart';
import 'package:pasji_cuvaj/providers/database_provider.dart';
import 'package:pasji_cuvaj/models/guardian_event.dart';
import 'dog_registration_screen.dart';
import 'package:pasji_cuvaj/widgets/bottom_navigation_bar.dart';



class GuardianEventScreen extends StatefulWidget {
  @override
  _GuardianEventScreenState createState() => _GuardianEventScreenState();
}

class RegionDropdown extends StatefulWidget {
  final Function(String?) onRegionChanged;

  const RegionDropdown({Key? key, required this.onRegionChanged}) : super(key: key);

  @override
  _RegionDropdownState createState() => _RegionDropdownState();
}

class _RegionDropdownState extends State<RegionDropdown> {
  String? selectedRegion;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('Region'),
      value: selectedRegion,
      items: [
        'Pomurska regija',
        'Podravska regija',
        'Koroška regija',
        'Savinjska regija',
        'Zasavska regija',
        'Posavska regija',
        'Jugovzhodna Slovenija',
        'Osrednjeslovenska regija',
        'Gorenjska regija',
        'Primorsko-notranjska regija',
        'Goriška regija',
        'Obalno-kraška regija',
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedRegion = value;
        });
        widget.onRegionChanged(value);
      },
    );
  }
}
class OrderByDropdown extends StatefulWidget {
  final Function(String?) onOrderByChanged;

  const OrderByDropdown({Key? key, required this.onOrderByChanged}) : super(key: key);

  @override
  _OrderByDropdownState createState() => _OrderByDropdownState();
}

class _OrderByDropdownState extends State<OrderByDropdown> {
  String? selectedOrderBy;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('Order By'),
      value: selectedOrderBy,
      onChanged: (String? value) {
        setState(() {
          selectedOrderBy = value;
        });
        widget.onOrderByChanged(value);
      },
      items: [
        'No Order',
        'Price Ascending',
        'Price Descending',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
class DateRangePicker extends StatefulWidget {
  final Function(DateTime?, DateTime?) onDateRangeChanged;

  const DateRangePicker({Key? key, required this.onDateRangeChanged}) : super(key: key);

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('From Date:'),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedFromDate = pickedDate;
                  });
                  widget.onDateRangeChanged(selectedFromDate, selectedToDate);
                }
              },
              child: Text(selectedFromDate != null
                  ? DateFormat('yyyy-MM-dd').format(selectedFromDate!)
                  : 'Select Date'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('To Date:'),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedToDate = pickedDate;
                  });
                  widget.onDateRangeChanged(selectedFromDate, selectedToDate);
                }
              },
              child: Text(selectedToDate != null
                  ? DateFormat('yyyy-MM-dd').format(selectedToDate!)
                  : 'Select Date'),
            ),
          ],
        ),
      ],
    );
  }
}

class _GuardianEventScreenState extends State<GuardianEventScreen> {
  GlobalKey<_RegionDropdownState> regionDropdownKey = GlobalKey<_RegionDropdownState>();
  GlobalKey<_OrderByDropdownState> orderByDropdownKey = GlobalKey<_OrderByDropdownState>();
  GlobalKey<_DateRangePickerState> dateRangePickerKey = GlobalKey<_DateRangePickerState>();  final AuthProvider authProvider = AuthProvider();
  final DatabaseProvider databaseProvider = DatabaseProvider();
  int _selectedIndex = 0;
  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
  String? orderBy;
  String? region;
  DateTime? fromDate;
  DateTime? toDate;
  Future<void> showFilterDialog() async {
    String? selectedOrderBy;
    String? selectedRegion;
    DateTime? selectedFromDate;
    DateTime? selectedToDate;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Events'),
          content: Column(
            children: <Widget>[
              OrderByDropdown(
                key: orderByDropdownKey,
                onOrderByChanged: (value) {
                  orderByDropdownKey.currentState?.setState(() {
                    // any state changes you want before the rebuild
                  });
                  selectedOrderBy = value;
                },
              ),
              RegionDropdown(
                key: regionDropdownKey,
                onRegionChanged: (value) {
                  regionDropdownKey.currentState?.setState(() {
                    // any state changes you want before the rebuild
                  });          
                  selectedRegion = value;
                },
              ),
              DateRangePicker(
                key: dateRangePickerKey,
                onDateRangeChanged: (fromDate, toDate) {
                  dateRangePickerKey.currentState?.setState(() {
                    // any state changes you want before the rebuild
                  });
                  selectedFromDate = fromDate;
                  selectedToDate = toDate;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Apply'),
              onPressed: () {
                setState(() {
                  // Pass selected filters and date range to the getAllGuardianEventsWithUserData method
                  databaseProvider.getAllGuardianEventsWithUserData(
                    orderBy: selectedOrderBy,
                    region: selectedRegion,
                    fromDate: selectedFromDate,
                    toDate: selectedToDate,
                  );
                });
                orderBy = selectedOrderBy;
                region = selectedRegion;
                fromDate = selectedFromDate;
                toDate = selectedToDate;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              _selectedIndex = 0;
            });
          },
          myevent: false,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: showFilterDialog,
                  child: Text('Filter'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: databaseProvider.getAllGuardianEventsWithUserData(orderBy: orderBy, region: region, fromDate: fromDate, toDate: toDate),
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
      bottomNavigationBar: isLoggedIn ? CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabTapped: (index) {
          setState(() {
          });
        },
      ) : null,
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
