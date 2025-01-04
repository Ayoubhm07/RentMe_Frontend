class ProfileDetails {
  final int userId;
   String? profilePicture;
  final String? description;
  final String? specialite;
  final String? diplome;
  final String? rue;
  final String? ville;
  final String? codePostal;
  final String? pays;
  final String? titre;
  final String? nomSocieteExp;
  final String? dateDebut;
  final String? dateFin;
  final String? descriptionExp;
  final String? certifications;
  final String? formations;
  final String? projets;
  final String? nomSociete;
  final String? domaine;
  final String? kbis;
  final String? labelQualite;
  final String? assurance;
  final String? ancienClients;
  final int? nombreSalaries;

  ProfileDetails({
    required this.userId,
    this.profilePicture,
    this.description,
    this.specialite,
    this.diplome,
    this.rue,
    this.ville,
    this.codePostal,
    this.pays,
    this.titre,
    this.nomSocieteExp,
    this.dateDebut,
    this.dateFin,
    this.descriptionExp,
    this.formations,
    this.projets,
    this.nomSociete,
    this.domaine,
    this.certifications,
    this.kbis,
    this.labelQualite,
    this.ancienClients,
    this.nombreSalaries,
    this.assurance,
  });

  factory ProfileDetails.fromJson(Map<String, dynamic> json) {
    return ProfileDetails(
      userId: json['userId'],
      profilePicture: json['profilePicture'],
      description: json['description']?? '',
      specialite: json['specialite'] ?? '',
      diplome: json['diplome']  ?? '',
      rue: json['rue']  ?? '',
      ville: json['ville']  ?? '',
      codePostal: json['codePostal']  ?? '',
      pays: json['pays']  ?? '',
      titre: json['titre']    ?? '',
      nomSocieteExp: json['nomSocieteExp']  ?? '',
      dateDebut: json['dateDebut'],
      dateFin: json['dateFin'],
      descriptionExp: json['descriptionExp'],
      formations: json['formations']??'',
      projets: json['projets']??'',
      nomSociete: json['nomSociete']??'',
      domaine: json['domaine']??'',
      certifications: json['certifications']??'',
      kbis: json['kbis']??'',
      labelQualite: json['labelQualite']??'',
      ancienClients: json['ancienClients']??'',
      nombreSalaries: json['nombreSalaries']??0,
      assurance: json['assurance']??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'profilePicture': profilePicture,
      'description': description,
      'specialite': specialite,
      'diplome': diplome,
      'rue': rue,
      'ville': ville,
      'codePostal': codePostal,
      'pays': pays,
      'titre': titre,
      'nomSocieteExp': nomSocieteExp,
      'dateDebut': dateDebut,
      'dateFin': dateFin,
      'descriptionExp': descriptionExp,
      'formations': formations,
      'projets': projets,
      'nomSociete': nomSociete,
      'domaine': domaine,
      'certifications': certifications,
      'kbis': kbis,
      'labelQualite': labelQualite,
      'ancienClients': ancienClients,
      'nombreSalaries': nombreSalaries,
      'assurance': assurance,
    };
  }

}

