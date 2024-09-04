import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/perk/perk.dart';
import 'package:perkup_user_app/services/perk_service.dart';

class PerkProvider with ChangeNotifier {
  final PerkService _perkService = PerkService();
  List<Perk> _perks = [];
  bool _isLoading = false;
  String? _errorMessage;

  /// Getter for the list of perks.
  List<Perk> get perks => _perks;

  /// Getter for loading state.
  bool get isLoading => _isLoading;

  /// Getter for error messages.
  String? get errorMessage => _errorMessage;

  /// Fetch perks by perk type.
  Future<void> fetchPerksByType(int perkType, String token) async {
    _setLoading(true);
    try {
      _perks = await _perkService.fetchPerksByType(perkType, token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch perks: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch all perks without filtering by type.
  Future<void> fetchPerks(String token) async {
    _setLoading(true);
    try {
      _perks = await _perkService.fetchPerks(token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch perks: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  /// Sets the loading state and notifies listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
