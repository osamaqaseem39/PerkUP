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

  final int perkID;
  final int perkType;
  final String perkName;
  final String description;
  final int value;
  final String startDate;
  final String endDate;
  final bool isActive;
  final int minPurchaseAmount;
  final int maxDiscountAmount;
  final int createdBy;
  final String createdAt;
  final int updatedBy;
  final String updatedAt;

  factory Perk.fromJson(Map<String, dynamic> json) {
    return Perk(
      perkID: json['perkID'] as int,
      perkType: json['perkType'] as int,
      perkName: json['perkName'] as String,
      description: json['description'] as String? ??
          '', // Default to empty string if null
      value: json['value'] as int,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      isActive: json['isActive'] as bool,
      minPurchaseAmount: json['minPurchaseAmount'] as int,
      maxDiscountAmount: json['maxDiscountAmount'] as int,
      createdBy: json['createdBy'] as int,
      createdAt: json['createdAt'] as String,
      updatedBy: json['updatedBy'] as int,
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
