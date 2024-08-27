import 'package:flutter/material.dart';
import 'package:perkup_user_app/providers/country_provider.dart';
import 'package:perkup_user_app/providers/perk_provider.dart';
import 'package:perkup_user_app/providers/perktype_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/providers/login_provider.dart';
import 'package:perkup_user_app/providers/address_provider.dart';
import 'package:perkup_user_app/providers/city_provider.dart'; // Import the CityProvider
import 'package:perkup_user_app/screens/login/login_screen.dart';
import 'package:perkup_user_app/screens/dashboard/welcome_screen.dart';
import 'package:perkup_user_app/providers/area_provider.dart';
import 'package:perkup_user_app/providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => CityProvider()),
        ChangeNotifierProvider(create: (_) => AreaProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PerkTypeProvider()),
        ChangeNotifierProvider(create: (_) => PerkProvider())
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
            return WelcomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
