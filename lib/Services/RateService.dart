import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/Rate.dart';
import 'SharedPrefService.dart';

class RateService {
  final String url = "http://localhost:8080/auth";
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<String> addRate(AddRateRequest addRateRequest) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.post(
        Uri.parse('$url/addRate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(addRateRequest.toJson()),
      );

      if (response.statusCode == 200) {
        print('Taux ajouté avec succès');
        print(response.body);
        return response.body;
      } else {
        throw Exception('Échec de l\'ajout du taux: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }
}