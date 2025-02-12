import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khedma/entities/Conversation.dart';
import 'package:khedma/entities/LastMessage.dart';

import 'JWTService.dart';
import 'SharedPrefService.dart';

class ConversationAndMessageService {
  final String apiUrl = 'http://localhost:8080/chat/conversation';
  JWTService jwtService = JWTService();
  SharedPrefService sharedPrefService = SharedPrefService();

  Future<List<Conversation>> FetchUserConversation(int id) async {
    try {
      String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');

      var response = await http.get(
        Uri.parse('$apiUrl/getConversationsByUserId/$id'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Conversations chargées avec succès');
        List<dynamic> body = jsonDecode(response.body);
        List<Conversation> conversations = body.map((dynamic item) => Conversation.fromJson(item)).toList();
        return conversations;
      } else {
        throw Exception('Failed to load conversations: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load conversations: $e');
    }
  }

  Future<Conversation> createConversation(int userId, List<int> participantsIds) async {
    try {
      String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
      print("Envoi de la requête pour créer une conversation avec userId: $userId, participantsIds: $participantsIds");

      final response = await http.post(
        Uri.parse('$apiUrl/createConversation/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(participantsIds),
      );

      print("Réponse du serveur: ${response.statusCode}, ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Données reçues: $responseData");
        return Conversation.fromJson(responseData);
      } else {
        throw Exception('Échec de la création de la conversation: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Erreur lors de la création de la conversation: $e");
      throw Exception('Erreur lors de la création de la conversation: $e');
    }
  }

  Future<List<ConversationWithLastMessage>> getConversationsWithLastMessageByUserId(int userId) async {
    try {
      String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');

      final response = await http.get(
        Uri.parse('$apiUrl/getConversationsWithLastMessageByUserId/$userId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Conversations avec dernier message récupérées avec succès');
        List<dynamic> body = jsonDecode(response.body);
        List<ConversationWithLastMessage> conversations = body.map((dynamic item) => ConversationWithLastMessage.fromJson(item)).toList();
        return conversations;
      } else {
        throw Exception('Échec du chargement des conversations avec dernier message: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Erreur lors du chargement des conversations avec dernier message: $e");
      throw Exception('Erreur lors du chargement des conversations avec dernier message: $e');
    }
  }
}
