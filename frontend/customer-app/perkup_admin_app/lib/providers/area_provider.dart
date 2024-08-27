import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/area/area.dart';
import 'package:perkup_user_app/services/area_service.dart';

class AreaProvider extends ChangeNotifier {
  List<Area> _areas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Area> get areas => _areas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final AreaService _areaService = AreaService();

  get countries => null;

  Future<void> fetchAreas(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _areas = await _areaService.fetchAreas(token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createArea(Area area, String token) async {
    try {
      await _areaService.createArea(area, token);
      await fetchAreas(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateArea(Area area, String token) async {
    try {
      await _areaService.updateArea(area, token);
      await fetchAreas(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteArea(int id, String token) async {
    try {
      await _areaService.deleteArea(id, token);
      await fetchAreas(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
