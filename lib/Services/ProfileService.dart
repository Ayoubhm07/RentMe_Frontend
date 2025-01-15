import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khedma/Services/SharedPrefService.dart';
import '../entities/ProfileDetails.dart';

class ProfileService {
  final String apiUrl = 'http://localhost:8080/profileDetail';
  SharedPrefService sharedPrefService = SharedPrefService();
  Future<bool> saveProfileDetails(ProfileDetails profileDetails) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    final response = await http.post(
      Uri.parse('$apiUrl/create'),
      headers: {
        'Content-Type' : 'application/json',
        'Authorization' : 'Bearer $accessToken',
      },
      body: jsonEncode(profileDetails.toJson()),
    );

    if (response.statusCode == 200) {
      sharedPrefService.saveProfileDetails(ProfileDetails.fromJson(json.decode(response.body)));
      return true;  // Convertir la réponse JSON en objet ProfileDetails
    } else {
      throw Exception('Échec de l\'enregistrement du profil: ${response.reasonPhrase}');
    }
  }
  Future<ProfileDetails> getProfileDetails(int id) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    final response = await http.get(
      Uri.parse('$apiUrl/getProfileDateilsById/$id'), // Point de terminaison pour récupérer les détails du profil
      headers: {
        'Content-Type' : 'application/json',
        'Authorization' : 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return ProfileDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la récupération du profil: ${response.reasonPhrase}');
    }
  }

  Future<String?> getProfileImage(int i) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    final response = await http.get(
      Uri.parse('$apiUrl/getProfileDateilsById/$i'), // Point de terminaison pour récupérer les détails du profil
      headers: {
        'Content-Type' : 'application/json',
        'Authorization' : 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return ProfileDetails.fromJson(json.decode(response.body)).profilePicture;
    } else {
      throw Exception('Échec de la récupération du profil: ${response.reasonPhrase}');
    }
  }
}
