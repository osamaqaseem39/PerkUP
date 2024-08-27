import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_user_app/models/country/country.dart';

class CountryService {
  final String baseUrl = 'https://localhost:7295/api';

  Future<List<Country>> fetchCountries(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/countries'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((country) => Country.fromJson(country)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Future<void> createCountry(Country country, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/countries'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(country.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create country');
    }
  }

  Future<void> updateCountry(Country country, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/countries/${country.countryID}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(country.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update country');
    }
  }

  Future<void> deleteCountry(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/countries/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete country');
    }
  }
}
