import 'package:perkup_customer_app/models/menu/menuitem.dart';

class Menu {
  final int menuID;
  final String menuName;
  final String description;
  final String image;
  final bool isActive;
  final int createdBy;
  final DateTime createdAt;
  final int updatedBy;
  final DateTime updatedAt;
  List<MenuItem> menuItems;

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
    List<MenuItem>? menuItems,
  }) : menuItems = menuItems ?? []; // Initialize with empty list if null

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      menuID: json['menuID'],
      menuName: json['menuName'],
      description: json['description'],
      image: json['image'],
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedBy: json['updatedBy'],
      updatedAt: DateTime.parse(json['updatedAt']),
      menuItems: (json['menuItems'] as List<dynamic>?)
              ?.map((itemJson) => MenuItem.fromJson(itemJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuID': menuID,
      'menuName': menuName,
      'description': description,
      'image': image,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.toIso8601String(),
      'menuItems': menuItems.map((item) => item.toJson()).toList(),
    };
  }
}
