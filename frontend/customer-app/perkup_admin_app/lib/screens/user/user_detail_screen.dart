import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/providers/user_provider.dart';

import 'package:perkup_user_app/screens/user/user_form_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final int userID;
  const UserDetailScreen({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.users.firstWhere((usr) => usr.userID == userID);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserFormScreen(user: user),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              bool? deleteConfirmed = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete User'),
                    content: const Text(
                        'Are you sure you want to delete this user?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );

              if (deleteConfirmed == true) {
                await userProvider.deleteUser(userID);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Username: ${user.username}'),
            Text('Display Name: ${user.displayName}'),
            Text('First Name: ${user.firstName}'),
            Text('Last Name: ${user.lastName}'),
            Text('Email: ${user.userEmail}'),
            Text('Contact: ${user.userContact}'),
            Text('Role ID: ${user.roleID}'),
            Text('Description: ${user.description}'),
            Text('Address ID: ${user.addressID}'),
          ],
        ),
      ),
    );
  }
}
