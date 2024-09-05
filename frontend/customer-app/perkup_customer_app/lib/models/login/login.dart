class Login {
  Login({
    required this.username,
    required this.password,
    required this.passwordHash,
  });

  late final String username;
  late final String password;
  late final String passwordHash;

  Login.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    passwordHash = json['passwordHash'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['passwordHash'] = passwordHash;
    return data;
  }
}
