class MenuItem {
  MenuItem(
      {required this.menuItemID,
      required this.menuID,
      required this.itemName,
      required this.description,
      required this.image,
      required this.price,
      required this.discount,
      required this.isPercentageDiscount,
      required this.isActive,
      required this.category,
      required this.createdBy,
      required this.createdAt,
      required this.updatedBy,
      required this.updatedAt});

  late final dynamic menuItemID;
  late final dynamic menuID;
  late final String itemName;
  late final String description;
  late final String image;
  late final dynamic price;
  late final dynamic discount;
  late final bool isPercentageDiscount;
  late final bool isActive;
  late final String category;
  late final dynamic createdBy;
  late final String createdAt;
  late final dynamic updatedBy;
  late final String updatedAt;

  MenuItem.fromJson(Map<String, dynamic> json) {
    menuItemID = json['menuItemID'];
    menuID = json['menuID'];
    itemName = json['itemName'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    discount = json['discount'];
    isPercentageDiscount = json['isPercentageDiscount'];
    isActive = json['isActive'];
    category = json['category'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['menuItemID'] = menuItemID;
    data['menuID'] = menuID;
    data['itemName'] = itemName;
    data['description'] = description;
    data['image'] = image;
    data['price'] = price;
    data['discount'] = discount;
    data['isPercentageDiscount'] = isPercentageDiscount;
    data['isActive'] = isActive;
    data['category'] = category;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
