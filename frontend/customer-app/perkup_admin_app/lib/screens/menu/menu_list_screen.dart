import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/providers/login_provider.dart';
import 'package:perkup_user_app/providers/menu_provider.dart';
import 'package:perkup_user_app/screens/menu_form_screen.dart'; // Import the MenuFormScreen

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
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
    await menuProvider.fetchMenus(token!);
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);

    if (menuProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Menus'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (menuProvider.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Menus'),
        ),
        body: Center(
          child: Text('Error: ${menuProvider.errorMessage}'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const MenuFormScreen(), // Navigate to MenuFormScreen
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: menuProvider.menus.length,
        itemBuilder: (context, index) {
          final menu = menuProvider.menus[index];
          return ListTile(
            // ignore: unnecessary_null_comparison
            leading: menu.image != null && menu.image!.isNotEmpty
                ? Image.network(menu.image,
                    width: 50, height: 50, fit: BoxFit.cover)
                : const Icon(Icons.fastfood, size: 50),
            title: Text(menu.menuName),
            subtitle: Text(menu.description ?? 'No description'),
            trailing: const Icon(Icons.edit),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MenuFormScreen(
                      menu: menu), // Pass the menu to MenuFormScreen
                ),
              );
            },
          );
        },
      ),
    );
  }
}
