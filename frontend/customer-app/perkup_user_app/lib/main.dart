import 'package:flutter/material.dart';
import 'package:perkup_user_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/screens/home_screen.dart';
import 'package:perkup_user_app/screens/login_screen.dart'; // Import your screens
import 'package:perkup_user_app/screens/signup_screen.dart'; // Import your screens

void main() {
  runApp(const PerkUpApp());
}

class PerkUpApp extends StatelessWidget {
  const PerkUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add other providers here if needed
      ],
      child: MaterialApp(
        title: 'PerkUp User App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: ThemeData.light().textTheme.apply(
                fontFamily: 'Poppins', // Apply your custom font
              ),
        ),
        home: const LoginScreen(), // Set the initial screen
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) =>
              const SignUpScreen(), // Added SignUpScreen route
          // Define other routes here
        },
      ),
    );
  }
}
