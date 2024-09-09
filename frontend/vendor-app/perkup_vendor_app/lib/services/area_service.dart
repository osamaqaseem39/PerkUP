import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_vendor_app/models/area/area.dart';

class AreaService {
  final String baseUrl = 'https://192.168.10.18:7295/api';

  Future<List<Area>> fetchAreas(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/areas'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((area) => Area.fromJson(area)).toList();
    } else {
      throw Exception('Failed to load areas');
    }
  }

  Future<void> createArea(Area area, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/areas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(area.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create area');
    }
  }

  Future<void> updateArea(Area area, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/areas/${area.areaID}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(area.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update area');
    }
  }

  Future<void> deleteArea(id, token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/areas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete area');
    }
  }
}
