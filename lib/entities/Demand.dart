class Demand {
  int? id;
  String title;
  String description;
  String domain;
  String location;
  double budget;
  String ownerName;
  bool isExpertNeeded;
  DemandStatus status;
  DateTime addedDate;
  int userId;
  String? phoneNumber;
  String? userEmail;
  String? userImage;





  Demand({
    this.id,
    this.phoneNumber,
    this.userImage,
    this.userEmail,
    required this.domain,
    required this.title,
    required this.description,
    required this.location,
    required this.ownerName,
    required this.budget,
    required this.isExpertNeeded,
    required this.status,
    required this.addedDate,
    required this.userId,
  });

  factory Demand.fromJson(Map<String, dynamic> json) {
    return Demand(
      id: json['id'],
      userImage: json['userImage'],
      userEmail: json['userEmail'],
      phoneNumber: json['phoneNumber'],
      title: json['title'],
      ownerName: json['ownerName'],
      domain: json['domain'],
      location: json['location'],
      description: json['description'],
      budget: json['budget'],
      isExpertNeeded: json['ExpertNeeded'] ?? false,
      status: DemandStatus.values.firstWhere((e) => e.toString() == 'DemandStatus.${json['status']}'),
      addedDate: DateTime.parse(json['addedDate'] ?? DateTime.now().toIso8601String()),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userImage' : userImage,
      'phoneNumber' : phoneNumber,
      'userEmail' : userEmail,
      'title': title,
      'domain': domain,
      'description': description,
      'ownerName': ownerName,
      'budget': budget,
      'location': location,
      'ExpertNeeded': isExpertNeeded,
      'status': status.toString().split('.').last,
      'addedDate': addedDate.toIso8601String(),
      'userId': userId,
    };
  }
}
enum DemandStatus {
  open , closed
  // Define your enum values here
}