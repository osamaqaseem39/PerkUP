import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_user_app/models/address/address.dart';

class AddressService {
  static const String baseUrl = 'https://localhost:44320/api';

  Future<List<Address>> fetchAddresses(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/addresses'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((address) => Address.fromJson(address)).toList();
    } else {
      throw Exception('Failed to load addresses');
    }
  }

  Future<Address> fetchAddressById(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/addresses/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Address.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load address');
    }
  }

  Future<void> createAddress(Address address, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addresses'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(address.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create address');
    }
  }

  Future<void> updateAddress(Address address, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/addresses/${address.addressID}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(address.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update address');
    }
  }

  Future<void> deleteAddress(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/addresses/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete address');
    }
  }
}
