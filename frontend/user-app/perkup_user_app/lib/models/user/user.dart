class User {
  User({
    required this.userID,
    required this.username,
    required this.password,
    this.userType,
    this.displayName,
    this.firstName,
    this.lastName,
    this.userEmail,
    this.userContact,
    this.images,
    this.roleID,
    this.description,
    this.addressID,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  late final int userID;
  late final String username;
  late final String password;
  String? userType;
  String? displayName;
  String? firstName;
  String? lastName;
  String? userEmail;
  String? userContact;
  String? images;
  int? roleID;
  String? description;
  int? addressID;
  late final int createdBy;
  late final DateTime createdAt;
  late final int updatedBy;
  late final DateTime updatedAt;

  // Create a User from JSON
  User.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    username = json['username'];
    password = json['password'];
    userType = json['userType'];
    displayName = json['displayName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userEmail = json['userEmail'];
    userContact = json['userContact'];
    images = json['images'];
    roleID = json['roleID'];
    description = json['description'];
    addressID = json['addressID'];
    createdBy = json['createdBy'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedBy = json['updatedBy'];
    updatedAt = DateTime.parse(json['updatedAt']);
  }

  // Convert a User to JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['username'] = username;
    data['password'] = password;
    data['userType'] = userType;
    data['displayName'] = displayName;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userEmail'] = userEmail;
    data['userContact'] = userContact;
    data['images'] = images;
    data['roleID'] = roleID;
    data['description'] = description;
    data['addressID'] = addressID;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt.toIso8601String();
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt.toIso8601String();
    return data;
  }
}
