import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';
import 'package:perkup_admin_app/providers/address_provider.dart';
import 'package:perkup_admin_app/screens/login/login_screen.dart';
import 'package:perkup_admin_app/screens/dashboard/welcome_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<LoginProvider>(
        builder: (context, loginProvider, _) {
          if (loginProvider.token != null) {
            return const WelcomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
