// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:perkup_user_app/models/menu/menu.dart';
import 'package:perkup_user_app/models/menu/menuitem.dart';
import 'package:perkup_user_app/providers/menu_provider.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'menu_item_form_screen.dart'; // Adjust the import as necessary

class MenuFormScreen extends StatefulWidget {
  final Menu? currentMenu;
  final bool isEditing;

  const MenuFormScreen(
      {super.key, this.currentMenu, required this.isEditing, Menu? menu});

  @override
  // ignore: library_private_types_in_public_api
  _MenuFormScreenState createState() => _MenuFormScreenState();
}

class _MenuFormScreenState extends State<MenuFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _menuNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;
  bool _isActive = true;
  late List<MenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = widget.isEditing ? widget.currentMenu?.menuItems ?? [] : [];
    if (widget.isEditing) {
      _menuNameController.text = widget.currentMenu?.menuName ?? '';
      _descriptionController.text = widget.currentMenu?.description ?? '';
      _isActive = widget.currentMenu?.isActive ?? true;
      // Load the existing image if available
      if (widget.currentMenu?.image != null &&
          widget.currentMenu?.image.isNotEmpty == true) {
        // For showing the existing image, you may fetch it from server if needed
        _imageFile = File(widget.currentMenu!.image);
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final uri = Uri.parse(
        'YOUR_SERVER_UPLOAD_ENDPOINT'); // Replace with your server upload endpoint
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);
      return responseJson['imagePath']; // Adjust according to your API response
    } else {
      throw Exception('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider =
        MenuProvider(); // Replace with actual provider instance

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Menu' : 'Create Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _menuNameController,
                decoration: const InputDecoration(labelText: 'Menu Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a menu name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 50),
                        ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Select Image'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Active'),
                  Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuItemFormScreen(
                        menuItems: _menuItems,
                      ),
                    ),
                  );
                  if (result != null && result is List<MenuItem>) {
                    setState(() {
                      _menuItems = result;
                    });
                  }
                },
                child: const Text('Add Menu Items'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String imagePath = '';
                    if (_imageFile != null) {
                      try {
                        imagePath = await _uploadImage(_imageFile!);
                      } catch (e) {
                        // Handle image upload error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to upload image')),
                        );
                        return;
                      }
                    }

                    final menu = Menu(
                      menuID: widget.isEditing ? widget.currentMenu!.menuID : 0,
                      menuName: _menuNameController.text,
                      description: _descriptionController.text,
                      isActive: _isActive,
                      createdBy: 1, // Replace with actual user ID
                      createdAt: DateTime.now().toString(),
                      updatedBy: 1, // Replace with actual user ID
                      updatedAt: DateTime.now().toString(),
                      menuItems: _menuItems,
                      image: imagePath,
                    );

                    if (widget.isEditing) {
                      menuProvider.updateMenu(
                          menu.menuID as Menu, menu as String);
                    } else {
                      menuProvider.addMenu(menu);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.isEditing ? 'Update Menu' : 'Create Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
