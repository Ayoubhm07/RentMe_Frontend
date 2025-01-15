class NotificationRequest {
  final String title;
  final String body;
  final String topic;
  final String token;
  final int userId;

  NotificationRequest({
    required this.title,
    required this.body,
    required this.topic,
    required this.token,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'topic': topic,
      'token': token,
      'userId': userId,
    };
  }
}

class NotificationResponse {
  final int status;
  final String message;

  NotificationResponse({
    required this.status,
    required this.message,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
