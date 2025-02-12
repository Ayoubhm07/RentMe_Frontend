import 'package:khedma/entities/Conversation.dart';
import 'package:khedma/entities/Message.dart';

class ConversationWithLastMessage {
  final int id;
  final String name;
  final int userId;
  final ConversationType type;
  final DateTime createdAt;
  final List<int> participantIds;
  final String namePerUser;
  final Message lastMessage;

  ConversationWithLastMessage({
    required this.id,
    required this.name,
    required this.userId,
    required this.type,
    required this.createdAt,
    required this.participantIds,
    required this.namePerUser,
    required this.lastMessage,
  });

  /// Convertir un objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'type': type.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'participantIds': participantIds,
      'namePerUser': namePerUser,
      'lastMessage': lastMessage.toJson(),
    };
  }

  /// Convertir un JSON en objet ConversationWithLastMessage
  static ConversationWithLastMessage fromJson(Map<String, dynamic> json) {
    return ConversationWithLastMessage(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      userId: json['userId'] ?? 0,
      type: ConversationType.values.firstWhere(
            (e) => e.toString() == 'ConversationType.${json['type'] ?? 'PRIVATE'}',
        orElse: () => ConversationType.PRIVATE,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      participantIds: List<int>.from(json['participantIds'] ?? []),
      namePerUser: json['namePerUser'] ?? '',
      lastMessage: Message.fromJson(json['lastMessage'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'ConversationWithLastMessage{id: $id, name: $name, userId: $userId, type: $type, createdAt: $createdAt, participantIds: $participantIds, namePerUser: $namePerUser, lastMessage: $lastMessage}';
  }
}
