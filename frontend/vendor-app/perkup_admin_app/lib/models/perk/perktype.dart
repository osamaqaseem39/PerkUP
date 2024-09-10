class PerkType {
  PerkType({
    required this.perkTypeID,
    required this.typeName,
    required this.description,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });
  late final dynamic perkTypeID;
  late final String typeName;
  late final String description;
  late final bool isActive;
  late final dynamic createdBy;
  late final String createdAt;
  late final dynamic updatedBy;
  late final String updatedAt;

  PerkType.fromJson(Map<String, dynamic> json) {
    perkTypeID = json['perkTypeID'];
    typeName = json['typeName'];
    description = json['description'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['perkTypeID'] = perkTypeID;
    data['typeName'] = typeName;
    data['description'] = description;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
