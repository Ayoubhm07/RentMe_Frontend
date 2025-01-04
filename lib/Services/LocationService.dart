import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khedma/entities/Location.dart';
import '../entities/Demand.dart';
import 'SharedPrefService.dart';


class LocationService {
  final String url = "http://localhost:8080/od/location";
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<Location> saveLocation(Location location) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.post(
        Uri.parse('$url/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
            location.toJson()),
      );

      if (response.statusCode == 200) {
        print('Location enregistrée avec succès');
        print(response.body);
        return Location.fromJson(json
            .decode(response.body));
      } else {
        throw Exception(
            'Échec de l\'enregistrement de la Location: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<List<Location>> getLocationsByNotUserId(int userId) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/not-user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        return List<Location>.from(jsonResponse.map((model) => Location.fromJson(model)));
      } else {
        throw Exception('Failed to load locations not for user: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching locations not for user: $e');
    }
  }


  Future<List<Location>> getMyLocationOffers(int userId) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.get(
        Uri.parse('$url/myLocations/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        return List<Location>.from(jsonResponse.map((model) => Location.fromJson(model)));
      } else {
        throw Exception('Failed to load user locations: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching user locations: $e');
    }
  }

  Future<Location> updateLocationStatus(int id) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    try {
      final response = await http.patch(
        Uri.parse('$url/$id/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'status': 'NON'}),
      );

      if (response.statusCode == 200) {
        print('Statut de la location mis à jour avec succès');
        return Location.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de la mise à jour du statut de la location: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }


}