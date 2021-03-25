class User {
  final String id;
  final String email;
  final String userRole;
  User({this.id, this.email, this.userRole});
  User.fromData(Map<String, dynamic> data)
      : id = data['id'] ?? 0,
        email = data['email'] ?? '',
        userRole = data['userRole'] ?? 'User';
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userRole': userRole,
    };
  }
}