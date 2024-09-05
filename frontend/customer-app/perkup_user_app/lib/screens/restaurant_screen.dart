import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/providers/login_provider.dart'; // Update the path as per your project
import 'package:perkup_user_app/providers/user_provider.dart'; // Update the path as per your project

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Fetch vendors on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = loginProvider.token;
      if (token != null) {
        userProvider.fetchUsersByType('vendor');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'An error occurred: ${userProvider.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final token =
                            Provider.of<LoginProvider>(context, listen: false)
                                .token;
                        if (token != null) {
                          userProvider.fetchUsersByType('vendor');
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (userProvider.users.isEmpty) {
            return const Center(
              child: Text("No restaurants available."),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final token =
                  Provider.of<LoginProvider>(context, listen: false).token;
              if (token != null) {
                await userProvider.fetchUsersByType('vendor');
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                final vendor = userProvider.users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  child: ListTile(
                    leading: const Icon(Icons.restaurant, color: Colors.green),
                    title: Text(
                      vendor.displayName ?? 'Unnamed Vendor',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(vendor.username ?? 'No Username'),
                    contentPadding: const EdgeInsets.all(16.0),
                    onTap: () {
                      // Navigate to MenuScreen with vendor's createdBy ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuScreen(
                            createdBy: vendor.userID,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
