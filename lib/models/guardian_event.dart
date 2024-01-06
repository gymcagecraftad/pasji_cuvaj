// models/guardian_event.dart

class GuardianEvent {
  String id;
  String guardianId;
  String fromDate;
  String toDate;
  String location;
  String housingType;
  bool hasYard;
  String dogSize;
  int maxDogs;
  double pricePerDay;
  String region;

  GuardianEvent({
    required this.id,
    required this.guardianId,
    required this.fromDate,
    required this.toDate,
    required this.location,
    required this.housingType,
    required this.hasYard,
    required this.dogSize,
    required this.maxDogs,
    required this.pricePerDay,
    required this.region,
  });

  // Factory constructor to create a GuardianEvent instance from Firestore data
  factory GuardianEvent.fromMap(Map<String, dynamic> data) {
  return GuardianEvent(
    id: data['id'] ?? '',
    guardianId: data['guardianId'] ?? '',
    fromDate: data['fromDate'] ?? '',
    toDate: data['toDate'] ?? '',
    location: data['location'] ?? '',
    housingType: data['housingType'] ?? '',
    hasYard: data['hasYard'] ?? false,
    dogSize: data['dogSize'] ?? '',
    maxDogs: data['maxDogs'] ?? 0,
    pricePerDay: data['pricePerDay'] ?? 0.0,
    region: data['region'] ?? '',
  );
}

}
