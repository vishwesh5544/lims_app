class User {
  final int? id;
  final String? username;
  final String? password;
  final int? role;

  User(this.id, this.username, this.password, this.role);

  static User fromMap(Map<String, dynamic> map) {
    return User(map['id'], map['username'], map['password'], map['role']);
  }
}
