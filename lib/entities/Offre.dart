
class Offre {
  int? id;
  OfferStatus status;
  int price;
  String periode;
  DateTime acceptedAt;
  DateTime finishedAt;
  int userId;
  int demandId;

  Offre({
    this.id,
    required this.demandId,
    required this.status,
    required this.price,
    required this.periode,
    required this.acceptedAt,
    required this.finishedAt,
    required this.userId,
  });


  factory Offre.fromJson(Map<String, dynamic> json) {
    return Offre(
      id: json['id'],
      demandId: json['demandId'],
      status: OfferStatus.values.firstWhere((e) => e.toString() == 'OfferStatus.${json['status']}'),
      price: json['price'],
      periode: json['periode'],
      acceptedAt: json['acceptedAt'] == null ? DateTime.now() : DateTime.parse(json['acceptedAt']),
      finishedAt: json['finishedAt'] == null ? DateTime.now() : DateTime.parse(json['finishedAt']),
      userId: json['userId'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'demandId': demandId,
      'status': status.toString().split('.').last,
      'price': price,
      'periode': periode,
      'acceptedAt': acceptedAt.toIso8601String(),
      'finishedAt': finishedAt.toIso8601String(),
      'userId': userId,
    };
  }
}

enum OfferStatus {
  pending , accepted , rejected, done
}