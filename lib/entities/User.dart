import 'dart:ffi';

class User {
  int? id;
  String firstName;
  String lastName;
  String email;
  String password;
  String userName;
  String roles;
  DateTime dateNaissance;
  String sexe;
  String? numTel;
  bool? isProfileCompleted;
  bool? isAccountBanned;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? fcmToken;
  double? balance;
  String? stripeAccountId;

  User(
      {this.id,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.password,
        required this.dateNaissance,
        required this.userName,
        required this.roles,
        required this.sexe,
        this.numTel,
        this.isProfileCompleted,
        this.isAccountBanned,
        this.isEmailVerified,
        this.isPhoneVerified,
        this.stripeAccountId,
        this.balance,
        this.fcmToken});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'fcmToken': fcmToken,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'numTel': numTel,
      'userName': userName,
      'roles': roles,
      'sexe': sexe,
      'dateNaissance': dateNaissance.toIso8601String(),
      'profileCompleted': isProfileCompleted,
      'accountBanned': isAccountBanned,
      'emailVerified': isEmailVerified,
      'phoneVerified': isPhoneVerified,
      'stripeAccountId': stripeAccountId
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] ?? 0,
        balance: json['balance'] ?? 0,
        fcmToken: json['fcmToken'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? '',
        numTel: json['numTel'] ?? '',
        userName: json['userName'] ?? '',
        roles: json['roles'] ?? '',
        sexe: json['sexe'] ?? '',
        dateNaissance: DateTime.parse(json['dateNaissance']),
        isProfileCompleted: json['profileCompleted'] ?? false,
        isAccountBanned: json['accountBanned'] ?? false,
        isEmailVerified: json['emailVerified'] ?? false,
        isPhoneVerified: json['phoneVerified'] ?? false,
        stripeAccountId: json['stripeAccountId'] ?? '');
  }

  @override
  String toString() {
    return 'User{'
        'id: $id,'
        ' firstName: $firstName'
        ', lastName: $lastName,'
        ' email: $email, '
        'password: $password,'
        ' balance: $balance, '
        'numTel: $numTel, '
        'userName: $userName, '
        'roles: $roles, '
        'dateNaissance: $dateNaissance,'
        'sexe: $sexe, '
        'isProfileCompleted: $isProfileCompleted, '
        'isAccountBanned: $isAccountBanned'
        'stripeAccountId: $stripeAccountId '
        'fcmToken: $fcmToken'
        '}';
  }
}