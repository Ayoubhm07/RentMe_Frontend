
class OffreLocation {
  int? id;
  OfferStatus status;
  int price;
  String periode;
  DateTime acceptedAt;
  DateTime finishedAt;
  int userId;
  int locationId;


  OffreLocation({
    this.id,
    required this.locationId,

    required this.status,
    required this.price,
    required this.periode,
    required this.acceptedAt,
    required this.finishedAt,
    required this.userId,
  });


  factory OffreLocation.fromJson(Map<String, dynamic> json) {
    return OffreLocation(
      id: json['id'],
      status: OfferStatus.values.firstWhere((e) => e.toString() == 'OfferStatus.${json['status']}'),
      price: json['price'],
      periode: json['periode'],
      acceptedAt: json['acceptedAt'] == null ? DateTime.now() : DateTime.parse(json['acceptedAt']),
      finishedAt: json['finishedAt'] == null ? DateTime.now() : DateTime.parse(json['finishedAt']),
      userId: json['userId'],
      locationId: json['locationId'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationId': locationId,
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
  pending , accepted , rejected , done
}