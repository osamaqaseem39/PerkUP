import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perkup_admin_app/models/login/login_response.dart';
import 'package:perkup_admin_app/models/perk/perk.dart';
import 'package:perkup_admin_app/providers/perk_provider.dart';
import 'package:perkup_admin_app/providers/perktype_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';

class PerkFormScreen extends StatefulWidget {
  final Perk? perk;

  const PerkFormScreen({super.key, this.perk});

  @override
  // ignore: library_private_types_in_public_api
  _PerkFormScreenState createState() => _PerkFormScreenState();
}

class _PerkFormScreenState extends State<PerkFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late dynamic _perkType;
  late String _perkName;
  late String _description;
  late dynamic _value;
  late DateTime _startDate;
  late DateTime _endDate;
  late bool _isActive;
  late dynamic _minPurchaseAmount;
  late dynamic _maxDiscountAmount;

  @override
  void initState() {
    super.initState();
    if (widget.perk != null) {
      _perkType = widget.perk!.perkType;
      _perkName = widget.perk!.perkName;
      _description = widget.perk!.description;
      _value = widget.perk!.value;
      _startDate = DateTime.parse(widget.perk!.startDate);
      _endDate = DateTime.parse(widget.perk!.endDate);
      _isActive = widget.perk!.isActive;
      _minPurchaseAmount = widget.perk!.minPurchaseAmount;
      _maxDiscountAmount = widget.perk!.maxDiscountAmount;
    } else {
      _perkType = null;
      _perkName = '';
      _description = '';
      _value = 0;
      _startDate = DateTime.now();
      _endDate = DateTime.now();
      _isActive = true;
      _minPurchaseAmount = 0;
      _maxDiscountAmount = 0;
    }
    _loadPerkTypes();
  }

  Future<void> _loadPerkTypes() async {
    final token = Provider.of<LoginProvider>(context, listen: false).token!;
    await Provider.of<PerkTypeProvider>(context, listen: false)
        .fetchPerkTypes(token);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final perkProvider = Provider.of<PerkProvider>(context);
    final perkTypeProvider = Provider.of<PerkTypeProvider>(context);
    final token = Provider.of<LoginProvider>(context, listen: false).token;

    if (perkTypeProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.perk == null ? 'New Perk' : 'Edit Perk'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (perkTypeProvider.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.perk == null ? 'New Perk' : 'Edit Perk'),
        ),
        body: Center(
          child: Text('Error: ${perkTypeProvider.errorMessage}'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.perk == null ? 'New Perk' : 'Edit Perk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<dynamic>(
                  value: _perkType,
                  onChanged: (value) {
                    setState(() {
                      _perkType = value!;
                    });
                  },
                  items: perkTypeProvider.perkTypes.map((perkType) {
                    return DropdownMenuItem<dynamic>(
                      value: perkType.perkTypeID,
                      child: Text(perkType.typeName),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Perk Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  initialValue: widget.perk?.perkName,
                  decoration: const InputDecoration(labelText: 'Perk Name'),
                  onSaved: (value) => _perkName = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a perk name' : null,
                ),
                TextFormField(
                  initialValue: widget.perk?.description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _description = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a description' : null,
                ),
                TextFormField(
                  initialValue: widget.perk?.value.toString(),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _value = value!,
                  validator: (value) => value!.isEmpty ? 'Enter a value' : null,
                ),
                InkWell(
                  onTap: () => _selectDate(context, true),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(_formatDate(_startDate)),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => _selectDate(context, false),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(_formatDate(_endDate)),
                  ),
                ),
                TextFormField(
                  initialValue: widget.perk?.minPurchaseAmount.toString(),
                  decoration:
                      const InputDecoration(labelText: 'Min Purchase Amount'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _minPurchaseAmount = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a min purchase amount' : null,
                ),
                TextFormField(
                  initialValue: widget.perk?.maxDiscountAmount.toString(),
                  decoration:
                      const InputDecoration(labelText: 'Max Discount Amount'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _maxDiscountAmount = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a max discount amount' : null,
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
                      final perk = Perk(
                        perkID: widget.perk?.perkID,
                        perkType: _perkType!,
                        perkName: _perkName,
                        description: _description,
                        value: _value,
                        startDate: _formatDate(_startDate),
                        endDate: _formatDate(_endDate),
                        minPurchaseAmount: _minPurchaseAmount,
                        maxDiscountAmount: _maxDiscountAmount,
                        isActive: _isActive,
                        createdBy: user!.userId,
                        createdAt: _formatDate(DateTime.now()),
                        updatedBy: user.userId,
                        updatedAt: _formatDate(DateTime.now()),
                      );
                      if (widget.perk == null) {
                        perkProvider.createPerk(perk, token!);
                      } else {
                        perkProvider.updatePerk(perk, token!);
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(widget.perk == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
