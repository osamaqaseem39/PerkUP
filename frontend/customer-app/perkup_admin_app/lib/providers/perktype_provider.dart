import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/perk/perktype.dart';
import 'package:perkup_user_app/services/perktype_service.dart';

class PerkTypeProvider with ChangeNotifier {
  List<PerkType> _perkTypes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PerkType> get perkTypes => _perkTypes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final PerkTypeService _perkTypeService = PerkTypeService();

  Future<void> fetchPerkTypes(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _perkTypes = await _perkTypeService.fetchPerkTypes(token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createPerkType(PerkType perkType, String token) async {
    try {
      await _perkTypeService.createPerkType(perkType, token);
      await fetchPerkTypes(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updatePerkType(PerkType perkType, String token) async {
    try {
      await _perkTypeService.updatePerkType(perkType, token);
      await fetchPerkTypes(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deletePerkType(int id, String token) async {
    try {
      await _perkTypeService.deletePerkType(id, token);
      await fetchPerkTypes(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
