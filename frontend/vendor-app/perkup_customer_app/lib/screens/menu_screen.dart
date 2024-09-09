import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_customer_app/providers/login_provider.dart'; // Update the path as per your project
import 'package:perkup_customer_app/providers/menu_provider.dart'; // Update the path as per your project

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
        menuProvider.fetchMenusByCreatedBy(createdBy, token).then((_) {
          print('Menus fetched successfully');
        }).catchError((error) {
          print('Error fetching menus: $error');
        });
      } else {
        print('No token available');
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menu Details
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.menuName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              menu.description,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),

                    // Menu Items
                    if (menu.menuItems.isNotEmpty)
                      ...menu.menuItems.map((item) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            elevation: 2.0,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Text(
                                item.itemName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price: \$${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    item.description,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    if (menu.menuItems.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No items available.'),
                      ),
                    const SizedBox(height: 16.0),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
