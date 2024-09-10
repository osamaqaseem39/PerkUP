class Address {
  final dynamic addressID;
  final String name;
  final String street;
  final String area;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final dynamic cityID;
  final dynamic countryID;
  final dynamic areaID;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic createdBy;
  final String createdAt;
  final dynamic updatedBy;
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
