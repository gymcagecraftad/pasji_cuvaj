// guardian_event_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pasji_cuvaj/models/guardian_event.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class GuardianEventProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  Future<void> createGuardianEvent(GuardianEvent event) async {
    // Pridobi trenutno prijavljenega uporabnika
    firebase_auth.User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      // Če je uporabnik prijavljen, pridobi njegov ID in ustvari dogodek
      String guardianId = currentUser.uid;
      try {
        await _firestore.collection('guardian_events').add({
          'guardianId': guardianId,
          'fromDate': event.fromDate,
          'toDate': event.toDate,
          'location': event.location,
          'housingType': event.housingType,
          'hasYard': event.hasYard,
          'dogSize': event.dogSize,
          'maxDogs': event.maxDogs,
          'pricePerDay': event.pricePerDay,
          'region': event.region,  // Dodano polje za regijo
        });
      } catch (e) {
        print('Error creating guardian event: $e');
      }
    }
  }
}
