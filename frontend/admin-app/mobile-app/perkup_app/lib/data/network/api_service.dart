import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_app/data/models/login/login_response_model.dart';
import 'api_constants.dart';

import 'package:perkup_app/data/models/address/address_model.dart';

class ApiService {
  


  Future<LoginResponse> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

     
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}
final http.Client client = http.Client();
Future<List<Address>> fetchAddresses() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.AddressUrl}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Address.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load addresses');
    }
  }

  Future<Address> createAddress(Address address) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.AddressUrl}'),
      body: jsonEncode(address.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return Address.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create address');
    }
  }

  Future<Address> updateAddress(Address address) async {
    final response = await client.put(
      Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.AddressUrl}/${address.addressID}'),
      body: jsonEncode(address.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Address.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update address');
    }
  }

  Future<void> deleteAddress(int addressID) async {
    final response = await client.delete(
      Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.AddressUrl
          
          }/$addressID'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete address');
    }
  }

  dispose() {
    client.close();
  }
