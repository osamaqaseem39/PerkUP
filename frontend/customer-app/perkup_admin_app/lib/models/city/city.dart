class City {
  City({
    required this.cityID,
    required this.cityName,
    required this.countryID,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  late final int cityID;
  late final String cityName;
  late final int countryID;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;

  City.fromJson(Map<String, dynamic> json) {
    cityID = json['cityID'];
    cityName = json['cityName'];
    countryID = json['countryID'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cityID'] = cityID;
    data['cityName'] = cityName;
    data['countryID'] = countryID;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
