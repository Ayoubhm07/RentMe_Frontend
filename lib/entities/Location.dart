enum LocationStatus {
  DISPONIBLE , NON
}

class Location {
  int? id;
  String description;
  String category;
  double prix;
  String timeUnit;
  String images;
  LocationStatus status;
  int userId;

  Location({
    this.id,
    required this.description,
    required this.category,
    required this.prix,
    required this.timeUnit,
    required this.images,
    required this.status,
    required this.userId,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      description: json['description'],
      category: json['category'],
      prix: json['prix'],
      timeUnit: json['timeUnit'],
      images: json['images'],
      status: LocationStatus.values.firstWhere((e) => e.toString() == 'LocationStatus.${json['status']}'),
      userId: json['userId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'category': category,
      'prix': prix,
      'timeUnit': timeUnit,
      'images': images,
      'status': status.toString().split('.').last,
      'userId': userId,
    };
  }
}