import 'dart:convert';

import '../entities/Offre.dart';
import 'SharedPrefService.dart';
import 'package:http/http.dart' as http;

class OffreService {
  final String url = "http://localhost:8080/od/offer";
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<List<Offre>> getOffersByDemand(int id) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/getByDemandId/$id'),
        headers:{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Offres récupérées avec succès');
        print(response.body);
        List<dynamic> body = json.decode(response.body);
        List<Offre> offers = body
            .map(
                (dynamic item) => Offre.fromJson(item))
            .toList();
        return offers;
      } else {
        throw Exception(
            'Échec de la récupération des offres: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }


  Future<List<Offre>> getOffersByUser(int userId) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/getByUserId/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Offre> offers = body.map((dynamic item) => Offre.fromJson(item)).toList();
        print('Successfully retrieved offers for user ID: $userId');
        return offers;
      } else {
        throw Exception('Failed to retrieve offers for user: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Connection error: $e');
      throw Exception('Connection error: $e');
    }
  }

  Future<List<Offre>> getOffersByLocation(int id) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/getByLocationId/$id'),
        headers:{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Offres récupérées avec succès');
        print(response.body);
        List<dynamic> body = json.decode(response.body);
        List<Offre> offers = body
            .map(
                (dynamic item) => Offre.fromJson(item))
            .toList();
        return offers;
      } else {
        throw Exception(
            'Échec de la récupération des offres: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<Offre> createOffer(Offre offer) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.post(
        Uri.parse('$url/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(offer.toJson()),
      );

      if (response.statusCode == 200) {
        print('Offre créée avec succès');
        return Offre.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de la création de l\'offre: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<List<Offre>> getOffersByUserIdAndStatus(int userId, String status) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/getByUserIdandStatus/$userId/$status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Offre> offers = body.map((dynamic item) => Offre.fromJson(item)).toList();
        print('Successfully retrieved offers for user ID: $userId with status: $status');
        return offers;
      } else {
        throw Exception('Failed to retrieve offers: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Connection error: $e');
      throw Exception('Connection error: $e');
    }
  }

  Future<String> deleteOffer(int offerId) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.delete(
        Uri.parse('$url/deleteOffer/$offerId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Offre supprimée avec succès');
        return 'Offre supprimée avec succès';
      } else {
        throw Exception(
            'Échec de la suppression de l\'offre: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<void> acceptOffer(int offerId) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.patch(
        Uri.parse('$url/$offerId/accept'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Offer accepted successfully');
      } else {
        throw Exception('Failed to accept offer: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Connection error when accepting offer: $e');
      throw Exception('Connection error when accepting offer: $e');
    }
  }
}