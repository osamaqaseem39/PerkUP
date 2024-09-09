import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perkup_vendor_app/models/login/login_response.dart';
import 'package:perkup_vendor_app/models/menu/menu.dart';
import 'package:perkup_vendor_app/models/menu/menuitem.dart';
import 'package:perkup_vendor_app/providers/menu_provider.dart';
import 'menu_item_form_screen.dart';
import 'package:http/http.dart' as http;

class MenuFormScreen extends StatefulWidget {
  final Menu currentMenu;
  final bool isEditing;

  const MenuFormScreen({
    super.key,
    required this.currentMenu,
    required this.isEditing,
  });

  @override
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
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _menuNameController.text = widget.currentMenu.menuName;
      _descriptionController.text = widget.currentMenu.description;
      _isActive = widget.currentMenu.isActive;
      _menuItems = widget.currentMenu.menuItems;

      if (widget.currentMenu.image.isNotEmpty) {
        try {
          if (widget.currentMenu.image.startsWith('data:image')) {
            _base64Image = widget.currentMenu.image;
          } else {
            _imageFile = File(widget.currentMenu.image);
          }
        } catch (e) {
          // Handle invalid file paths if necessary
          print('Error loading image: $e');
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
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      setState(() {
        _imageFile = pickedFile as File?;
        _base64Image = base64Image;
      });
    }
  }

  Future<String> _uploadImageToServer(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    try {
      final response = await http.post(
        Uri.parse(
            'YOUR_SERVER_ENDPOINT/upload_image'), // Replace with your server URL
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'image': base64Image,
          'filename':
              '${_menuNameController.text}_${widget.currentMenu.menuID}.png',
        }),
      );

      if (response.statusCode == 200) {
        // Assuming the server responds with the path where the image is saved
        final responseBody = jsonDecode(response.body);
        print('Image upload response: $responseBody');
        return responseBody['path'];
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = MenuProvider();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Menu' : 'Create Menu'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    _base64Image != null
                        ? Image.memory(
                            base64Decode(_base64Image!),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : widget.currentMenu.image.isNotEmpty
                            ? (widget.currentMenu.image.startsWith('data:image')
                                ? Image.memory(
                                    base64Decode(widget.currentMenu.image),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/menu/${widget.currentMenu.image}',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ))
                            : Container(
                                width: 150,
                                height: 150,
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
                  child: Text(
                      widget.isEditing ? 'Edit Menu Items' : 'Add Menu Items'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    LoginResponse? user =
                        await LoginResponse.loadFromPreferences();

                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      String imagePath = '';
                      try {
                        if (_base64Image != null) {
                          imagePath = await _uploadImageToServer(_imageFile!);
                        } else if (_imageFile != null) {
                          imagePath = await _uploadImageToServer(_imageFile!);
                        } else if (widget.currentMenu.image.isNotEmpty) {
                          imagePath = widget.currentMenu.image;
                        }

                        final menu = Menu(
                          menuID:
                              widget.isEditing ? widget.currentMenu.menuID : 0,
                          menuName: _menuNameController.text,
                          description: _descriptionController.text,
                          isActive: _isActive,
                          createdAt:
                              DateTime.now().toString().replaceFirst(" ", "T"),
                          updatedBy: user!.userId,
                          updatedAt:
                              DateTime.now().toString().replaceFirst(" ", "T"),
                          createdBy: user.userId,
                          menuItems: _menuItems,
                          image: imagePath,
                        );

                        String? token = user.token;

                        if (widget.isEditing) {
                          await menuProvider.updateMenu(menu, token);
                          print('Menu updated successfully');
                        } else {
                          await menuProvider.createMenu(menu, token);
                          print('Menu added successfully');
                        }
                        await Future.delayed(Duration(seconds: 3));

                        Navigator.pop(context);
                      } catch (e) {
                        print('Error saving menu: $e');
                      }
                    }
                  },
                  child: Text(widget.isEditing ? 'Update Menu' : 'Create Menu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
