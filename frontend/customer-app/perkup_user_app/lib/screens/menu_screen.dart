import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/models/menu/menu.dart'; // Update the path as per your project
import 'package:perkup_user_app/providers/login_provider.dart'; // Update the path as per your project
import 'package:perkup_user_app/providers/menu_provider.dart'; // Update the path as per your project

class MenuScreen extends StatelessWidget {
  final int createdBy;

  const MenuScreen({super.key, required this.createdBy});

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Fetch menus created by the vendor on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = loginProvider.token;
      if (token != null) {
        menuProvider.fetchMenusByCreatedBy(createdBy, token);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menus'),
      ),
      body: Consumer<MenuProvider>(
        builder: (context, menuProvider, child) {
          if (menuProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (menuProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'An error occurred: ${menuProvider.errorMessage}',
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
                          menuProvider.fetchMenusByCreatedBy(createdBy, token);
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (menuProvider.menus.isEmpty) {
            return const Center(
              child: Text("No menus available."),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final token =
                  Provider.of<LoginProvider>(context, listen: false).token;
              if (token != null) {
                await menuProvider.fetchMenusByCreatedBy(createdBy, token);
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: menuProvider.menus.length,
              itemBuilder: (context, index) {
                final menu = menuProvider.menus[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  child: ListTile(
                    leading:
                        const Icon(Icons.menu_book, color: Colors.blueAccent),
                    title: Text(
                      menu.menuName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(menu.description ?? 'No Description'),
                    contentPadding: const EdgeInsets.all(16.0),
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
