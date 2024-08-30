class MenuItem {
  MenuItem({
    required this.menuItemID,
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
    required this.updatedAt,
    required this.menu,
  });

  late final int menuItemID;
  late final int menuID;
  late final String itemName;
  late final String description;
  late final String image;
  late final int price;
  late final int discount;
  late final bool isPercentageDiscount;
  late final bool isActive;
  late final String category;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;
  late final String menu;

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
    menu = json['menu'];
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
    data['menu'] = menu;
    return data;
  }
}
