import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/Pub.dart';
import 'SharedPrefService.dart';

class Pubservice {
  final String url = "http://localhost:8080/pub";
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<List<Pub>> getAllPubs() async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/getActivePubs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> pubsJson = json.decode(response.body);
        List<Pub> pubs = pubsJson.map((json) => Pub.fromJson(json)).toList();
        return pubs;
      } else {
        throw Exception('Échec de la récupération des pubs: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

}