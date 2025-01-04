
enum ConversationType {
  PRIVATE,
  GROUP,
  // Add other types as needed
}

class Conversation {
  final int id;
  final String name;
  final int userId;
  final ConversationType type;
  final DateTime createdAt;
  final List<int> participantIds;
  final String namePerUser;

  Conversation({
    required this.id,
    required this.name,
    required this.userId,
    required this.type,
    required this.createdAt,
    required this.participantIds,
    required this.namePerUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'type': type.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'participantIds': participantIds,
      'namePerUser': namePerUser,
    };
  }

  static Conversation fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      name: json['name'] ?? '',
      userId: json['userId'],
      type: ConversationType.values.firstWhere((e) => e.toString() == 'ConversationType.' + json['type']),
      createdAt: DateTime.parse(json['createdAt']),
      participantIds: List<int>.from(json['participantIds']),
      namePerUser: json['namePerUser'],
    );
  }

  @override
  String toString() {
    return 'Conversation{id: $id, name: $name, userId: $userId, type: $type, createdAt: $createdAt, participantIds: $participantIds, namePerUser: $namePerUser}';
  }
}