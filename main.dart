import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vroom_app/screens/login_screen.dart';
import 'screens/splash_screen.dart';

import 'screens/main_navigation.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VroomApp());
}

class VroomApp extends StatelessWidget {
  const VroomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: MaterialApp(
        title: 'Vroom - Vehicle Ecosystem',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (authService.isLoading) {
          return const SplashScreen();
        }
        
        if (authService.currentUser != null) {
          return const MainNavigation();
        }
        
        return const LoginScreen();
      },
    );
  }
}
