import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class AddDog extends StatefulWidget {
  final Function()? onDogAdded; // Callback function
  AddDog({this.onDogAdded});

  @override
  _AddDogState createState() => _AddDogState();
}

class _AddDogState extends State<AddDog> {
  String? selectedBreed;
  String dogName = '';
  int? dogAge;
  String customRequests = '';

  final List<String> breeds = [
    "Angleški buldog",
    "Angleški koker španjel",
    "Avstralski kelpie",
    "Avstralski ovčar",
    "Avstralski terier",
    "Basenji",
    "Baset",
    "Bavarski barvar",
    "Beagle",
    "Belgijeski ovčar",
    "Bernardinec",
    "Bernski planšar",
    "Bichon frisé",
    "Bolonjec",
    "Borderski ovčar",
    "Bostonski terier",
    "Bradati škotski ovčar",
    "Bulterier",
    "Cairnski terier",
    "Cane Corso",
    "Cavalier King Charles španjel",
    "Čivava",
    "Coton de Tulear",
    "Dalmatinec",
    "Doberman",
    "Elo",
    "Evrazijec",
    "Francoski buldog",
    "Havanski bišon",
    "Hrvaški ovčar",
    "Irski rdeči seter",
    "Jazbečar",
    "Kitajski goli pes",
    "Kratkodlaki škotski ovčar",
    "Kromforlander",
    "Labradorec",
    "Mali angleški hrt (Whippet)",
    "Mali in srednji nemški špic",
    "Mali italijanski hrt",
    "Mali pudelj",
    "Maltežan",
    "Miniaturni pinč",
    "Mops",
    "Nemška doga",
    "Nemški bokser",
    "Nemški kratkodlaki ptičar",
    "Nemški ovčar",
    "Nemški pinč",
    "Nemški volčji špic",
    "Pomeranec",
    "Pomsky",
    "Pritlikavi jazbečar",
    "Pritlikavi šnavcer",
    "Rotvajler",
    "Ruski hrt (Borzoj)",
    "Ruski mali terier",
    "Samojed",
    "Šarpej",
    "Sibirski husky",
    "Tibetanski terier",
    "Veliki angleški hrt",
    "Višavski terier",
    "Yorkshirski terier (Yorkie)",
    "Zlati prinašalec"
  ];
  bool completeData = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new dog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Dog name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dog name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    dogName = value;
                    checkDataCompletion();
                  });
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Age: '),
                  SizedBox(width: 8.0),
                  DropdownButton<int>(
                    value: dogAge,
                    onChanged: (value) {
                      setState(() {
                        dogAge = value!;
                        checkDataCompletion();
                      });
                    },
                    items: List.generate(30, (index) => index + 1)
                        .map((age) => DropdownMenuItem<int>(
                              value: age,
                              child: Text('$age'),
                            ))
                        .toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Dog breed: '),
                  DropdownButton<String>(
                    hint: Text('Select your dog breed'),
                    value: selectedBreed,
                    onChanged: (newValue) {
                      setState(() {
                        selectedBreed = newValue;
                        checkDataCompletion();
                      });
                    },
                    items: breeds.map((breed) {
                      return DropdownMenuItem<String>(
                        value: breed,
                        child: Text(breed),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Custom Requests',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    customRequests = value;
                  });
                },
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textAlignVertical: TextAlignVertical.top,
              ),
              SizedBox(height: 24.0),
              Container(
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && completeData) {
                      addDogToFirebase();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    onPrimary: Colors.black,
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Add Dog'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkDataCompletion() {
    setState(() {
      completeData = dogName.isNotEmpty &&
          dogAge != null &&
          selectedBreed != null;
    });
  }

  Future<void> addDogToFirebase() async {
    try {
      // Access Firebase Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the current user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      // Create a map containing the dog information
      Map<String, dynamic> dogData = {
        'dogName': dogName,
        'dogAge': dogAge,
        'selectedBreed': selectedBreed,
        'customRequests': customRequests,
        'userId': userId,
      };

      // Add the dog data to a Firestore collection (Replace 'users_dogs' with your collection name)
      await firestore.collection('users_dogs').add(dogData);

      if (widget.onDogAdded != null) {
        widget.onDogAdded!(); // Call the callback function
      }

      // Navigate back to the previous screen
      Navigator.pop(context); // This will pop the current screen




      // Show a success message or perform any other action upon successful addition
      print('Dog added to Firebase!');
    } catch (e) {
      // Handle errors, if any
      print('Error adding dog to Firebase: $e');
    }
  }
}
