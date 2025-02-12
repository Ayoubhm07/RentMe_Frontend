import 'dart:convert';

enum PubStatus { active, inactive }

class Pub {
  int? id;
  String? title;
  String? description;
  String? image;
  String? link;
  PubStatus? status;
  DateTime? startDate;
  int? nombreJours;
  int? nombreSecondes;

  Pub({
    this.id,
    this.title,
    this.description,
    this.image,
    this.link,
    this.status,
    this.startDate,
    this.nombreJours,
    this.nombreSecondes,
  });

  /// Factory constructor pour convertir un JSON en objet `Pub`
  factory Pub.fromJson(Map<String, dynamic> json) {
    return Pub(
      id: json['id'],
      title: json['title'], // Correction ici (title au lieu de titre)
      description: json['description'],
      image: json['image'],
      link: json['link'],
      status: PubStatus.values.firstWhere(
            (e) => e.toString().split('.').last == json['status'],
        orElse: () => PubStatus.inactive, // Valeur par défaut
      ),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      nombreJours: json['nombreJours'],
      nombreSecondes: json['nombreSecondes'],
    );
  }

  /// Convertir l'objet en JSON pour l'envoyer vers l'API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title, // Correction ici
      'description': description,
      'image': image,
      'link': link,
      'status': status?.toString().split('.').last, // Conversion Enum -> String
      'startDate': startDate?.toIso8601String(),
      'nombreJours': nombreJours,
      'nombreSecondes': nombreSecondes,
    };
  }
}
