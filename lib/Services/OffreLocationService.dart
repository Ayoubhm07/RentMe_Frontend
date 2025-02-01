import 'dart:convert';

import 'package:khedma/Services/LocationService.dart';

import '../entities/Location.dart';
import '../entities/NotificationRequest.dart';
import '../entities/OffreLocation.dart';
import '../entities/User.dart';
import 'NotificationService.dart';
import 'SharedPrefService.dart';
import 'package:http/http.dart' as http;

import 'UserService.dart';

class OffreLocationService {
  final String url = "http://localhost:8080/od/locationoffer";
  SharedPrefService sharedPrefService = SharedPrefService();
  UserService userService = UserService();
  NotificationService notificationService = NotificationService();
  LocationService locationService = LocationService();


  Future<OffreLocation> getOfferLocationById(int id) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    try {
      final response = await http.get(
        Uri.parse('$url/get/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        print('Offre récupérée avec succès');
        print(response.body);
        Map<String, dynamic> body = json.decode(response.body);
        OffreLocation offer = OffreLocation.fromJson(body);
        return offer;
      } else {
        throw Exception(
            'Échec de la récupération de l\'offre: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<List<OffreLocation>> getOffersByLocation(int id) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    try {
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

  Future<void> acceptOffer(int id) async {
    User user = await sharedPrefService.getUser();
    OffreLocation offreLocation = await OffreLocationService().getOfferLocationById(id);
    int receiverId = offreLocation.userId;
    User receiver = await userService.findUserById(receiverId);
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    try {
      final response = await http.patch(
        Uri.parse('$url/$id/accept'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'status': 'accepted'}),
      );

      if (response.statusCode == 200) {

        if (receiver.fcmToken != null && receiver.fcmToken!.isNotEmpty) {
          NotificationRequest notificationRequest = NotificationRequest(
              title: "Offre Acceptée",
              body: "${user.userName} a accepté votre offre de location.",
              token: receiver.fcmToken ?? "",
              userId: receiverId ,
              topic: 'offre de location');
          await notificationService.sendNotificationByToken(notificationRequest);
          print('Offre créée avec succès');
        } else {
          print("No FCM token available; skipping notification send.");
        }

      } else {
        throw Exception('Échec de l\'acceptation de l\'offre: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<void> terminerOffre(int id) async {
    User user = await sharedPrefService.getUser();
    OffreLocation offre = await OffreLocationService().getOfferLocationById(id);
    int locationId = offre.locationId;
    Location location = await locationService.getLocationById(locationId);
    User receiver = await userService.findUserById(location.userId);
    int? receiverId = receiver.id;
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    try {
      final response = await http.patch(
        Uri.parse('$url/$id/done'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'status': 'done'}),
      );

      if (response.statusCode == 200) {

        if (receiver.fcmToken != null && receiver.fcmToken!.isNotEmpty) {
          NotificationRequest notificationRequest = NotificationRequest(
              title: "Offre Terminee",
              body: "Vous devez payer ${user.userName}.",
              token: receiver.fcmToken ?? "",
              userId: receiverId ?? 0,
              topic: 'offre de location');
          await notificationService.sendNotificationByToken(notificationRequest);
          print('Offre de location terminée avec succès');
        } else {
          print("No FCM token available; skipping notification send.");
        }

      } else {
        throw Exception('Échec de l\'termination de l\'offre: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<OffreLocation> rejectOffer(int id) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    try {
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
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    try {
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
    User user = await sharedPrefService.getUser();
    Location location = await locationService.getLocationById(offer.locationId);
    int receiverId = location.userId;
    User receiver = await userService.findUserById(receiverId);
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    try {
      final response = await http.post(
        Uri.parse('$url/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(offer.toJson()),
      );

      if (response.statusCode == 200) {

        if (receiver.fcmToken != null && receiver.fcmToken!.isNotEmpty) {
          NotificationRequest notificationRequest = NotificationRequest(
              title: "Nouvelle offre de location ajoutee",
              body: "Vous avez recu une offre de location de la part de ${user.userName}",
              token: receiver.fcmToken ?? "",
              userId: receiverId ,
              topic: 'offre de location'
              );
          await notificationService.sendNotificationByToken(notificationRequest);
          print('Offre créée avec succès');
          return OffreLocation.fromJson(json.decode(response.body));
        } else {
          print("No FCM token available; skipping notification send.");
          return OffreLocation.fromJson(json.decode(response.body));
        }
      } else {
        throw Exception('Échec de la création de l\'OffreLocation: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<List<OffreLocation>> getOffersByUserIdAndStatus(int userId, String status) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    try {
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
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    try {
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
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');    try {
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