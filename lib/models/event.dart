// event.dart

class Event {
  String id;
  String userId;

  Event({required this.id, required this.userId});

  // Factory constructor to create an Event instance from Firestore data
  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
      id: data['id'],
      userId: data['userId'],
    );
  }
}
