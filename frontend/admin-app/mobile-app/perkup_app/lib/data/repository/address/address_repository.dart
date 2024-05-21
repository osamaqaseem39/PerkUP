import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_app/data/models/address/address_model.dart';
import 'package:perkup_app/data/network/api_constants.dart';
class AddressRepository {
 

String baseUrl = ApiConstants.baseUrl;

  Future<List<Address>> getAllAddresses() async {
    final response = await http.get(Uri.parse('$baseUrl/addresses'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      List<Address> addresses = jsonResponse.map((address) => Address.fromJson(address)).toList();
      return addresses;
    } else {
      throw Exception('Failed to fetch addresses');
    }
  }

  Future<Address> getAddressById(int addressId) async {
    final response = await http.get(Uri.parse('$baseUrl/addresses/$addressId'));

    if (response.statusCode == 200) {
      return Address.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch address');
    }
  }

  Future<Address> createAddress(Address newAddress) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addresses'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newAddress.toJson()),
    );

    if (response.statusCode == 201) {
      return Address.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create address');
    }
  }

  Future<Address> updateAddress(Address updatedAddress) async {
    final response = await http.put(
      Uri.parse('$baseUrl/addresses/${updatedAddress.addressID}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedAddress.toJson()),
    );

    if (response.statusCode == 200) {
      return Address.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update address');
    }
  }

  Future<void> deleteAddress(int addressId) async {
    final response = await http.delete(Uri.parse('$baseUrl/addresses/$addressId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete address');
    }
  }
}