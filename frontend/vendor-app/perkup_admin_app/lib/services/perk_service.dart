import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_admin_app/models/perk/perk.dart';

class PerkService {
  static const String baseUrl = 'https://192.168.10.18:7295/api';

  Future<List<Perk>> fetchPerks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Perks'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((perkType) => Perk.fromJson(perkType)).toList();
    } else {
      throw Exception('Failed to load perk types');
    }
  }

  Future<void> createPerk(Perk perkType, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Perks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(perkType.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create perk type');
    }
  }

  Future<void> updatePerk(Perk perkType, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Perks/${perkType.perkID}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(perkType.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update perk type');
    }
  }

  Future<void> deletePerk(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/Perks/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete perk type');
    }
  }
}
