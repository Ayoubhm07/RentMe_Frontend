import 'dart:convert';

import 'package:khedma/entities/ProfileDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/User.dart';

class SharedPrefService {
// Example to store data
  Future<void> saveStringToPrefs(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

// Example to read data
  Future<String> readStringFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key) ?? '';
    return value;
  }

// clear field
  Future<void> clearStringFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

// clear all
  Future<void> clearAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All data removed');
  }

// check values of all keys
  Future<void> checkAllValues() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
      final value = prefs.get(key).toString() ?? '';
      print('Read $key: $value');
    }
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }

  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = await prefs.getString('user');
    if (userJson == null) {
      return User(
          firstName: '',
          lastName: '',
          email: '',
          password: '',
          dateNaissance: DateTime.now(),
          userName: '',
          roles: '',
          sexe: '');
    }
    Map<String, dynamic> userMap = jsonDecode(userJson!);
    return User.fromJson(userMap);
  }

  Future<void> saveProfileDetails(ProfileDetails profileDetails) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(profileDetails.toJson());
    await prefs.setString('profileDetails', userJson);
  }

  Future<ProfileDetails> getProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('profileDetails');
    Map<String, dynamic> userMap = jsonDecode(userJson!);
    return ProfileDetails.fromJson(userMap);
  }
}