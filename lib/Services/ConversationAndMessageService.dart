import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khedma/entities/Conversation.dart';

import 'JWTService.dart';
import 'SharedPrefService.dart';

class ConversationAndMessageService {
  final String apiUrl = 'http://localhost:8080/chat';
  JWTService jwtService = JWTService();
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<List<Conversation>> FetchUserConversation(int id) async {
    try {
      String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');

      var response = await http.get(
        Uri.parse('$apiUrl/conversation/getConversationsByUserId/$id'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Conversations chargées avec succès');
        List<dynamic> body = jsonDecode(response.body);
        print(body);
        List<Conversation> conversations = body
            .map(
              (dynamic item) => Conversation.fromJson(item),
        )
            .toList();
        return conversations;
      } else {
        throw Exception(
            'Failed to load conversations: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load conversations: $e');
    }
  }
}
