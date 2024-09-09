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

  final dynamic perkID;
  final dynamic perkType;
  final String perkName;
  final String description;
  final dynamic value;
  final String startDate;
  final String endDate;
  final bool isActive;
  final dynamic minPurchaseAmount;
  final dynamic maxDiscountAmount;
  final dynamic createdBy;
  final String createdAt;
  final dynamic updatedBy;
  final String updatedAt;

  factory Perk.fromJson(Map<String, dynamic> json) {
    return Perk(
      perkID: json['perkID'] as dynamic,
      perkType: json['perkType'] as dynamic,
      perkName: json['perkName'] as String,
      description: json['description'] as String? ?? '',
      value: json['value'] as dynamic,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      isActive: json['isActive'] as bool,
      minPurchaseAmount: json['minPurchaseAmount'] as dynamic,
      maxDiscountAmount: json['maxDiscountAmount'] as dynamic,
      createdBy: json['createdBy'] as dynamic,
      createdAt: json['createdAt'] as String,
      updatedBy: json['updatedBy'] as dynamic,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'perkID': perkID,
      'perkType': perkType,
      'perkName': perkName,
      'description': description,
      'value': value,
      'startDate': startDate,
      'endDate': endDate,
      'isActive': isActive,
      'minPurchaseAmount': minPurchaseAmount,
      'maxDiscountAmount': maxDiscountAmount,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
    };
  }
}
