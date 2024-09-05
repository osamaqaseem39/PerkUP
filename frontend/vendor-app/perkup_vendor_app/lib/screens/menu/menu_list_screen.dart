import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/menu/menu.dart';
import 'package:perkup_vendor_app/screens/menu/menu_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:perkup_vendor_app/providers/login_provider.dart';
import 'package:perkup_vendor_app/providers/menu_provider.dart';
// Ensure this path is correct

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuListScreenState createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  Future<void> _loadMenus() async {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    final token = Provider.of<LoginProvider>(context, listen: false).token;

    if (token != null) {
      await menuProvider.fetchMenus(token);
    } else {
      // Handle the case when token is null (e.g., navigate to login screen or show an error)
      menuProvider.setErrorMessage('Token not found. Please log in again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToMenuFormScreen(context,
                menu: Menu(
                    menuID: 0,
                    menuName: "",
                    description: "",
                    image: "",
                    isActive: true,
                    createdBy: 0,
                    createdAt: "",
                    updatedBy: 0,
                    updatedAt: "",
                    menuItems: [])),
          ),
        ],
      ),
      body: _buildBody(menuProvider),
    );
  }

  Widget _buildBody(MenuProvider menuProvider) {
    if (menuProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (menuProvider.errorMessage != null) {
      return Center(child: Text('Error: ${menuProvider.errorMessage}'));
    }

    if (menuProvider.menus.isEmpty) {
      return const Center(child: Text('No menus available.'));
    }

    return ListView.builder(
      itemCount: menuProvider.menus.length,
      itemBuilder: (context, index) {
        final menu = menuProvider.menus[index];
        return _buildMenuListTile(menu, context);
      },
    );
  }

  Widget _buildMenuListTile(Menu menu, BuildContext context) {
    return ListTile(
      // ignore: unnecessary_null_comparison
      leading: menu.image != null && menu.image.isNotEmpty
          ? Image.network(
              menu.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
          : const Icon(Icons.fastfood, size: 50),
      title: Text(menu.menuName),
      subtitle: Text(menu.description),
      trailing: const Icon(Icons.edit),
      onTap: () => _navigateToMenuFormScreen(context, menu: menu),
    );
  }

  // Navigates to the MenuFormScreen, optionally passing a menu for editing
  void _navigateToMenuFormScreen(BuildContext context, {required Menu menu}) {
    // Determine if we are editing or creating
    final isEditing = menu.menuID != 0;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MenuFormScreen(
          currentMenu: menu,
          isEditing: isEditing, // Pass a bool value instead of null
        ),
      ),
    );
  }
}
