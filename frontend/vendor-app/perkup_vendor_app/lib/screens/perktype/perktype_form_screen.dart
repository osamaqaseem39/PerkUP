import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/perk/perktype.dart';
import 'package:perkup_vendor_app/providers/perktype_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_vendor_app/providers/login_provider.dart';
import 'package:perkup_vendor_app/models/login/login_response.dart';

class PerkTypeFormScreen extends StatefulWidget {
  final PerkType? perkType;

  const PerkTypeFormScreen({super.key, this.perkType});

  @override
  // ignore: library_private_types_in_public_api
  _PerkTypeFormScreenState createState() => _PerkTypeFormScreenState();
}

class _PerkTypeFormScreenState extends State<PerkTypeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _typeName;
  late String _description;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    if (widget.perkType != null) {
      _typeName = widget.perkType!.typeName;
      _description = widget.perkType!.description;
      _isActive = widget.perkType!.isActive;
    } else {
      _typeName = '';
      _description = '';
      _isActive = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final perkTypeProvider = Provider.of<PerkTypeProvider>(context);
    final token = Provider.of<LoginProvider>(context, listen: false).token;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.perkType == null ? 'New Perk Type' : 'Edit Perk Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.perkType?.typeName,
                decoration: const InputDecoration(labelText: 'Type Name'),
                onSaved: (value) => _typeName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a type name' : null,
              ),
              TextFormField(
                initialValue: widget.perkType?.description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
              ),
              SwitchListTile(
                title: const Text('Is Active'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  LoginResponse? user =
                      await LoginResponse.loadFromPreferences();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final perkType = PerkType(
                      perkTypeID: widget.perkType?.perkTypeID ?? 0,
                      typeName: _typeName,
                      description: _description,
                      isActive: _isActive,
                      createdAt:
                          DateTime.now().toString().replaceFirst(" ", "T"),
                      updatedBy: user!.userId,
                      updatedAt:
                          DateTime.now().toString().replaceFirst(" ", "T"),
                      createdBy: user.userId,
                    );
                    if (widget.perkType == null) {
                      perkTypeProvider.createPerkType(perkType, token!);
                    } else {
                      perkTypeProvider.updatePerkType(perkType, token!);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.perkType == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
