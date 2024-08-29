class Menu {
  Menu({
    required this.menuID,
    required this.menuName,
    required this.description,
    required this.image,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
    required this.menuItems,
  });
  late final int menuID;
  late final String menuName;
  late final String description;
  late final String image;
  late final bool isActive;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;
  late final List<MenuItems> menuItems;

  Menu.fromJson(Map<String, dynamic> json) {
    menuID = json['menuID'];
    menuName = json['menuName'];
    description = json['description'];
    image = json['image'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    menuItems =
        List.from(json['menuItems']).map((e) => MenuItems.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['menuID'] = menuID;
    data['menuName'] = menuName;
    data['description'] = description;
    data['image'] = image;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    data['menuItems'] = menuItems.map((e) => e.toJson()).toList();
    return data;
  }
}

class MenuItems {
  MenuItems({
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

  MenuItems.fromJson(Map<String, dynamic> json) {
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
