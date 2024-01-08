// database_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasji_cuvaj/models/myuser.dart';
import 'package:pasji_cuvaj/models/guardian_event.dart'; 
import 'package:intl/intl.dart';


class DatabaseProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<MyUser?> getUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // Convert Firestore data to a MyUser object using the factory constructor
        return MyUser.fromMap(userSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<List<MyUser>> getAllUsers() async {
    try {
      QuerySnapshot usersSnapshot =
          await _firestore.collection('users').get();

      List<MyUser> users = [];

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        if (userDoc.exists) {
          // Convert Firestore data to a MyUser object using the factory constructor
          MyUser user = MyUser.fromMap(userDoc.data() as Map<String, dynamic>);
          users.add(user);
        }
      }

      return users;
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }
  Future<void> createGuardianEvent(GuardianEvent event) async {
    try {
      await _firestore.collection('guardian_events').add({
        'guardianId': event.guardianId,
      });
    } catch (e) {
      print('Error creating guardian event: $e');
    }
  }


  Future<List<Map<String, dynamic>>> getAllGuardianEventsWithUserData({String? orderBy, String? region, DateTime? fromDate, DateTime? toDate,}) async {
    try {
      Query query = _firestore.collection('guardian_events');
      
      if (orderBy != null  && orderBy != "No Order") {
        if(orderBy == "Price Ascending"){
          query = query.orderBy("pricePerDay");
        }
        else{
          query = query.orderBy("pricePerDay", descending: true);
        }
      }

      // Apply region filter
      if (region != null) {
        query = query.where('region', isEqualTo: region);
      }

      // Apply date range filter
      if (fromDate != null) {
        String fromDateStr = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(fromDate);
        query = query.where('fromDate', isGreaterThanOrEqualTo: fromDateStr);
      }

      if (toDate != null) {
        String toDateStr = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(toDate);
        query = query.where('toDate', isLessThanOrEqualTo: toDateStr);
      }
      // Add more where clauses for additional filters
      QuerySnapshot eventsSnapshot = await query.get();
      List<Map<String, dynamic>> events = [];

      for (QueryDocumentSnapshot eventDoc in eventsSnapshot.docs) {
        if (eventDoc.exists) {
          // Pridobite ime dokumenta Firestore
          String eventID = eventDoc.id;

          // Pridobite podatke o dogodku iz dokumenta
          GuardianEvent event =
              GuardianEvent.fromMap(eventDoc.data() as Map<String, dynamic>);

          // Posodobite atribut id vašega modela GuardianEvent z imenom dokumenta
          event.id = eventID;

          // Pridobi podatke o uporabniku na podlagi guardianId
          MyUser? user = await getUser(event.guardianId);

          // Dodaj podatke o uporabniku v mapo dogodka
          events.add({
            'event': event,
            'userName': user?.name ?? '', // Uporabite polje, ki vsebuje ime uporabnika
          });
        }
      }

      return events;
    } catch (e) {
      print('Error getting all guardian events: $e');
      return [];
    }
  }


  Future<String> getGuardianName(String guardianId) async {
    try {
      MyUser? user = await getUser(guardianId);
      return user?.name ?? '';
    } catch (e) {
      print('Error getting guardian name: $e');
      return '';
    }
  }

  Future<List<Map<String, String>>> getDogsByCurrentUser(String userId) async {
    try {
      QuerySnapshot dogsSnapshot = await _firestore
          .collection('users_dogs')
          .where('userId', isEqualTo: userId)
          .get();

      List<Map<String, String>> dogs = [];

      for (QueryDocumentSnapshot dogDoc in dogsSnapshot.docs) {
        if (dogDoc.exists) {
          // Pridobite podatke o psu iz dokumenta
          String dogId = dogDoc.id;
          String dogName = dogDoc['dogName'];

          // Dodaj ime psa in njegov ID v seznam
          dogs.add({
            'dogId': dogId,
            'dogName': dogName,
          });
        }
      }

      return dogs;
    } catch (e) {
      print('Error getting dogs by current user: $e');
      return [];
    }
  }

  Future<void> submitDogToEvent({
    required String eventID,
    required String dogID,
    required String fromDate,
    required String toDate,
  }) async {
      try {
        await _firestore.collection('event_registered_dogs').add({
          'eventID': eventID,
          'dogID': dogID,
          'fromDate': fromDate,
          'toDate': toDate,
        });
      } catch (e) {
        print('Error submitting dog to event: $e');
    }
  }

  Future<Map<String, DateTime>> getEventDates(String eventID) async {
    try {
      DocumentSnapshot eventSnapshot =
          await _firestore.collection('guardian_events').doc(eventID).get();

      if (eventSnapshot.exists) {
        // Pridobite podatke o dogodku iz dokumenta
        GuardianEvent event =
            GuardianEvent.fromMap(eventSnapshot.data() as Map<String, dynamic>);

        // Parse strings into DateTime objects
        DateTime startDate = DateTime.parse(event.fromDate);
        DateTime endDate = DateTime.parse(event.toDate);

        return {
          'startDate': startDate,
          'endDate': endDate,
        };
      } else {
        print('Event with ID $eventID does not exist.');
        return {};
      }
    } catch (e) {
      print('Error getting event dates: $e');
      return {};
    }
  }

  Future<void> updateEventMaxDogs(String eventID) async {
    try {
      DocumentReference eventRef =
          _firestore.collection('guardian_events').doc(eventID);

      await eventRef.update({'maxDogs': FieldValue.increment(-1)});
    } catch (e) {
      print('Error updating event maxDogs: $e');
    }
  }
  Future<List<GuardianEvent>> getMyGuardianEvents(String? userId) async {
  try {
    QuerySnapshot eventsSnapshot = await _firestore
        .collection('guardian_events')
        .where('guardianId', isEqualTo: userId)
        .get();

    List<GuardianEvent> events = [];

    for (QueryDocumentSnapshot eventDoc in eventsSnapshot.docs) {
      if (eventDoc.exists) {
        // Pridobite ime dokumenta Firestore
        String eventID = eventDoc.id;

        // Pridobite podatke o dogodku iz dokumenta
        GuardianEvent event =
            GuardianEvent.fromMap(eventDoc.data() as Map<String, dynamic>);

        // Posodobite atribut id vašega modela GuardianEvent z imenom dokumenta
        event.id = eventID;

        // Dodaj dogodek v seznam
        events.add(event);
      }
    }
    return events;
  } catch (e) {
    print('Error getting my guardian events: $e');
    return [];
  }
}
 Future<void> deleteGuardianEvent(String eventId) async {
    try {
      await _firestore.collection('guardian_events').doc(eventId).delete();
    } catch (e) {
      print('Error deleting guardian event: $e');
    }
  }
  Future<void> updateGuardianEvent(GuardianEvent event) async {
  try {
      DocumentReference eventRef = _firestore.collection('guardian_events').doc(event.id);

      await eventRef.update({
        'location': event.location,
        'maxDogs': event.maxDogs,
        'pricePerDay': event.pricePerDay,
        // Add more fields to update as needed
      });
    } catch (e) {
      print('Error updating guardian event: $e');
    }
  }
 Future<List<Map<String, dynamic>>> getDogsInEvent(String eventID) async {
    try {
      QuerySnapshot dogsSnapshot = await _firestore
          .collection('event_registered_dogs')
          .where('eventID', isEqualTo: eventID)
          .get();

      List<Map<String, dynamic>> dogsInfo = [];

      for (QueryDocumentSnapshot dogDoc in dogsSnapshot.docs) {
        if (dogDoc.exists) {
          // Pridobite podatke o psu iz dokumenta
          String dogID = dogDoc['dogID'];
          String fromDate = dogDoc['fromDate'];
          String toDate = dogDoc['toDate'];

          // Uporabite dogID, da dobite podatke o psu iz 'users_dogs'
          Map<String, dynamic> dogData = await getDogData(dogID);
          MyUser? userData = await getUser(dogData['userId']);
          // Dodaj informacije o psu v seznam
          dogsInfo.add({
            'dogID': dogID,
            'dogName': dogData['dogName'],
            'dogAge': dogData['dogAge'],
            'selectedBreed': dogData['selectedBreed'],
            'fromDate': fromDate,
            'toDate': toDate,
            'email': userData?.email
          });
        }
      }

      return dogsInfo;
    } catch (e) {
      print('Error getting dogs in event: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getDogData(String dogID) async {
    try {
      DocumentSnapshot dogSnapshot = await _firestore.collection('users_dogs').doc(dogID).get();

      if (dogSnapshot.exists) {
        // Pridobite podatke o psu iz dokumenta 'users_dogs'
        return dogSnapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print('Error getting dog data: $e');
      return {};
    }
  }
}


