import 'package:flutter/material.dart';
import 'package:pasji_cuvaj/models/dog.dart'; // Import your Dog model
import 'package:pasji_cuvaj/screens/add_dog.dart'; // Import your dog service file
import 'package:pasji_cuvaj/providers/auth_provider.dart';
class YourDogs extends StatefulWidget {
  @override
  _YourDogsState createState() => _YourDogsState();
}

class _YourDogsState extends State<YourDogs> {
  List<Dog> dogs = [];
  final AuthProvider authProvider = AuthProvider();

  @override
  void initState() {
    super.initState();
    fetchDogData();
  }

    Future<void> fetchDogData() async {
    String? currentUserId = authProvider.getCurrentUserUid();
    if (currentUserId != null) {
      List<Dog> fetchedDogs = await getUsersDogsFromFirestore(currentUserId);

      setState(() {
        dogs = fetchedDogs;
      });
    } else {
      // Handle the case where currentUserId is null
      print('Current user ID is null.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text('Your dogs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddDogScreen,
          ),
        ],
      ),
      body: dogs.isNotEmpty
          ? ListView.builder(
              itemCount: dogs.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    print('Dog tapped: ${dogs[index].dogName}');
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        dogs[index].dogName,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age: ${dogs[index].dogAge.toString()}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Breed: ${dogs[index].dogBreed}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Custom Requests: ${dogs[index].customRequests}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> _navigateToAddDogScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDog(
          onDogAdded: refreshDogData,
        ),
      ),
    );
  }

  Future<void> refreshDogData() async {
    await fetchDogData();
    setState(() {});
  }
}
