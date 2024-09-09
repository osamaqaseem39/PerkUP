class User {
  final int userID;
  final String? userType;
  final String? username;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? userEmail;
  final String? userContact;
  final String password;
  final String? images;
  final int? roleID;
  final String? description;
  final int? addressID;
  final int createdBy;
  final DateTime createdAt;
  final int updatedBy;
  final DateTime updatedAt;
  // Non-mapped fields

  User({
    required this.userID,
    this.userType,
    this.username,
    this.displayName,
    this.firstName,
    this.lastName,
    this.userEmail,
    this.userContact,
    required this.password,
    this.images,
    this.roleID,
    this.description,
    this.addressID,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  // Factory method to create a User object from JSON.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'],
      userType: json['userType'],
      username: json['username'],
      displayName: json['displayName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userEmail: json['userEmail'],
      userContact: json['userContact'],
      password: json['password'],
      images: json['images'],
      roleID: json['roleID'],
      description: json['description'],
      addressID: json['addressID'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedBy: json['updatedBy'],
      updatedAt: DateTime.parse(json['updatedAt']),
      // Assuming Role and Address are other models
    );
  }

  // Method to convert a User object to JSON.
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'userType': userType,
      'username': username,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'userEmail': userEmail,
      'userContact': userContact,
      'password': password,
      'images': images,
      'roleID': roleID,
      'description': description,
      'addressID': addressID,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.toIso8601String(),
      // Convert Role and Address to JSON if they are not null
    };
  }
}
