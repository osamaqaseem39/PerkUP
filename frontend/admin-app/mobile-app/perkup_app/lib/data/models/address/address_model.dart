class Address {
  Address({
    required this.addressID,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  final int addressID;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final int latitude;
  final int longitude;
  final int createdBy;
  final String createdAt;
  final int updatedBy;
  final String updatedAt;

  Address.fromJson(Map<String, dynamic> json)
      : addressID = json['addressID'],
        street = json['street'],
        city = json['city'],
        state = json['state'],
        postalCode = json['postalCode'],
        country = json['country'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        createdBy = json['createdBy'],
        createdAt = json['createdAt'],
        updatedBy = json['updatedBy'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['addressID'] = addressID;
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }
}