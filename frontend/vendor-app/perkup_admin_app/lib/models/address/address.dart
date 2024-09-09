class Address {
  final int addressID;
  final String name;
  final String street;
  final String area;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final int? cityID;
  final int? countryID;
  final int? areaID;
  final double? latitude;
  final double? longitude;
  final int? createdBy;
  final String createdAt;
  final int? updatedBy;
  final String updatedAt;

  Address({
    required this.addressID,
    required this.name,
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.countryID,
    required this.cityID,
    required this.areaID,
    this.latitude,
    this.longitude,
    this.createdBy,
    required this.createdAt,
    this.updatedBy,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressID: json['addressID'],
      name: json['name'] ?? "",
      street: json['street'] ?? "",
      area: json['area'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      postalCode: json['postalCode'] ?? "",
      country: json['country'] ?? "",
      countryID: json['countryID'] ?? "",
      areaID: json['cityID'] ?? "",
      cityID: json['areaID'] ?? "",
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'] ?? "",
      updatedBy: json['updatedBy'],
      updatedAt: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressID': addressID,
      'name': name,
      'street': street,
      'area': area,
      'city': city,
      'cityID': cityID,
      'countryID': countryID,
      'areaID': areaID,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
    };
  }
}
