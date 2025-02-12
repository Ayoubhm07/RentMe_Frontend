import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/Travail.dart';
import 'SharedPrefService.dart';

class TravailService {
  final String baseUrl =
      'http://localhost:8080/auth';
  SharedPrefService sharedPrefService = SharedPrefService();
  Future<Travail> addTravail(Travail travail) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addTravail'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(travail.toJson()),
      );

      if (response.statusCode == 200) {
        print('Travail ajouté avec succès');
        Map<String, dynamic> body = json.decode(response.body);
        return Travail.fromJson(body);
      } else {
        throw Exception('Échec de l\'ajout du travail: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<Travail> updateTravailImages(int travailId, String image) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/updateImages/$travailId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(image),
      );

      if (response.statusCode == 200) {
        print('Images de travail mises à jour avec succès');
        return Travail.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de la mise à jour des images : ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }
  Future<List<Travail>> getTravauxWithImageUrl(int userId) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getTravauxWithImageUrl/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Travaux récupérés avec succès');
        List<dynamic> body = json.decode(response.body);
        List<Travail> travaux = body.map((item) => Travail.fromJson(item)).toList();
        return travaux;
      } else {
        throw Exception('Échec de la récupération des travaux: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }
  Future<List<Travail>> getTravaux(int userId) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getTravaux/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Travaux récupérés avec succès');
        List<dynamic> body = json.decode(response.body);
        List<Travail> travaux = body.map((item) => Travail.fromJson(item)).toList();
        return travaux;
      } else {
        throw Exception('Échec de la récupération des travaux: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }
  Future<void> deleteTravail(int id) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deleteTravail/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Travail supprimé avec succès');
      } else {
        throw Exception('Échec de la suppression du travail: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }
  Future<Travail> updateTravail(Travail travail) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/updateTravail'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(travail.toJson()),
      );

      if (response.statusCode == 200) {
        print('Travail mis à jour avec succès');
        Map<String, dynamic> body = json.decode(response.body);
        return Travail.fromJson(body);
      } else {
        throw Exception('Échec de la mise à jour du travail: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

}