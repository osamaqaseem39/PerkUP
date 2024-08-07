class User {
  User({
    required this.userID,
    required this.userType,
    required this.username,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.userEmail,
    required this.userContact,
    required this.password,
    required this.images,
    required this.roleID,
    required this.description,
    required this.addressID,
  });
  late final int userID;
  late final String userType;
  late final String username;
  late final String displayName;
  late final String firstName;
  late final String lastName;
  late final String userEmail;
  late final String userContact;
  late final String password;
  late final String images;
  late final int roleID;
  late final String description;
  late final int addressID;

  User.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    userType = json['userType'];
    username = json['username'];
    displayName = json['displayName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userEmail = json['userEmail'];
    userContact = json['userContact'];
    password = json['password'];
    images = json['images'];
    roleID = json['roleID'];
    description = json['description'];
    addressID = json['addressID'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['userType'] = userType;
    data['username'] = username;
    data['displayName'] = displayName;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userEmail'] = userEmail;
    data['userContact'] = userContact;
    data['password'] = password;
    data['images'] = images;
    data['roleID'] = roleID;
    data['description'] = description;
    data['addressID'] = addressID;
    return data;
  }
}
