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
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
    required this.role,
    required this.address,
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
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;
  late final Role role;
  late final Address address;
  
  User.fromJson(Map<String, dynamic> json){
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
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    role = Role.fromJson(json['role']);
    address = Address.fromJson(json['address']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userID'] = userID;
    _data['userType'] = userType;
    _data['username'] = username;
    _data['displayName'] = displayName;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['userEmail'] = userEmail;
    _data['userContact'] = userContact;
    _data['password'] = password;
    _data['images'] = images;
    _data['roleID'] = roleID;
    _data['description'] = description;
    _data['addressID'] = addressID;
    _data['createdBy'] = createdBy;
    _data['createdAt'] = createdAt;
    _data['updatedBy'] = updatedBy;
    _data['updatedAt'] = updatedAt;
    _data['role'] = role.toJson();
    _data['address'] = address.toJson();
    return _data;
  }
}

class Role {
  Role({
    required this.roleID,
    required this.roleName,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
    required this.rolePermissions,
  });
  late final int roleID;
  late final String roleName;
  late final String description;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;
  late final List<RolePermissions> rolePermissions;
  
  Role.fromJson(Map<String, dynamic> json){
    roleID = json['roleID'];
    roleName = json['roleName'];
    description = json['description'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    rolePermissions = List.from(json['rolePermissions']).map((e)=>RolePermissions.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['roleID'] = roleID;
    _data['roleName'] = roleName;
    _data['description'] = description;
    _data['createdBy'] = createdBy;
    _data['createdAt'] = createdAt;
    _data['updatedBy'] = updatedBy;
    _data['updatedAt'] = updatedAt;
    _data['rolePermissions'] = rolePermissions.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class RolePermissions {
  RolePermissions({
    required this.rolePermissionID,
    required this.permissionID,
    required this.roleID,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });
  late final int rolePermissionID;
  late final int permissionID;
  late final int roleID;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;
  
  RolePermissions.fromJson(Map<String, dynamic> json){
    rolePermissionID = json['rolePermissionID'];
    permissionID = json['permissionID'];
    roleID = json['roleID'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['rolePermissionID'] = rolePermissionID;
    _data['permissionID'] = permissionID;
    _data['roleID'] = roleID;
    _data['createdBy'] = createdBy;
    _data['createdAt'] = createdAt;
    _data['updatedBy'] = updatedBy;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class Address {
  Address({
    required this.addressID,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });
  late final int addressID;
  late final String street;
  late final String city;
  late final String state;
  late final String postalCode;
  late final String country;
  late final int latitude;
  late final int longitude;
  late final int createdBy;
  late final String createdAt;
  late final int updatedBy;
  late final String updatedAt;
  
  Address.fromJson(Map<String, dynamic> json){
    addressID = json['addressID'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['addressID'] = addressID;
    _data['street'] = street;
    _data['city'] = city;
    _data['state'] = state;
    _data['postalCode'] = postalCode;
    _data['country'] = country;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['createdBy'] = createdBy;
    _data['createdAt'] = createdAt;
    _data['updatedBy'] = updatedBy;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}