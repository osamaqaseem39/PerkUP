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

  late final int addressID;
  late final String street;
  late final String city;
  late final String state;
  late final String postalCode;
  late final String country;
  late final int latitude;
  late final int longitude;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;

  Address.fromJson(Map<String, dynamic> json) {
    addressID = json['addressID'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

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
