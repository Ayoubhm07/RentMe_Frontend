class NotificationMessage {
  final int? id;
  final String title;
  final String body;
  final String topic;
  final DateTime date;
  final NotificationState state;
  final int userId;

  NotificationMessage({
    this.id,
    required this.title,
    required this.body,
    required this.topic,
    required this.date,
    required this.state,
    required this.userId,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      id: json['id'],
      title: json['title'] ?? 'No Title', // Default value if null
      body: json['body'] ?? 'No Body', // Default value if null
      topic: json['topic'] ?? 'No Topic', // Default value if null
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()), // Use current time if null
      state: NotificationState.values.firstWhere(
              (e) => e.toString() == 'NotificationState.${json['state']?.toString().toLowerCase()}',
          orElse: () => NotificationState.unread // Default state if not found or null
      ),
      userId: json['userId'] ?? 0, // Default to 0 if null
    );
  }
}

enum NotificationState { read, unread }
