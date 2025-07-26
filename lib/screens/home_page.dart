import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vroom_app/screens/login_screen.dart';
import 'package:vroom_app/models/car_model.dart';
import 'package:vroom_app/screens/car_details_page.dart';
import 'package:vroom_app/screens/add_car_page.dart';
// Import MockDataService

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to handle user sign out
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper function to determine and build the correct image widget
  Widget _buildCarImage(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 180,
            color: const Color(0xFF1E3A8A),
            child: const Center(
              child: Icon(Icons.broken_image, size: 50, color: Colors.white70),
            ),
          );
        },
      );
    } else {
      return Image.network(
        imageUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 180,
            color: const Color(0xFF1E3A8A),
            child: const Center(
              child: Icon(Icons.broken_image, size: 50, color: Colors.white70),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;
    final String userId = currentUser?.uid ?? 'Not Logged In';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          'Cars',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            label: const Text(
              'List your car on Vroom',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () {
              if (_auth.currentUser == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please log in to add a car.'), backgroundColor: Colors.orange),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCarPage()),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                'User ID: ${userId.substring(0, 6)}...',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
          if (_auth.currentUser != null)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _signOut,
              tooltip: 'Sign Out',
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('cars').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading cars: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No cars available at the moment.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          final List<Car> cars = snapshot.data!.docs.map((doc) {
            return Car.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return Card(
                color: Colors.blue.shade800,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: InkWell(
                  onTap: () {
                    if (_auth.currentUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please log in to view car details.'), backgroundColor: Colors.orange),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage(carToView: car)),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CarDetailsPage(car: car)),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildCarImage(car.imageUrl), // Use the helper function here
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${car.make} ${car.model} (${car.year})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'KSh ${car.pricePerDay.toStringAsFixed(0)} / Day',
                          style: TextStyle(
                            color:const Color(0xFFFF6B35),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
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
      // Removed Floating Action Button to add mock cars
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // Call the mock car addition function from MockDataService
      //     await MockDataService().addMockCars();
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Mock cars added successfully!')),
      //     );
      //   },
      //   backgroundColor:const Color(0xFFFF6B35),
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }
}