import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/menu/menuitem.dart';
import 'package:perkup_vendor_app/screens/menu/menu_item_detail_screen.dart';

class MenuItemListScreen extends StatelessWidget {
  final List<MenuItem> menuItems;

  const MenuItemListScreen({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Items'),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            title: Text(item.itemName),
            subtitle: Text('Price: \$${item.price}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigate to the detail screen for editing
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuItemDetailScreen(menuItem: item),
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
