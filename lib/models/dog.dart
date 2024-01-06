// event.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Dog {
  String dogBreed;
  String? customRequests;
  int dogAge;
  String dogName;

  Dog(
      {required this.dogBreed,
      this.customRequests,
      required this.dogAge,
      required this.dogName});

  // Factory constructor to create an Event instance from Firestore data
  factory Dog.fromMap(Map<String, dynamic> data) {
    return Dog(
      dogBreed: data.containsKey('selectedBreed')
          ? data['selectedBreed'] as String
          : '',
      dogAge: data.containsKey('dogAge') ? data['dogAge'] as int : 0,
      dogName: data.containsKey('dogName') ? data['dogName'] as String : '',
      customRequests: data.containsKey('customRequests')
          ? data['customRequests'] as String
          : '',
    );
  }
}

Future<List<Dog>> getUsersDogsFromFirestore(String userId) async {
  try {
    // Access Firebase Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Retrieve the collection 'users_dogs' where userId matches
    QuerySnapshot querySnapshot = await firestore
        .collection('users_dogs')
        .where('userId', isEqualTo: userId)
        .get();

    // Iterate through the retrieved documents and map them to Dog objects
    List<Dog> dogs = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Dog.fromMap(data);
    }).toList();

    // Return the list of Dog objects
    return dogs;
  } catch (e) {
    // Handle errors, if any
    print('Error getting dogs from Firebase: $e');
    return []; // Return an empty list if there's an error
  }
}
