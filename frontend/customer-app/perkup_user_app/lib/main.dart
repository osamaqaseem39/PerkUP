import 'dart:io';

import 'package:flutter/material.dart';
import 'package:perkup_user_app/providers/login_provider.dart';
import 'package:perkup_user_app/providers/perk_provider.dart';
import 'package:perkup_user_app/providers/user_provider.dart';
import 'package:perkup_user_app/screens/home_screen.dart';
import 'package:perkup_user_app/screens/login_screen.dart';
import 'package:perkup_user_app/screens/offer_screen.dart';
import 'package:perkup_user_app/screens/discount_screen.dart';
import 'package:perkup_user_app/screens/voucher_screen.dart';
// import 'package:perkup_user_app/screens/restaurant_screen.dart';
// import 'package:perkup_user_app/screens/profile_screen.dart';
// import 'package:perkup_user_app/screens/settings_screen.dart';
// import 'package:perkup_user_app/screens/help_screen.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),

        ChangeNotifierProvider(create: (_) => PerkProvider()),

        // Add other providers here as needed
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
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => Consumer<LoginProvider>(
                builder: (context, loginProvider, _) {
                  if (loginProvider.token != null) {
                    return const HomeScreen();
                  } else {
                    return const LoginScreen();
                  }
                },
              ),
            );
          case '/offers':
            return MaterialPageRoute(builder: (context) => const OfferScreen());
          case '/discounts':
            return MaterialPageRoute(
                builder: (context) => const DiscountScreen());
          case '/vouchers':
            return MaterialPageRoute(
                builder: (context) => const VoucherScreen());
          // case '/restaurants':
          //   return MaterialPageRoute(
          //       builder: (context) => const RestaurantScreen());
          // case '/profile':
          //   return MaterialPageRoute(
          //       builder: (context) => const ProfileScreen());
          // case '/settings':
          //   return MaterialPageRoute(
          //       builder: (context) => const SettingsScreen());
          // case '/help':
          //   return MaterialPageRoute(builder: (context) => const HelpScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          default:
            return MaterialPageRoute(
                builder: (context) => const LoginScreen()); // Default route
        }
      },
    );
  }
}
