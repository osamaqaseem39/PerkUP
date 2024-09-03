import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:perkup_user_app/models/login/login_response.dart';
import 'package:perkup_user_app/models/menu/menu.dart';
import 'package:perkup_user_app/models/menu/menuitem.dart';
import 'package:perkup_user_app/providers/menu_provider.dart';
import 'menu_item_form_screen.dart';

class MenuFormScreen extends StatefulWidget {
  final Menu currentMenu;
  final bool isEditing;

  const MenuFormScreen({
    super.key,
    required this.currentMenu,
    required this.isEditing,
  });

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
    // Initialize fields if editing an existing menu
    if (widget.isEditing) {
      _menuNameController.text = widget.currentMenu.menuName;
      _descriptionController.text = widget.currentMenu.description;
      _isActive = widget.currentMenu.isActive;
      _menuItems = widget.currentMenu.menuItems;

      // Load existing image if available
      if (widget.currentMenu.image.isNotEmpty) {
        try {
          _imageFile = File(widget.currentMenu.image);
        } catch (e) {
          // Handle invalid file paths if necessary
        }
      }
    } else {
      _menuItems = [];
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Save the picked image into the appropriate directory
      final savedImage =
          await _saveImageToLocalDirectory(File(pickedFile.path));
      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  Future<File> _saveImageToLocalDirectory(File image) async {
    // Get application documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Create a subfolder with the menu name and user ID
    final folderPath = path.join(
      directory.path,
      'images',
      '${_menuNameController.text}_${widget.currentMenu.createdBy}',
    );
    final folder = Directory(folderPath);
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    // Save the file with the menu name and ID as part of the file name
    final fileName =
        '${_menuNameController.text}_${widget.currentMenu.menuID}.png';
    final savedImagePath = path.join(folder.path, fileName);

    // Copy the picked image to the desired path
    return image.copy(savedImagePath);
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = MenuProvider();

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
                      : widget.currentMenu.image.isNotEmpty
                          ? Image.network(
                              widget.currentMenu.image,
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
                  // Load the user information from preferences or wherever it is stored
                  LoginResponse? user =
                      await LoginResponse.loadFromPreferences();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    String imagePath = '';
                    if (_imageFile != null) {
                      imagePath = _imageFile!.path; // Use the saved file path
                    } else if (widget.currentMenu.image.isNotEmpty) {
                      imagePath = widget.currentMenu.image;
                    }

                    final menu = Menu(
                      menuID: widget.isEditing ? widget.currentMenu.menuID : 0,
                      menuName: _menuNameController.text,
                      description: _descriptionController.text,
                      isActive: _isActive,
                      createdBy: widget.isEditing
                          ? widget.currentMenu.createdBy
                          : user!.userId,
                      createdAt: widget.isEditing
                          ? widget.currentMenu.createdAt
                          : DateTime.now().toString(),
                      updatedBy: user!.userId,
                      updatedAt: DateTime.now().toString(),
                      menuItems: _menuItems,
                      image: imagePath,
                    );

                    // Use the user's token for API requests
                    String? token =
                        user.token; // Adjust to fetch the token properly

                    if (widget.isEditing) {
                      await menuProvider.updateMenu(
                          menu, token); // Pass the token when updating
                    } else {
                      menuProvider.addMenu(
                          menu, token); // Pass the token when creating
                    }

                    // ignore: use_build_context_synchronously
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
