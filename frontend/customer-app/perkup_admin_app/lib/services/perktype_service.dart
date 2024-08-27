import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_user_app/models/perk/perktype.dart';

class PerkTypeService {
  static const String baseUrl = 'https://localhost:7295/api';

  Future<List<PerkType>> fetchPerkTypes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/PerkTypes'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((perkType) => PerkType.fromJson(perkType))
          .toList();
    } else {
      throw Exception('Failed to load perk types');
    }
  }

  Future<void> createPerkType(PerkType perkType, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/PerkTypes'),
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

  Future<void> updatePerkType(PerkType perkType, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/PerkTypes/${perkType.perkTypeID}'),
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

  Future<void> deletePerkType(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/PerkTypes/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete perk type');
    }
  }
}
