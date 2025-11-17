class User {
  final String username;
  final String joinDate;

  User({
    required this.username,
    required this.joinDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'joinDate': joinDate,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      joinDate: json['joinDate'] ?? '',
    );
  }
}