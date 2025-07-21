import 'package:firebase_auth/firebase_auth.dart';
import'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vroom_app/screens/login_screen.dart';
import 'package:vroom_app/models/car_model.dart';
import 'package:vroom_app/screens/car_details_page.dart';
import 'package:my_pocket_wallet/screens/add_car_page.dart'; // Import the new AddCarPage


class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<HomePage> createState()=> _HomePageState();
}

class _HomePageState extends State <HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;
  
  //Function to handle user sign out
Future <void> _signOut() async {
  try{
    await _auth.signOut();
    //Navigate back to the login page and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder:(context)=> const LoginPage()),
      (Route<dynamic> route) => false, // remove all routes from the stack)
    );
  } catch (e){
    //show error if sign out fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:Text('Error signing out: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

@override
Widget build(BuildContext context){
//Get current user ID to display (for demmonstration)
//THis will not be logged In if the user hasn't authenticated
final User? currentUser = _auth.currentUser;
final String userId = currentUser?.uid?? 'Not Logged In';

return Scaffold(
  backgroundColor: Colors.blue.shade900, 
  appBar:AppBar(
    backgroundColor:Colors.blue.shade700,
    title: const Text(
      'Available Cars',
      style: TextStyle(color:Colors.white, fontWeight:FontWeight.bold),
    ),
    actions: [
      //Add car button (for users to list their cars)
      IconButton(
        icon:const Icon(Icons.add_circle_outline,color:Colors.white),
        onPressed:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder:(context)=> const AddCarPage()),
          );
        },
        tooltip: 'List a Car for Hire',
      ),
      //Display user ID
      Padding(
        padding:const EdgeInsets.symmetric(horizontal:8.0),
        child: Center(
          child: Text(
            'User ID: ${userId.substring(0,6)}...',
            style: const TextStyle(color: Colors.white70, fontSize:12),
          ),
        ),
      ),
      //sign Out button
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed:_signOut, // Call sing out function
        tooltip:'Sign Out',
      ),
    ],

  ),
  body: StreamBuilder<QuerySnapshot>(
    //Stream to listen for real-time changes in the 'cars' collection in Firestore
    stream:_firestore.collection('cars').snapshots(),
    builder:(contect, snapshot){
      //show a loading indicator when data is being fetched
      if(snapshot.connectionState==ConnectionState.waiting){
        return const Center(child:CircularProgressIndicator(color:Colors.orangeAccent));
      }
      //show an error message if data fetching fails
      if(snapshot.hasError){
        return Center(
          child:Text(
            'Error loading cars: ${snapshot.error}',
            style: const TextStyle(color:Colors.redAccent, fontSize:16),
          ),
        );
      }
      //show a message if no cars are available
      if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
        return const Center(
          child:Text(
            'Check later for more listings',
            style: const TextStyle(color:Colors.redAccent, fontSize:16),

          ),
        );
      }
// Convert Firestore documents to a list of Car objects
final List<Car> cars = snapshot.data!.docs.map((doc){
  return Car.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
}).toList();
//Display the list of Cars using a ListView
return ListView.builder(
  padding: const EdgeInsets.all(16.0),
  itemCount: cars.length,
  itemBuilder: (context, index){
    final car = cars[index];
    return Card(
      color:Colors.blue.shade800,
      margin: const EdgeInsets.only(bottom:16.0),
      shape:RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(15),
      ),
      elevation: 5, 
      child: InkWell (//make the card tappable
      onTap:(){
        //Navigate to CarDetailsPAge when card is tapped , passing the selected car
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:(context)=>CarDetailsPage(car:car),
          ),
        );
      },
      child: Padding(
        padding:const EdgeInsets.all(16.0),
        child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            //car image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:Image.network(
                car.imageUrl,
                height:180,
                width:double.infinity,
                fit:BoxFit.cover,
                errorBuilder: (context, error,stackTrace){
                  //Fall back widget if image fails to load
                  return Container(
                    height: 180,
                    color:Colors.blue.shade700,
                    child:const Center(
                      child:Icon(Icons.broken_image,size:50,color:Colors.white70),

                    ),
                  );
                },
              ),
              ),
               const SizedBox(height: 12),
                        // Car Make and Model
                        Text(
                          '${car.make} ${car.model} (${car.year})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Price per day
                        Text(
                          '\$${car.pricePerDay.toStringAsFixed(2)} / Day',
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Fuel type and seats
                        Row(
                          children: [
                            Icon(Icons.local_gas_station, color: Colors.white70, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              car.fuelType,
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(width: 15),
                            Icon(Icons.event_seat, color: Colors.white70, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              '${car.seats} Seats',
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Availability status
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Chip(
                            label: Text(
                              car.isAvailable ? 'Available' : 'Booked',
                              style: TextStyle(
                                color: car.isAvailable ? Colors.white : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: car.isAvailable ? Colors.green.shade700 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ), 
);
  }
}

