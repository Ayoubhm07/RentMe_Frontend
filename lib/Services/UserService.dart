import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entities/User.dart';
import 'JWTService.dart';
import 'SharedPrefService.dart';

class UserService {
  final String apiUrl =
      'http://localhost:8080/auth';
  JWTService jwtService = JWTService();
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<bool> saveUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        // User created successfully
        Map<String, dynamic> responseBody = json.decode(response.body);
        User user = User.fromJson(responseBody);
        await sharedPrefService.saveUser(user);
        await sharedPrefService.checkAllValues();
        print('User saved successfully');
        return true;
      } else if (response.statusCode == 409) {
        // Conflict: User already exists
        print('User already exists');
        return false;
      } else if (response.statusCode == 500) {
        // Internal server error
        print('Internal server error: ${response.reasonPhrase}');
        return false;
      } else {
        // Other errors
        print('Failed to save user: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }
  Future<bool> authenticate(String email, String password) async {
    try {
      final response = await http.post(Uri.parse('$apiUrl/authenticate'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': email, 'password': password}));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        String accessToken = data['accessToken'];
        String refreshToken = data['refreshToken'];
        sharedPrefService.saveStringToPrefs("accessToken", accessToken);
        sharedPrefService.saveStringToPrefs("refreshToken", refreshToken);
        return true;
      } else {
        throw Exception(
            'Échec de l\'authentification: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
  Future<String> verifyEmail(int userId, int code) async {
    String token = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.get(Uri.parse('$apiUrl/verifyEmail/$userId/$code'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
      if (response.statusCode == 200) {
        return "Code verified";
      } else if (response.statusCode == 404) {
        return 'No code found';
      } else if (response.statusCode == 400) {
        return 'Invalid code or code expired';
      } else {
        throw Exception('Failed to verify email: ${response.reasonPhrase}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<String> verifyNumber(int userId, int code) async {
    String token = await sharedPrefService.readStringFromPrefs('accessToken');

    try {
      final response = await http.get(Uri.parse('$apiUrl/verifyPhone/$userId/$code'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
      if (response.statusCode == 200) {
        return "Code verified";
      } else if (response.statusCode == 404) {
        return 'No code found';
      } else if (response.statusCode == 400) {
        return 'Invalid code or code expired';
      } else {
        throw Exception('Failed to verify email: ${response.reasonPhrase}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<String> resendVerificationCode(String email) async {
    String token = await sharedPrefService.readStringFromPrefs('accessToken');

    try {
      final response = await http.get(Uri.parse('$apiUrl/resendVerificationCode/$email'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        return 'Code sent successfully';
      } else {
        throw Exception('Failed to resend verification code: ${response.reasonPhrase}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<String> resetVerificationCode(String email) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/reset/sendVerificationCode/$email'));
      if (response.statusCode == 200) {
        return 'Code sent successfully';
      } else {
        throw Exception('Failed to resend verification code: ${response.reasonPhrase}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<String> resetVerifyEmail(String email , int code ) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/reset/verifyEmail/$email/$code'));
      if (response.statusCode == 200) {
        return 'Code verified';
      } else {
        throw Exception('Failed to verify code: ${response.reasonPhrase}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<String> resetPassword(String email , int code , String newPassword ) async {
    try {
      final response = await http.post(Uri.parse('$apiUrl/reset/resetPassword/$email/$code'),
        headers: {'Content-Type': 'application/json'},
        body: newPassword,
      );
      if (response.statusCode == 200) {
        return 'Password reset successfully';
      } else {
        throw Exception('Failed to reset password: ${response.reasonPhrase}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<String> sendSMS(String email) async {
    String token = await sharedPrefService.readStringFromPrefs('accessToken');

    try {
      final response = await http.get(Uri.parse('$apiUrl/sendPhoneVerificationCode/$email'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        return 'Code sent successfully';
      } else {
        throw Exception('Failed to send SMS: ${response.reasonPhrase}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
  Future<bool> getCurrentUserByUsername() async {
    try {
      String token = await sharedPrefService.readStringFromPrefs('accessToken');
      String username = jwtService.getUsernameFromToken(token)['sub'];
      var response = await http.get(
        Uri.parse('$apiUrl/getUserByEmail/$username'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        User user = await User.fromJson(json.decode(response.body));
        sharedPrefService.saveUser(user);
        return true;
      } else {
        throw Exception('Failed to load user: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
  Future<bool> updateUser(User user) async {
    try {
      print('Updating user...' + user.toString());
      String token = await sharedPrefService.readStringFromPrefs('accessToken');
      var response = await http.put(
        Uri.parse('$apiUrl/updateUser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode == 200) {
        print(response.body);
        sharedPrefService.saveUser(User.fromJson(json.decode(response.body)));
        print('User upadted and saved to shared preferences successfully');
        return true;
      } else {
        throw Exception('Failed to update user: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
  Future<User> getUserById(String namePerUser)async {
    try {
      String token = await sharedPrefService.readStringFromPrefs('accessToken');
      var response = await http.get(
        Uri.parse('$apiUrl/getUserById/$namePerUser'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        User user = await User.fromJson(json.decode(response.body));
        return user;
      } else {
        throw Exception('Failed to load user: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
  Future<User> findUserById(int id)async {
    try {
      String token = await sharedPrefService.readStringFromPrefs('accessToken');
      var response = await http.get(
        Uri.parse('$apiUrl/findUserById/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        print("User found");
        User user = await User.fromJson(json.decode(response.body));
        return user;
      } else {
        throw Exception('Failed to load user: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
}
