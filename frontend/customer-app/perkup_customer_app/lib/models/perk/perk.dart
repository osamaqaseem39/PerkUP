class Perk {
  int perkID;
  int perkType;
  String perkName;
  String description;
  double value;
  DateTime? startDate;
  DateTime? endDate;
  bool isActive;
  double? minPurchaseAmount;
  double? maxDiscountAmount;
  int createdBy;
  DateTime createdAt;
  int updatedBy;
  DateTime updatedAt;

  Perk({
    required this.perkID,
    required this.perkType,
    required this.perkName,
    required this.description,
    required this.value,
    this.startDate,
    this.endDate,
    required this.isActive,
    this.minPurchaseAmount,
    this.maxDiscountAmount,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  // Factory method to create a Perk object from JSON.
  factory Perk.fromJson(Map<String, dynamic> json) {
    return Perk(
      perkID: json['perkID'],
      perkType: json['perkType'],
      perkName: json['perkName'],
      description: json['description'],
      value: json['value'].toDouble(),
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isActive: json['isActive'],
      minPurchaseAmount: json['minPurchaseAmount']?.toDouble(),
      maxDiscountAmount: json['maxDiscountAmount']?.toDouble(),
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedBy: json['updatedBy'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert a Perk object to JSON.
  Map<String, dynamic> toJson() {
    return {
      'perkID': perkID,
      'perkType': perkType,
      'perkName': perkName,
      'description': description,
      'value': value,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'minPurchaseAmount': minPurchaseAmount,
      'maxDiscountAmount': maxDiscountAmount,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
