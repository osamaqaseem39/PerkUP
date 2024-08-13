import 'package:flutter/material.dart';
import 'package:perkup_user_app/providers/user_provider.dart';
import 'package:perkup_user_app/screens/login_screen.dart';
import 'package:perkup_user_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(PerkUpApp());
}

class PerkUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add other providers here
      ],
      child: MaterialApp(
        title: 'PerkUp User App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
          // Define other routes here
        },
      ),
    );
  }
}
