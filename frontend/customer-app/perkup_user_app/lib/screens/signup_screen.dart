import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:perkup_user_app/providers/user_provider.dart';
import 'package:perkup_user_app/models/user/user.dart';
import 'package:perkup_user_app/services/api_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Map<String, dynamic> user = {
          'Username': _emailController.text,
          'DisplayName': _nameController.text,
          'FirstName': _nameController.text.split(' ').first,
          'LastName': _nameController.text.split(' ').last,
          'UserEmail': _emailController.text,
          'UserContact': '', // Add appropriate contact field
          'Password': _passwordController.text,
          'Images': '', // Add appropriate image field
          'Description': '', // Add appropriate description field
          'CreatedBy': '', // Add appropriate created by field
          'CreatedAt': DateTime.now().toIso8601String(),
          'UpdatedBy': '', // Add appropriate updated by field
          'UpdatedAt': DateTime.now().toIso8601String(),
          'RoleID': 1, // Add appropriate role ID
          'AddressID': 1, // Add appropriate address ID
        };

        Map<String, dynamic> response = await ApiService.createUser(user);

        // Assuming the response contains UserId and Message
        int userId = response['UserId'];
        String message = response['Message'];

        // Handle successful user creation
        print('User created successfully: $message');

        // Set user in provider
        Provider.of<UserProvider>(context, listen: false).setUser(User(
          id: userId.toString(),
          name: _nameController.text,
          email: _emailController.text,
        ));

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      } catch (error) {
        // Handle error
        print('Error creating user: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating user: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (!EmailValidator.validate(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _register,
                            child: Text(
                              'Register',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 50.0,
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
