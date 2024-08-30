import 'package:perkup_user_app/models/menu/menuitem.dart';

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
  late final List<MenuItem> menuItems;

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
        List.from(json['menuItems']).map((e) => MenuItem.fromJson(e)).toList();
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
