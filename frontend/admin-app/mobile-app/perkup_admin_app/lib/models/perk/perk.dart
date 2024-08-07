class Perk {
  Perk({
    required this.perkID,
    required this.perkType,
    required this.perkName,
    required this.description,
    required this.value,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.minPurchaseAmount,
    required this.maxDiscountAmount,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });
  late final int perkID;
  late final int perkType;
  late final String perkName;
  late final String description;
  late final int value;
  late final String startDate;
  late final String endDate;
  late final bool isActive;
  late final int minPurchaseAmount;
  late final int maxDiscountAmount;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;

  Perk.fromJson(Map<String, dynamic> json) {
    perkID = json['perkID'];
    perkType = json['perkType'];
    perkName = json['perkName'];
    description = json['description'];
    value = json['value'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    isActive = json['isActive'];
    minPurchaseAmount = json['minPurchaseAmount'];
    maxDiscountAmount = json['maxDiscountAmount'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['perkID'] = perkID;
    data['perkType'] = perkType;
    data['perkName'] = perkName;
    data['description'] = description;
    data['value'] = value;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['isActive'] = isActive;
    data['minPurchaseAmount'] = minPurchaseAmount;
    data['maxDiscountAmount'] = maxDiscountAmount;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
