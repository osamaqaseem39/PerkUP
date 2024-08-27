import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/models/user/user.dart';
import 'package:perkup_user_app/providers/user_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Required form fields
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                onSaved: (value) => _username = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => _password = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Creating a User object
                    User newUser = User(
                      userID: 0,
                      username: _username,
                      password: _password,
                      userType: "Customer",
                      createdAt:
                          DateTime.now().toString().replaceFirst(" ", "T"),
                      updatedAt:
                          DateTime.now().toString().replaceFirst(" ", "T"),

                      createdBy:
                          currentUser?.userID ?? 0, // Use current user ID
                      updatedBy:
                          currentUser?.userID ?? 0, // Use current user ID
                    );

                    // Save user using provider
                    userProvider.createUser(newUser).then((success) {
                      if (success) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('User created successfully!')),
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to create user')),
                        );
                      }
                    });
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
