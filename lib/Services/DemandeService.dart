import 'dart:convert';
import 'package:dynamic_multi_step_form/dynamic_multi_step_form.dart';
import 'package:http/http.dart' as http;
import '../entities/Demand.dart';
import 'SharedPrefService.dart';


class DemandeService {
  final String url = "http://localhost:8080/od/demand";
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<Demand> saveDemande(Demand demande) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.post(
        Uri.parse('$url/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
            demande.toJson()),
      );

      if (response.statusCode == 200) {
        print('Demande enregistrée avec succès');
        print(response.body);
        return Demand.fromJson(json
            .decode(response.body));
      } else {
        throw Exception(
            'Échec de l\'enregistrement de la demande: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<Demand> getDemandById(int id) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/get/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Demande récupérée avec succès');
        return Demand.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de la récupération de la demande: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<List<Demand>> getDemandsByUserId(int id) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/getByUserId/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Demandes récupérées avec succès');
        print(response.body);
        List<dynamic> body = json.decode(response.body);
        List<Demand> demands = body
            .map(
                (dynamic item) => Demand.fromJson(item))
            .toList();
        return demands;
      } else {
        throw Exception(
            'Échec de la récupération des demandes: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<List<Demand>> getAllDemands() async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/getAll'),
        headers:{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Demandes récupérées avec succès');
        print(response.body);
        List<dynamic> body = json.decode(response.body);
        List<Demand> demands = body
            .map(
                (dynamic item) => Demand.fromJson(item))
            .toList();
        return demands;
      } else {
        throw Exception(
            'Échec de la récupération des demandes: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<String> deleteDemande(int demandId) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.delete(
        Uri.parse('$url/delete/$demandId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Demande supprimée avec succès');
        return "Demande supprimée avec succès!";
      } else {
        throw Exception('Échec de la suppression de la demande: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

}