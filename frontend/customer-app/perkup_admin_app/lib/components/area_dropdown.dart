import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/providers/area_provider.dart';
import 'package:perkup_user_app/models/area/area.dart';

class AreaDropdown extends StatefulWidget {
  final String token;
  final String city;
  final Function(Area) onChanged;
  final Area? selectedArea;

  const AreaDropdown({
    super.key,
    required this.token,
    required this.city,
    required this.onChanged,
    this.selectedArea,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AreaDropdownState createState() => _AreaDropdownState();
}

class _AreaDropdownState extends State<AreaDropdown> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AreaProvider>(context, listen: false)
          .fetchAreas(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final areaProvider = Provider.of<AreaProvider>(context);

    if (areaProvider.isLoading) {
      return const CircularProgressIndicator();
    }

    if (areaProvider.errorMessage != null) {
      return Text('Error: ${areaProvider.errorMessage}');
    }

    return DropdownButton<Area>(
      value: widget.selectedArea,
      hint: const Text('Select Area'),
      items: areaProvider.areas.map((Area area) {
        return DropdownMenuItem<Area>(
          value: area,
          child: Text(area.areaName),
        );
      }).toList(),
      onChanged: (Area? newValue) {
        widget.onChanged(newValue!);
      },
    );
  }
}
