import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
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
  int? _editingItemIndex;

  void _addOrUpdateItem() {
    if (_formKey.currentState!.validate()) {
      // Fetch current user's ID from the provider
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final currentUserId = loginProvider.userId; // Get the user ID

      final newItem = MenuItem(
        menuItemID: _editingItemIndex != null
            ? widget.menuItems[_editingItemIndex!].menuItemID
            : 0,
        menuID: 0, // This will be updated when the menu is created
        itemName: _itemNameController.text,
        description: _descriptionController.text,
        price: int.tryParse(_priceController.text) ?? 0,
        discount: int.tryParse(_discountController.text) ?? 0,
        isPercentageDiscount: _isPercentageDiscount,
        isActive: true,
        category: _categoryController.text,
        createdBy: currentUserId ?? 0, // Use the current user's ID
        createdAt: DateTime.now().toString(),
        updatedBy: currentUserId ?? 0, // Use the current user's ID
        updatedAt: DateTime.now().toString(),
        image: _imageController.text,
      );

      if (_editingItemIndex != null) {
        // Update existing item
        setState(() {
          widget.menuItems[_editingItemIndex!] = newItem;
        });
      } else {
        // Add new item
        setState(() {
          widget.menuItems.add(newItem);
        });
      }

      _resetForm();
    }
  }

  void _resetForm() {
    _itemNameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _discountController.clear();
    _categoryController.clear();
    _imageController.clear();
    setState(() {
      _isPercentageDiscount = false;
      _editingItemIndex = null;
    });
  }

  void _editItem(int index) {
    final item = widget.menuItems[index];
    _itemNameController.text = item.itemName;
    _descriptionController.text = item.description;
    _priceController.text = item.price.toString();
    _discountController.text = item.discount.toString();
    _categoryController.text = item.category;
    _imageController.text = item.image;
    setState(() {
      _isPercentageDiscount = item.isPercentageDiscount;
      _editingItemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Update Menu Items'),
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
              // Other form fields...
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addOrUpdateItem,
                child: Text(
                    _editingItemIndex == null ? 'Add Item' : 'Update Item'),
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
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editItem(index),
                      ),
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
