import 'package:flutter/material.dart';
import 'package:perkup_user_app/providers/login_provider.dart';
import 'package:perkup_user_app/providers/user_provider.dart';
import 'package:perkup_user_app/screens/home_screen.dart';
import 'package:perkup_user_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        // Uncomment and initialize additional providers as needed
        // ChangeNotifierProvider(create: (_) => AddressProvider()),
        // ChangeNotifierProvider(create: (_) => CountryProvider()),
        // ChangeNotifierProvider(create: (_) => CityProvider()),
        // ChangeNotifierProvider(create: (_) => AreaProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ChangeNotifierProvider(create: (_) => PerkTypeProvider()),
        // ChangeNotifierProvider(create: (_) => PerkProvider())
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
          // Ensure `loginProvider.token` is properly managed and checked
          if (loginProvider.token != null && loginProvider.token!.isNotEmpty) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
