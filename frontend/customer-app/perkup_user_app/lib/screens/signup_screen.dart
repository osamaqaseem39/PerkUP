import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/user/user.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/providers/user_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/login_image.png',
              height: 200,
            ),
            _buildInputField(
              controller: _usernameController,
              hintText: 'Enter your username',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16.0),
            _buildInputField(
              controller: _emailController,
              hintText: 'Enter your email',
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 16.0),
            _buildInputField(
              controller: _passwordController,
              hintText: 'Enter your password',
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            _buildInputField(
              controller: _confirmPasswordController,
              hintText: 'Confirm your password',
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            userProvider.isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_passwordController.text ==
                            _confirmPasswordController.text) {
                          userProvider.createUser(
                            User(
                              userID: 0, // Or generate an ID as needed
                              userType: 'customer',
                              username: _usernameController.text,
                              displayName: _usernameController.text,
                              firstName: '',
                              lastName: '',
                              userEmail: _emailController.text,
                              userContact: '',
                              password: _passwordController.text,
                              images: '', // Handle images upload as needed
                              roleID: 1, // Set your default role ID here
                              description: '',
                              addressID: 0,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passwords do not match'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Already have an account? Sign In',
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      ),
      obscureText: obscureText,
    );
  }
}
