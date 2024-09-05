import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/menu/menuitem.dart';

class MenuItemFormScreen extends StatefulWidget {
  final List<MenuItem> menuItems;

  const MenuItemFormScreen({super.key, required this.menuItems});

  @override
  // ignore: library_private_types_in_public_api
  _MenuItemFormScreenState createState() => _MenuItemFormScreenState();
}

class _MenuItemFormScreenState extends State<MenuItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  bool _isPercentageDiscount = false;

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = MenuItem(
        menuItemID: 0, // Assign ID based on your backend logic
        menuID: 0, // This will be updated when the menu is created
        itemName: _itemNameController.text,
        description: _descriptionController.text,
        price: int.tryParse(_priceController.text) ?? 0,
        discount: int.tryParse(_discountController.text) ?? 0,
        isPercentageDiscount: _isPercentageDiscount,
        isActive: true,
        category: _categoryController.text,
        createdBy: 1, // Replace with actual user ID
        createdAt: DateTime.now().toString(),
        updatedBy: 1, // Replace with actual user ID
        updatedAt: DateTime.now().toString(),
        image: _imageController.text,
      );

      setState(() {
        widget.menuItems.add(newItem);
      });

      _itemNameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _discountController.clear();
      _categoryController.clear();
      _imageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Menu Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: 'Discount'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              Row(
                children: [
                  const Text('Percentage Discount'),
                  Switch(
                    value: _isPercentageDiscount,
                    onChanged: (value) {
                      setState(() {
                        _isPercentageDiscount = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addItem,
                child: const Text('Add Item'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.menuItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.menuItems[index];
                    return ListTile(
                      title: Text(item.itemName),
                      subtitle: Text('Price: \$${item.price}'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, widget.menuItems);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
