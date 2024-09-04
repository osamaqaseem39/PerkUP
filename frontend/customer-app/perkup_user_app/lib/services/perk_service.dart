import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_user_app/models/perk/perk.dart';

class PerkService {
  static const String baseUrl = 'https://localhost:44320/api';

  /// Fetches perks from the server based on the provided perk type.
  Future<List<Perk>> fetchPerksByType(int perkType, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Perks/GetPerksByPerkType/$perkType'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((perk) => Perk.fromJson(perk)).toList();
    } else {
      throw Exception('Failed to load perks by type');
    }
  }

  /// Fetches all perks from the server.
  Future<List<Perk>> fetchPerks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Perks'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((perk) => Perk.fromJson(perk)).toList();
    } else {
      throw Exception('Failed to load perks');
    }
  }
}
