class MenuItem {
  final int menuItemID;
  final int menuID;
  final String itemName;
  final String? description;
  final String? image;
  final double price;
  final double discount;
  final bool isPercentageDiscount;
  final bool isActive;
  final String? category;
  final int createdBy;
  final DateTime createdAt;
  final int updatedBy;
  final DateTime updatedAt;

  MenuItem({
    required this.menuItemID,
    required this.menuID,
    required this.itemName,
    this.description,
    this.image,
    required this.price,
    required this.discount,
    required this.isPercentageDiscount,
    required this.isActive,
    this.category,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  // Factory constructor for creating a new MenuItem instance from a map
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      menuItemID: json['menuItemID'],
      menuID: json['menuID'],
      itemName: json['itemName'],
      description: json['description'],
      image: json['image'],
      price: json['price'].toDouble(),
      discount: json['discount'].toDouble(),
      isPercentageDiscount: json['isPercentageDiscount'],
      isActive: json['isActive'],
      category: json['category'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedBy: json['updatedBy'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert a MenuItem instance to a map
  Map<String, dynamic> toJson() {
    return {
      'menuItemID': menuItemID,
      'menuID': menuID,
      'itemName': itemName,
      'description': description,
      'image': image,
      'price': price,
      'discount': discount,
      'isPercentageDiscount': isPercentageDiscount,
      'isActive': isActive,
      'category': category,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
