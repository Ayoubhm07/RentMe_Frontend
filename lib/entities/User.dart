class User {
  int? id;
  String firstName;
  String lastName;
  String email;
  String password;
  String numTel;
  String userName;
  String roles;
  DateTime dateNaissance;
  bool isProfileCompleted;
  bool isAccountBanned;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.numTel,
    required this.userName,
    required this.roles,
    required this.dateNaissance,
    required this.isProfileCompleted,
    required this.isAccountBanned,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'numTel': numTel,
      'userName': userName,
      'roles': roles,
      'dateNaissance': dateNaissance.toIso8601String(),
      'profileCompleted': isProfileCompleted,
      'AccountBanned': isAccountBanned,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      numTel: json['numTel'] ?? '',
      userName: json['userName'] ?? '',
      roles: json['roles'] ?? '',
      dateNaissance: DateTime.parse(json['dateNaissance']),
      isProfileCompleted: json['profileCompleted'] ?? false,
      isAccountBanned: json['isAccountBanned'] ?? false,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, email: $email, password: $password, numTel: $numTel, userName: $userName, roles: $roles, dateNaissance: $dateNaissance, isProfileCompleted: $isProfileCompleted, isAccountBanned: $isAccountBanned}';
  }
}
