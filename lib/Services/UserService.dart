import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khedma/entities/SavaData.dart';

import '../entities/User.dart';
import 'JWTService.dart';
import 'SharedPrefService.dart';

class UserService {
  final String apiUrl =
      'http://localhost:8080/auth'; // L'URL de votre API Gateway
  JWTService jwtService = JWTService();
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<bool> saveUser(User user) async {
    try {
      final response = await http.post(Uri.parse('$apiUrl/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(user.toJson()));
      if (response.statusCode == 200) {
        User user = User.fromJson(json.decode(response.body));
        sharedPrefService.saveUser(user);
        print('User saved successfully');
        return true;
      } else {
        throw Exception(
            'Échec de l\'enregistrement du user: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
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
        sharedPrefService.saveUserData("accessToken", accessToken);
        sharedPrefService.saveUserData("refreshToken", refreshToken);
        return true;
      } else {
        throw Exception(
            'Échec de l\'authentification: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<bool> getCurrentUserByUsername() async {
    try {
      String token = await sharedPrefService.readUserData('accessToken');
      String username = jwtService.getUsernameFromToken(token)['sub'];
      var response = await http.get(
        Uri.parse('$apiUrl/open/getAllUserByUsername/$username'),
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
      String token = await sharedPrefService.readUserData('accessToken');
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
      String token = await sharedPrefService.readUserData('accessToken');
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
      String token = await sharedPrefService.readUserData('accessToken');
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
