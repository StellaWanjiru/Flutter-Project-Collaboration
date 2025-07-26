import 'package:flutter/material.dart';
import 'package:vroom_app/models/car_model.dart';
import 'package:vroom_app/screens/lister_contact_page.dart';

class CarDetailsPage extends StatelessWidget {
  final Car car;

  const CarDetailsPage({super.key, required this.car});

  // Helper function to determine and build the correct image widget
  Widget _buildCarImage(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 250,
            color: Colors.blue.shade700,
            child: const Center(
              child: Icon(Icons.broken_image, size: 80, color: Colors.white70),
            ),
          );
        },
      );
    } else {
      return Image.network(
        imageUrl,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 250,
            color: Colors.blue.shade700,
            child: const Center(
              child: Icon(Icons.broken_image, size: 80, color: Colors.white70),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.blue.shade700,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: Text(
          '${car.make} ${car.model} Details',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: _buildCarImage(car.imageUrl), // Use the helper function here
            ),
            const SizedBox(height: 20),

            Text(
              '${car.make} ${car.model}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Year: ${car.year}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 15),

            Text(
              'Price: KSh ${car.pricePerDay.toStringAsFixed(0)} / Day',
              style: const TextStyle(
                color: Color(0xFFFF6B35),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildDetailRow(Icons.local_gas_station, 'Fuel Type', car.fuelType),
            _buildDetailRow(Icons.event_seat, 'Seats', '${car.seats}'),
            _buildDetailRow(
              car.isAvailable ? Icons.check_circle : Icons.cancel,
              'Availability',
              car.isAvailable ? 'Available' : 'Booked',
              textColor: car.isAvailable ? Colors.greenAccent : Colors.redAccent,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: car.isAvailable ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListerContactPage(car: car),
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: car.isAvailable ?  const Color(0xFFFF6B35) : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  car.isAvailable ? 'Contact Lister' : 'Not Available',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color textColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 15),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
