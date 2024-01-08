// user.dart

class MyUser {
  String name;
  String username;
  String surname;
  String email;

  MyUser({required this.name, required this.username, required this.surname, required this.email});

  // Factory constructor to create a User instance from Firestore data
  factory MyUser.fromMap(Map<String, dynamic> data) {
    return MyUser(
      name: data['name'],
      username: data['username'],
      surname: data['surname'],
      email: data['email']
    );
  }
}
