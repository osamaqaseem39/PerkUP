class Area {
  Area({
    required this.areaID,
    required this.areaName,
    required this.cityID,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });
  late final int areaID;
  late final String areaName;
  late final int cityID;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;

  Area.fromJson(Map<String, dynamic> json) {
    areaID = json['areaID'];
    areaName = json['areaName'];
    cityID = json['cityID'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['areaID'] = areaID;
    data['areaName'] = areaName;
    data['cityID'] = cityID;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
