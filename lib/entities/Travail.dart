class Travail {
  int? id;
  String? titre;
  String? description;
  String? image;
  DateTime? addedDate;
  int? userId;

  Travail({
    this.id,
    this.description,
    this.titre,
    this.image,
    this.addedDate,
    this.userId,
  });

  factory Travail.fromJson(Map<String, dynamic> json) {
    return Travail(
      id: json['id'],
      description: json['description'],
      titre: json['titre'],
      addedDate: DateTime.parse(json['addedDate'] ?? DateTime.now().toIso8601String()),
      image: json['image'],
      userId: json['userId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'titre': titre,
      'addedDate': addedDate?.toIso8601String(),
      'image': image,
      'userId': userId,
    };
  }
}