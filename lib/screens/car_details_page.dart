import 'package:flutter/material.dart';
import 'package:vroom_app/models/car_model.dart';

class CarDetailsPage extends StatelessWidget{
  final Car car; // The car object is passed to this page

  const CarDetailsPage({Key? key, required this.car}): super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          '${car.make} ${car.model} Details',
          style: const TextStyle(color:Colors.white, fontWeight:FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color:Colors.white), //Back button color
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //car image(large)
            ClipRRect(
            borderRadius:BorderRadius.circular(15),
            child:Image.network(
              car.imageUrl,
              height:250,
              width:double.infinity,
              fit:BoxFit.cover,
              errorBuilder: (context, error, stackTrace){
                return Container(
                  height:250,
                  color:Colors.blue.shade700,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 80, color:Colors.white70),
                  ),
                );
              },
            ),
            ),
            const SizedBox(height:20),

            //Car Make, Model, Year
            Text(
              '${car.make} ${car.model}',
              style: const TextStyle(
                color: Colors.white,
                fontSize:28,
                fontWeight:FontWeight.bold,
              ),
            ),
            Text(
              'Year: ${car.year}',
                style: const TextStyle(
                color: Colors.white,
                fontSize:18,
              ),
            ),
            //Price per day
            Text(
              'Price: \$${car.pricePerDay.toStringAsFixed(2)}/Day',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize:22,
                fontWeight:FontWeight.bold,
              ),
            ),
           const SizedBox(height:20),
           //Details section
           _buildDetailRow(Icons.local_gas_station,'Fuel Type', car.fuelType),
           _buildDetailRow(Icons.event_seat,'Seats', '${car.seats}'),
           _buildDetailRow(
            car.isAvailable? Icons.check_circle:Icons.cancel,
            'Availability',
            car.isAvailable? 'Available' : 'Booked',
            textColor:car.isAvailable? Colors.greenAccent:Colors.redAccent,
           ), 
          const SizedBox(height:20),

          // Booking Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:car.isAvailable?(){
                //TODO Implement booking logic or navigate to booking form
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Booking ${car.make} ${car.model}...(Feature coming soon)')),
                );
              } :null , //Disable button is car is not available
              style: ElevatedButton.styleFrom(
                backgroundColor : car.isAvailable? Colors.orangeAccent :Colors.grey,
                padding: const EdgeInsets.symmetric(vertical:18),
                shape:RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(
               car.isAvailable? 'Book now': 'Not Available',
                style: const TextStyle(
                color: Colors.white,
                fontSize:20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ),
            ),
          ],
        ),
      ),
    );
   }
    //Helper method to build a consistent detail row
    Widget _buildDetailRow(IconData icon, String label, String value,{Color textColor=Colors.white}){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical:8.0),
        child:Row(
          children: [
            Icon(icon, color: Colors.white70, size:24),
           const SizedBox(width:15),
            Text(
              '$label:',
                style: const TextStyle(
                color: Colors.white,
                fontSize:16,
                fontWeight: FontWeight.bold,

              ),
            ),
             Text(
              value,
              style:  TextStyle(
                color: textColor,
                fontSize:16,
              ),
             ),
          ],
        ),
      );
     
  }

}