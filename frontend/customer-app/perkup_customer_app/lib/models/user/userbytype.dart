class UserByType {
  final int userID;
  final String? userType;
  final String? username;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? userEmail;
  final String? userContact;
  final String? images;
  final String? description;
  final int createdBy;

  UserByType({
    required this.userID,
    required this.userType,
    required this.username,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.userEmail,
    required this.userContact,
    required this.images,
    required this.description,
    required this.createdBy,
  });

  factory UserByType.fromJson(Map<String, dynamic> json) {
    return UserByType(
      userID: json['userID'],
      userType: json['userType'],
      username: json['username'],
      displayName: json['displayName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userEmail: json['userEmail'],
      userContact: json['userContact'],
      images: json['images'],
      description: json['description'],
      createdBy: json['createdBy'],
    );
  }
}
