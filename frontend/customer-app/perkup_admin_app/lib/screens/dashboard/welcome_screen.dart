import 'package:flutter/material.dart';
import 'package:perkup_user_app/screens/perk/perk_list_screen.dart';
import 'package:perkup_user_app/screens/perktype/perktype_list_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key}); // Remove `const` here

  final List<Map<String, dynamic>> _actions = [
    {
      'icon': Icons.handshake,
      'label': 'Manage Perk Types',
      'screen': const PerkTypeListScreen(),
    },
    {
      'icon': Icons.handshake,
      'label': 'Manage Perk',
      'screen': const PerkListScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Admin App'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
          ),
          itemCount: _actions.length,
          itemBuilder: (context, index) {
            final action = _actions[index];
            return ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => action['screen'],
                  ),
                );
              },
              icon: Icon(action['icon'], color: Colors.white),
              label: Text(
                action['label'],
                style: const TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                fixedSize: WidgetStateProperty.all<Size>(const Size(200, 80)),
                elevation: WidgetStateProperty.all<double>(3),
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
