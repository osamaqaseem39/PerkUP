class Menu {
  Menu({
    required this.menuID,
    required this.menuName,
    this.description,
    this.image,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  late final int menuID;
  late final String menuName;
  String? description;
  String? image;
  late final bool isActive;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;

  // Create a Menu from JSON
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
  }

  // Convert a Menu to JSON
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
    return data;
  }
}
