import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/perk/perk.dart';
import 'package:perkup_vendor_app/services/perk_service.dart';

class PerkProvider with ChangeNotifier {
  List<Perk> _perks = [];
  Perk? _selectedPerk;
  bool _isLoading = false;
  String? _errorMessage;

  List<Perk> get perks => _perks;
  Perk? get selectedPerk => _selectedPerk;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final PerkService _perkService = PerkService();

  Future<void> fetchPerks(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _perks = await _perkService.fetchPerks(token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Perk?> getPerkById(int id, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch the perk details using the service
      _selectedPerk = await _perkService.fetchPerkById(id, token);
      return _selectedPerk; // Return the fetched perk details
    } catch (e) {
      _errorMessage = e.toString();
      return null; // Return null on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPerk(Perk perk, String token) async {
    try {
      await _perkService.createPerk(perk, token);
      await fetchPerks(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updatePerk(Perk perk, String token) async {
    try {
      await _perkService.updatePerk(perk, token);
      await fetchPerks(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deletePerk(int id, String token) async {
    try {
      await _perkService.deletePerk(id, token);
      await fetchPerks(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
