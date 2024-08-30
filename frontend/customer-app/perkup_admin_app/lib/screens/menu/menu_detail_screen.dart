import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/menu/menu.dart';
import 'package:perkup_user_app/screens/menu/menu_item_detail_screen.dart';

class MenuDetailScreen extends StatelessWidget {
  final Menu menu;

  const MenuDetailScreen({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menu.menuName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menu.menuName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              menu.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Menu Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: menu.menuItems.length,
                itemBuilder: (context, index) {
                  final menuItem = menu.menuItems[index];
                  return ListTile(
                    title: Text(menuItem.itemName),
                    subtitle: Text(menuItem.description),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuItemDetailScreen(
                            menuItem: menuItem,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
