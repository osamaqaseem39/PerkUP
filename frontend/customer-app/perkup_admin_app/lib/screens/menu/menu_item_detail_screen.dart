import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/menu/menuitem.dart';

class MenuItemDetailScreen extends StatelessWidget {
  final MenuItem menuItem;

  const MenuItemDetailScreen({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuItem.itemName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menuItem.itemName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${menuItem.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Category: ${menuItem.category}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$${menuItem.price}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Discount: ${menuItem.discount}${menuItem.isPercentageDiscount ? '%' : '\$'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Status: ${menuItem.isActive ? 'Active' : 'Inactive'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Add more details as needed
            menuItem.image.isNotEmpty
                ? Image.network(menuItem.image) // Display image if available
                : Container(),
          ],
        ),
      ),
    );
  }
}
