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
      title: json['title'] ?? 'No Title',
      body: json['body'] ?? 'No Body',
      topic: json['topic'] ?? 'No Topic',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      state: NotificationState.values.firstWhere(
              (e) => e.toString() == 'NotificationState.${json['state']?.toString().toLowerCase()}',
          orElse: () => NotificationState.unread
      ),
      userId: json['userId'] ?? 0,
    );
  }
}

enum NotificationState { read, unread }
