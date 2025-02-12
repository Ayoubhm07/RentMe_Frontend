class NotificationRequest {
  final String title;
  final String body;
  final String topic;
  final String token;
  final int senderId;
  final int receiverId;

  NotificationRequest({
    required this.title,
    required this.receiverId,
    required this.body,
    required this.topic,
    required this.token,
    required this.senderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'topic': topic,
      'token': token,
      'senderId': senderId,
      'receiverId': receiverId,
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
