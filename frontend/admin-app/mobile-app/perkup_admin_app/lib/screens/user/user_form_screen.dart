import 'package:flutter/material.dart';
import 'package:perkup_admin_app/components/address_dropdown.dart';
import 'package:perkup_admin_app/models/address/address.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/models/user/user.dart';
import 'package:perkup_admin_app/providers/user_provider.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  // ignore: library_private_types_in_public_api
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _displayName;
  late String _firstName;
  late String _lastName;
  late String _userEmail;
  late String _userContact;
  late String _password;
  late String _images;
  late int _roleID;
  late String _description;
  late int _addressID;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _username = widget.user!.username;
      _displayName = widget.user!.displayName;
      _firstName = widget.user!.firstName;
      _lastName = widget.user!.lastName;
      _userEmail = widget.user!.userEmail;
      _userContact = widget.user!.userContact;
      _password = widget.user!.password;
      _images = widget.user!.images;
      _roleID = widget.user!.roleID;
      _description = widget.user!.description;
      _addressID = widget.user!.addressID;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final token = Provider.of<LoginProvider>(context, listen: false).token;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'New User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.user?.username,
                decoration: const InputDecoration(labelText: 'Username'),
                onSaved: (value) => _username = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a username' : null,
              ),
              TextFormField(
                initialValue: widget.user?.displayName,
                decoration: const InputDecoration(labelText: 'Display Name'),
                onSaved: (value) => _displayName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a display name' : null,
              ),
              TextFormField(
                initialValue: widget.user?.firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
                onSaved: (value) => _firstName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a first name' : null,
              ),
              TextFormField(
                initialValue: widget.user?.lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => _lastName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a last name' : null,
              ),
              TextFormField(
                initialValue: widget.user?.userEmail,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => _userEmail = value!,
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
              ),
              TextFormField(
                initialValue: widget.user?.userContact,
                decoration: const InputDecoration(labelText: 'Contact'),
                onSaved: (value) => _userContact = value!,
                validator: (value) => value!.isEmpty ? 'Enter a contact' : null,
              ),
              TextFormField(
                initialValue: widget.user?.password,
                decoration: const InputDecoration(labelText: 'Password'),
                onSaved: (value) => _password = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a password' : null,
              ),
              TextFormField(
                initialValue: widget.user?.images,
                decoration: const InputDecoration(labelText: 'Images'),
                onSaved: (value) => _images = value!,
                validator: (value) => value!.isEmpty ? 'Enter images' : null,
              ),
              TextFormField(
                initialValue: widget.user?.roleID.toString(),
                decoration: const InputDecoration(labelText: 'Role ID'),
                onSaved: (value) => _roleID = int.parse(value!),
                validator: (value) => value!.isEmpty ? 'Enter a role ID' : null,
              ),
              TextFormField(
                initialValue: widget.user?.description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
              ),
              AddressDropdown(
                token: token!,
                initialAddress: widget.user != null
                    ? Address(
                        addressID: widget.user!.addressID,
                        name: "Selected Address",
                        street: '',
                        area: '',
                        city: '',
                        state: '',
                        postalCode: '',
                        country: '',
                        latitude: null,
                        longitude: null,
                        createdBy: null,
                        createdAt: '',
                        updatedBy: null,
                        updatedAt: '',
                      )
                    : null, // Replace with actual initial address if available
                onAddressSelected: (Address selectedAddress) {
                  _addressID = selectedAddress.addressID;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final user = User(
                      userID: widget.user?.userID ?? 0,
                      userType:
                          "userType", // Replace with actual userType value
                      username: _username,
                      displayName: _displayName,
                      firstName: _firstName,
                      lastName: _lastName,
                      userEmail: _userEmail,
                      userContact: _userContact,
                      password: _password,
                      images: _images,
                      roleID: _roleID,
                      description: _description,
                      addressID: _addressID,
                    );
                    if (widget.user == null) {
                      await userProvider.createUser(user, token);
                    } else {
                      await userProvider.updateUser(user, token);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.user == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
