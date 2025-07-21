// Users list their cars in a form that is stored in the firebase Cars collection

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vroom_app/models/car_model.dart';
import 'package:vroom_app/screens/add_car_page.dart';


class AddCarPage  extends StatefulWidget{
  const AddCarPage({Key? key}):super(key:key);
  @override
  _AddCarPageState createState()=> _AddCarPageState();
}
class _AddCarPageState extends State <AddCarPage>{
  final _formKey = GlobalKey<FormState>(); // Key form validation
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
 
 // Text editing controllers for form fields

 final TextEditingController _makeController = TextEditingController();
 final TextEditingController _modelController = TextEditingController();
 final TextEditingController _yearController = TextEditingController();
 final TextEditingController _priceController = TextEditingController();
 final TextEditingController _imageUrlController = TextEditingController();
 final TextEditingController _fuelTypeController = TextEditingController();
 final TextEditingController _seatsController = TextEditingController();
 final TextEditingController _listerNameController = TextEditingController();
 final TextEditingController _listerPhoneController = TextEditingController();
 final TextEditingController _listerEmailController = TextEditingController();

// Dispose controller to prevent memory leaks
@override
void dispose(){
  _makeController.dispose();
  _modelController.dispose();
  _yearController.dispose();
  _priceController.dispose();
  _imageUrlController.dispose();
  _fuelTypeController.dispose();
  _seatsController.dispose();
  _listerNameController.dispose();
  _listerPhoneController.dispose();
  _listerEmailController.dispose();
  super.dispose();
}
// Function to ass a new car to Firestore
Future<void> _addCarToFirestore() async{
  if (_formKey.currentState!.validate()){
    //Create a Car object from form inputs
    final newCar =Car(
      id:'',
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      pricePerDay:double.parse(_priceController.text.trim()),
      imageUrl: _imageUrlController.text.trim(),
      fuelType: _fuelTypeController.text.trim(),
      seats: int.parse(_seatsController.text.trim()),
      isAvailable: true, // New listings are typically available by default
      listerName: _listerNameController.text.trim(),
      listerPhone: _listerPhoneController.text.trim(),
      listerEmail: _listerEmailController.text.trim(),
    );
    try{
      // Add a new car to the cars collection
      await _firestore.collection('cars').add(newCar.toFirestore());
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Car added successfully!'), backgroundColor: Colors.green),
        );
       Navigator.pop(context); // Go back to the previous screen (HomePage)
    }catch(e){
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add Car: $e'), backgroundColor: Colors.red),
        );
    }
  }
}

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'Add New Car',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Back button color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Helper for building text input fields
              _buildTextInputField(_makeController, 'Make', 'e.g., Toyota', validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter car make';
                return null;
              }),
              const SizedBox(height: 16),
              _buildTextInputField(_modelController, 'Model', 'e.g., Camry', validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter car model';
                return null;
              }),
              const SizedBox(height: 16),
              _buildTextInputField(_yearController, 'Year', 'e.g., 2023', keyboardType: TextInputType.number, validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter year';
                if (int.tryParse(value) == null) return 'Please enter a valid number';
                return null;
              }),
              const SizedBox(height: 16),
              _buildTextInputField(_priceController, 'Price Per Day (\$)', 'e.g., 75.00', keyboardType: TextInputType.number, validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter price';
                if (double.tryParse(value) == null) return 'Please enter a valid number';
                return null;
              }),
              const SizedBox(height: 16),
              _buildTextInputField(_imageUrlController, 'Image URL', 'e.g., https://example.com/car.jpg', keyboardType: TextInputType.url, validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter image URL';
                if (!Uri.tryParse(value)!.hasAbsolutePath) return 'Please enter a valid URL';
                return null;
              }),
              const SizedBox(height: 16),
              _buildTextInputField(_fuelTypeController, 'Fuel Type', 'e.g., Petrol, Electric', validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter fuel type';
                return null;
              }),
              const SizedBox(height: 16),
              _buildTextInputField(_seatsController, 'Number of Seats', 'e.g., 5', keyboardType: TextInputType.number, validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter number of seats';
                if (int.tryParse(value) == null) return 'Please enter a valid number';
                return null;
              }),
              const SizedBox(height: 24),
              const Text(
                'Lister Information',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextInputField(_listerNameController, 'Lister Name', 'e.g., ABC Car Rentals', validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter lister name';
                return null;
              }),
              const SizedBox(height: 16),
              _buildTextInputField(_listerPhoneController, 'Lister Phone', 'e.g., +1234567890', keyboardType: TextInputType.text, validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter lister phone';
                return null;
              }),
              const SizedBox(height: 16),
              _buildTextInputField(_listerEmailController, 'Lister Email', 'e.g., lister@example.com', keyboardType: TextInputType.emailAddress, validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter lister email';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Please enter a valid email';
                return null;
              }),
              const SizedBox(height: 30),

              // Add Car Button
              ElevatedButton(
                onPressed: _addCarToFirestore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Add Car',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a consistent TextFormField
  Widget _buildTextInputField(
    TextEditingController controller,
    String labelText,
    String hintText, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.blue.shade800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
 
    

