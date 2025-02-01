import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/NotificationMesage.dart';
import '../entities/NotificationRequest.dart';
import 'SharedPrefService.dart'; // Make sure the path is correct

class NotificationService {
  final String baseUrl = 'http://localhost:8080/notification';
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<String> saveDeviceToken(int userId, String fcmToken) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    var url = Uri.parse('$baseUrl/save-device/$userId');
    try {
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: fcmToken,
      );

      if (response.statusCode == 200) {
        return "Device token saved successfully";

      } else {
        throw Exception("Failed to save device token: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception('Error saving device token: $e');
    }
  }

  Future<String> deleteNotification(int id) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    var url = Uri.parse('$baseUrl/delete/$id');
    try {
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return "Notification deleted successfully";
      } else {
        throw Exception("Failed to delete notification: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception('Error deleting notification: $e');
    }
  }

  Future<String> deleteAllNotificationsByUserId(int userId) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    var url = Uri.parse('$baseUrl/deleteAll/$userId');
    try {
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return "All notifications deleted successfully";
      } else {
        throw Exception("Failed to delete all notifications: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception('Error deleting all notifications: $e');
    }
  }

  Future<int> getUnreadCount(int userId) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    var url = Uri.parse('$baseUrl/getUnreadCount/$userId');
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception(
            "Failed to fetch unread count: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception('Error fetching unread count: $e');
    }
  }

  Future<NotificationResponse> sendNotificationByToken(NotificationRequest request) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    var url = Uri.parse('$baseUrl/sendByToken');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return NotificationResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to send notification: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error sending notification: $e');
    }
  }

  Future<List<NotificationMessage>> getNotificationsByUserId(int userId) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    var url = Uri.parse('$baseUrl/getByUserId/$userId');
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => NotificationMessage.fromJson(data)).toList();
      } else {
        throw Exception('Failed to fetch notifications: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }


  Future<String> updateNotificationState(int notificationId, String state) async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    var url = Uri.parse('$baseUrl/updateState/$notificationId/$state');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return "Notification state updated successfully";
      } else {
        throw Exception("Failed to update notification state: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception('Error updating notification state: $e');
    }
  }

}
