// guardian_event.dart

class GuardianEvent {
  String id;
  String guardianId;

  GuardianEvent({required this.id, required this.guardianId});

  // Factory constructor to create a GuardianEvent instance from Firestore data
  factory GuardianEvent.fromMap(Map<String, dynamic> data) {
    return GuardianEvent(
      id: data['id'],
      guardianId: data['guardianId'],
    );
  }
}
