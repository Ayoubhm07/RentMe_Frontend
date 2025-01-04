class Message {
  final String id;
  final String content;
  final String senderId;
  final DateTime deliveryTime;

  Message({required this.id, required this.content, required this.senderId, required this.deliveryTime});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(),
      content: json['content'],
      senderId: json['senderId'].toString(),
      deliveryTime: DateTime.parse(json['deliveryTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'deliveryTime': deliveryTime.toIso8601String(),
    };
  }
}