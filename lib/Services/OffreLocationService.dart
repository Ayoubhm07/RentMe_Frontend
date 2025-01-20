import 'dart:convert';

import '../entities/OffreLocation.dart';
import 'SharedPrefService.dart';
import 'package:http/http.dart' as http;

class OffreLocationService {
  final String url = "http://localhost:8080/od/locationoffer";
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<List<OffreLocation>> getOffersByLocation(int id) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/getbylocation/$id'),
        headers:{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('OffreLocations récupérées avec succès');
        print(response.body);
        List<dynamic> body = json.decode(response.body);
        List<OffreLocation> offers = body
            .map(
                (dynamic item) => OffreLocation.fromJson(item))
            .toList();
        return offers;
      } else {
        throw Exception(
            'Échec de la récupération des OffreLocations: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<OffreLocation> acceptOffer(int id) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.patch(
        Uri.parse('$url/$id/accept'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'status': 'accepted'}),
      );

      if (response.statusCode == 200) {
        print('Offre acceptée avec succès');
        return OffreLocation.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de l\'acceptation de l\'offre: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<OffreLocation> terminerOffre(int id) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.patch(
        Uri.parse('$url/$id/done'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'status': 'done'}),
      );

      if (response.statusCode == 200) {
        print('Offre terminée avec succès');
        return OffreLocation.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de l\'termination de l\'offre: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<OffreLocation> rejectOffer(int id) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.patch(
        Uri.parse('$url/$id/reject'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'status': 'rejected'}),
      );

      if (response.statusCode == 200) {
        print('Offre rejetée avec succès');
        return OffreLocation.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de l\'rejet de l\'offre: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }


  Future<List<OffreLocation>> getOffersByUser(int userId) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/getbyuser/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<OffreLocation> offers = body.map((dynamic item) => OffreLocation.fromJson(item)).toList();
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



  Future<OffreLocation> createOffer(OffreLocation offer) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
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
        print('OffreLocation créée avec succès');
        return OffreLocation.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de la création de l\'OffreLocation: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<List<OffreLocation>> getOffersByUserIdAndStatus(int userId, String status) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
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
        List<OffreLocation> offers = body.map((dynamic item) => OffreLocation.fromJson(item)).toList();
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


  Future<List<OffreLocation>> getOffersByLocationIdAndStatus(int locationId, String status) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/getByLocationIdandStatus/$locationId/$status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<OffreLocation> offers = body.map((dynamic item) => OffreLocation.fromJson(item)).toList();
        print('Successfully retrieved offers for location ID: $locationId with status: $status');
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
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    try {
      final response = await http.delete(
        Uri.parse('$url/deleteOffer/$offerId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        print('OffreLocation supprimée avec succès');
        return 'OffreLocation supprimée avec succès';
      } else {
        throw Exception(
            'Échec de la suppression de l\'OffreLocation: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }
}