class MenuItem {
  MenuItem({
    required this.menuItemID,
    required this.menuID,
    required this.itemName,
    this.description,
    this.price,
    this.image,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  late final int menuItemID;
  late final int menuID;
  late final String itemName;
  String? description;
  double? price;
  String? image;
  late final bool isActive;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;

  // Create a MenuItem from JSON
  MenuItem.fromJson(Map<String, dynamic> json) {
    menuItemID = json['menuItemID'];
    menuID = json['menuID'];
    itemName = json['itemName'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  // Convert a MenuItem to JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['menuItemID'] = menuItemID;
    data['menuID'] = menuID;
    data['itemName'] = itemName;
    data['description'] = description;
    data['price'] = price;
    data['image'] = image;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
