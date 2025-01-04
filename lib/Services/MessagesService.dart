import 'dart:convert';
import 'package:khedma/Services/SharedPrefService.dart';
import '../entities/Message.dart';
import 'package:http/http.dart' as http;

class MessageService {

  SharedPrefService sharedPrefService = SharedPrefService();
  String apiUrl = 'http://localhost:8080/chat'; // L'URL de votre API Gateway
  Future<List<Message>> fetchMessagesByConversationId(
      int conversationId) async {
    String accessToken = await sharedPrefService.readUserData('accessToken');
    var response = await http.get(
      Uri.parse('$apiUrl/message/getMessagesByConversationId/$conversationId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((message) => Message.fromJson(message)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
