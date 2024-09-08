import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/menu/menuitem.dart';

class MenuItemDetailScreen extends StatefulWidget {
  final MenuItem menuItem;

  const MenuItemDetailScreen({super.key, required this.menuItem});

  @override
  // ignore: library_private_types_in_public_api
  _MenuItemDetailScreenState createState() => _MenuItemDetailScreenState();
}

class _MenuItemDetailScreenState extends State<MenuItemDetailScreen> {
  bool isEditMode = true;

  // Controllers for editing fields
  late TextEditingController itemNameController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController discountController;
  bool isPercentageDiscount = false;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current menu item values
    itemNameController = TextEditingController(text: widget.menuItem.itemName);
    descriptionController =
        TextEditingController(text: widget.menuItem.description);
    categoryController = TextEditingController(text: widget.menuItem.category);
    priceController =
        TextEditingController(text: widget.menuItem.price.toString());
    discountController =
        TextEditingController(text: widget.menuItem.discount.toString());
    isPercentageDiscount = widget.menuItem.isPercentageDiscount;
    isActive = widget.menuItem.isActive;
  }

  @override
  void dispose() {
    // Dispose controllers when the screen is disposed
    itemNameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    priceController.dispose();
    discountController.dispose();
    super.dispose();
  }

  void saveChanges() {
    // Update the menuItem with the new values from the controllers
    setState(() {
      widget.menuItem.itemName = itemNameController.text;
      widget.menuItem.description = descriptionController.text;
      widget.menuItem.category = categoryController.text;
      widget.menuItem.price =
          int.tryParse(priceController.text) ?? widget.menuItem.price;
      widget.menuItem.discount =
          int.tryParse(discountController.text) ?? widget.menuItem.discount;
      widget.menuItem.isPercentageDiscount = isPercentageDiscount;
      widget.menuItem.isActive = isActive;
      isEditMode = false; // Exit edit mode after saving
    });

    // Implement the save logic here, such as updating the backend or state management
    // For example, you could call a provider method or API to save changes
    Navigator.pop(
        context, widget.menuItem); // Optionally return the updated item
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.menuItem.itemName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: itemNameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: discountController,
              decoration: const InputDecoration(labelText: 'Discount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Percentage Discount'),
                Switch(
                  value: isPercentageDiscount,
                  onChanged: (value) {
                    setState(() {
                      isPercentageDiscount = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Active Status'),
                Switch(
                  value: isActive,
                  onChanged: (value) {
                    setState(() {
                      isActive = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            widget.menuItem.image.isNotEmpty
                ? Image.network(widget.menuItem.image)
                : Container(),
          ],
        ),
      ),
    );
  }
}
