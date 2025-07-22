import 'package:flutter/material.dart';
import 'package:vroom_app/models/car_model.dart';
import 'package:url_launcher/url_launcher.dart'; // for launching phone dialer and email client

class ListerContactPage extends StatelessWidget{
   final Car car; // The car object cntaining lister details
   const ListerContactPage({Key? key, required this.car}) : super(key:key);

   //Function to launch phone dialer

   Future<void> _launchPhoneDialer(BuildContext context, String phoneNumber) async{
    final Uri launchUri =Uri(
      scheme:'Phone number',
      path:phoneNumber,
    );
    if(await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
      } else {
        //FallBack for web or if dialer not available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch phobe dialer for $phoneNumber')),
        );
      }
   }
   //Function to launch email clinet
   Future<void > _launchEmailClient(BuildContext context, String email) async{
    final Uri launchUri = Uri(
      scheme:'mailto',
      path:email,
      queryParameters: {
        'subject': 'Inquiry about ${car.make} ${car.model} (${car.year})',
        'body': 'Hello ${car.listerName}, \n \nI am interested in hiring the ${car.make} ${car.model} (${car.year}).\n \n Please provide more details regarding its availbility and rental process. \n \nThank you.',
      },
    );
    if (await canLaunchUrl (launchUri)) {
      await launchUrl(launchUri);
    } else{
      // Fall back message if not reachable by email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch email client for $email')),
      );
    }
   }
   @override
   Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:Colors.blue.shade900,
      appBar:AppBar(
        backgroundColor:Colors.blue.shade700,
        title: const Text(
          'contact Lister',
          style:TextStyle(color:Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color:Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Car Image for Context
            ClipRRect(
              borderRadius:BorderRadius.circular(15),
              child:Image.network(
                car.imageUrl,
                height:200,
                width:double.infinity,
                fit:BoxFit.cover,
                errorBuilder:(context, error, stackTrace){
                  return Container(
                    height: 200,
                    color: Colors.blue.shade700,
                    child:const Center(
                      child:Icon (Icons.broken_image, size:60, color:Colors.white70,)
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height:20),
            Text(
             '${car.make} ${car.model} (${car.year})',
             style: const TextStyle(
              color: Colors.white,
              fontSize:24,
              fontWeight:FontWeight.bold,
             ), 
            ),
           const SizedBox(height:8),
            Text(
             'Price: \$${car.pricePerDay.toStringAsFixed(2)}/Day',
             style: const TextStyle(
              color: Colors.orangeAccent,
              fontSize:18,
              fontWeight:FontWeight.bold,
             ), 
            ),
            const SizedBox(height:30),
            //Car lister information section
             const Text(
             'Contact Information',
             style: const TextStyle(
              color: Colors.white,
              fontSize:22,
              fontWeight:FontWeight.bold,
             ), 
            ),
          const SizedBox(height:15),
          
          _buildContactRow(Icons.business, 'Company', car.listerName),
          const SizedBox(height:10),
          _buildContactRow(Icons.phone, 'Phone', car.listerPhone, onTap:()=> _launchPhoneDialer(context, car.listerPhone)),
          const SizedBox(height:10),
          _buildContactRow(Icons.email, 'Email', car.listerEmail, onTap:()=> _launchEmailClient(context, car.listerEmail)),
          const SizedBox(height:10),

          SizedBox(
            width:double.infinity,
            child:ElevatedButton.icon(
              onPressed:()=>_launchPhoneDialer(context, car.listerPhone),
              icon:const Icon(Icons.call, color:Colors.white),
              label:const Text(
                'Call Lister',
                style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold, color:Colors.white),
               ),
               style: ElevatedButton.styleFrom(
                backgroundColor:Colors.green.shade600, 
                padding: const EdgeInsets.symmetric(vertical:18),
                shape:RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(12),
                ),
                elevation:5,
               ),
            ),
          ),
          const SizedBox(height:15),

          SizedBox(
            width:double.infinity,
            child:ElevatedButton.icon(
              onPressed:()=>_launchEmailClient(context, car.listerEmail),
              icon:const Icon(Icons.mail, color:Colors.white),
              label:const Text(
                'Email Lister',
                style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold, color:Colors.white),
               ),
               style: ElevatedButton.styleFrom(
                backgroundColor:Colors.blue.shade600, // Blue for email button
                padding: const EdgeInsets.symmetric(vertical:18),
                shape:RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(12),
                ),
                elevation:5,
               ),
            ),
          ),    
          ],
        ),
      ),
    );

   }
   
    //Helper method to build a consistent contact row

    Widget _buildContactRow(IconData icon, String label, String value, {VoidCallback? onTap}){
      return Container(
        padding:const EdgeInsets.symmetric(horizontal:16, vertical :12),
        decoration: BoxDecoration(
          color: Colors.blue.shade800,
          borderRadius:BorderRadius.circular(10),
          ),
          child: InkWell( //Make the row tappable if onTap is provided
          onTap: onTap,
          child:Row(
            children: [
              Icon(icon, color:Colors.white70, size:24),
              const SizedBox(width:15),
              Expanded(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color:Colors.white,
                        fontSize:16,
                        fontWeight:FontWeight.bold,
                      ),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize:16,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null) // show an arrow if it is tappable
              const Icon(Icons.arrow_forward_ios, color:Colors.white54, size:16),
            ],
          ),
          ),
      );
    }
}

