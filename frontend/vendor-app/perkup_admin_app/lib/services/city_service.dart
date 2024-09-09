import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_admin_app/models/city/city.dart';

class CityService {
  final String baseUrl = 'https://192.168.10.18:7295/api';

  Future<List<City>> fetchCities(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cities'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((city) => City.fromJson(city)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<void> createCity(City city, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cities'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(city.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create city');
    }
  }

  Future<void> updateCity(City city, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cities/${city.cityID}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(city.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update city');
    }
  }

  Future<void> deleteCity(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cities/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete city');
    }
  }

  getCityById(int id, String token) {}
}
