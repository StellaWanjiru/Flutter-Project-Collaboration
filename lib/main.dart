import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vroom_app/firebase_options.dart';
import 'package:vroom_app/screens/login_screen.dart';
import 'package:vroom_app/screens/register_screen.dart';
import 'package:vroom_app/screens/home_page.dart';
import 'package:vroom_app/services/auth_service.dart';
import 'package:vroom_app/services/mock_data_service.dart'; // Import MockDataService

void main() async {
  // Ensure Flutter widgets are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with default options for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ---------------------------------------------------------------------

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const CarHireApp(),
    ),
  );
}

class CarHireApp extends StatelessWidget {
  const CarHireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vroom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomePage(),
      },
    );
  }
}