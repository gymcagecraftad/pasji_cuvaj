// database_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasji_cuvaj/models/myuser.dart';

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
}
