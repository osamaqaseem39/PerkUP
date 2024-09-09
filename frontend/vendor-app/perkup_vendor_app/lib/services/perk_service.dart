import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_vendor_app/models/perk/perk.dart';

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
      return jsonResponse.map((perk) => Perk.fromJson(perk)).toList();
    } else {
      throw Exception('Failed to load perks');
    }
  }

  Future<Perk> fetchPerkById(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Perks/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Perk.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load perk');
    }
  }

  Future<void> createPerk(Perk perk, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Perks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(perk.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create perk');
    }
  }

  Future<void> updatePerk(Perk perk, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Perks/${perk.perkID}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(perk.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update perk');
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
      throw Exception('Failed to delete perk');
    }
  }
}
