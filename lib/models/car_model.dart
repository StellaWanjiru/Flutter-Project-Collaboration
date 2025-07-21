class Car{
  final String id; //Unique ID for the car (Firestore document ID)
  final String make;
  final String model;
  final int year;
  final double pricePerDay;
  final String imageUrl;
  final String fuelType;
  final int seats;
  final bool isAvailable;
  final String listerName;
  final String listerPhone;
  final String listerEmail;



  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this. pricePerDay,
    required this.imageUrl,
    required this.fuelType,
    required this.seats,
    this.isAvailable = true, // Default to make available
    required this.listerName,
    required this.listerPhone,
    required this.listerEmail,
  });

  //Factory constructor to create a Car object from a Firestore document
  factory Car.fromFirestore(Map<String, dynamic> data, String id){
    return Car(
      id:id,
      make: data['make']?? 'Unknown',
      model: data['model']?? 'Unknown',
      year: data['year']?? '2000',
      pricePerDay: (data['pricePerDay'] as num?)?.toDouble()?? 0.0,
      imageUrl: data['imageUrl']?? 'https://placehold.co/600x400/001F3F/FFFFFF?text=No+Image', // Placeholder image
      fuelType: data['fuelType'] ?? 'Petrol',
      seats:data['seats'] ?? 4,
      isAvailable: data['isAvailable']?? true,
      listerName:data ['listerName']?? 'Car Rental Company',
      listerPhone:data ['listerPhone']?? '+254798026615',  
      listerEmail:data [' listerEmail']?? 'info@car.company.com',

    );
  }

  //Method to convert a Car object to a Map for Firestore
  Map<String, dynamic> toFirestore(){
    return{
      'make':make,
      'model':model,
      'year':year,
      'pricePerDay': pricePerDay,
      'imageUrl': imageUrl,
      'fuelType':fuelType,
      'seats':seats,
      'isAvailable':isAvailable,
      'listerName':listerName,
      'listerPhone':listerPhone,
      'listerEmail':listerEmail,

    };
  }


}