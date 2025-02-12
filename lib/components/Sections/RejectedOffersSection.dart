// RejectedOffersSection.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khedma/Services/DemandeService.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/components/Card/RejectedOfferCard.dart';
import 'package:khedma/entities/Demand.dart';
import 'package:khedma/entities/User.dart';
import '../../Services/OffreService.dart';
import '../../entities/Offre.dart';
import '../../entities/ProfileDetails.dart';
import '../Card/CardOffre.dart';



class RejectedOffersSection extends StatefulWidget {
  final OffreService offreService;
  RejectedOffersSection({Key? key, required this.offreService}) : super(key: key);
  @override
  _RejectedOffersSectionState createState() => _RejectedOffersSectionState();
}
class _RejectedOffersSectionState extends State<RejectedOffersSection> {
  final DemandeService demandeService = DemandeService();
  final SharedPrefService sharedPrefService = SharedPrefService();
  final MinIOService minIOService = MinIOService();
  final ProfileService profileService = ProfileService();
  String? userImage ;

  @override
  void initState() {
    super.initState();
    _fetchUserProfileImage();
  }

  Future<void> _fetchUserProfileImage() async {
    try {
      User user = await sharedPrefService.getUser();
      ProfileDetails profileDetails = await profileService.getProfileDetails(user.id ?? 0);
      String objectName = profileDetails.profilePicture!.replaceFirst('images_', '');
      String filePath = await minIOService.LoadFileFromServer('images', objectName);
      setState(() {
        userImage = filePath;
      });
      print(userImage);
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
  }

  Future<List<Offre>> _fetchPendingOffers() async {
    User user = await sharedPrefService.getUser();
    return widget.offreService.getOffersByUserIdAndStatus(user.id ?? 0, 'rejected');
  }

  Future<Demand?> _fetchDemand(int demandId) async {
    try {
      return await demandeService.getDemandById(demandId);
    } catch (e) {
      print("Error fetching demand: $e");
      return null;
    }
  }

  Future<User?> _fetchUser() async {
    try {
      return await sharedPrefService.getUser();
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:MM').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _fetchUser(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (userSnapshot.hasError) {
          return Center(child: Text('Erreur : ${userSnapshot.error}'));
        } else if (!userSnapshot.hasData) {
          return Center(child: Text("Utilisateur non trouvé"));
        } else {
          User user = userSnapshot.data!;

          return FutureBuilder<List<Offre>>(
            future: _fetchPendingOffers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Aucune offre en attente'));
              } else {
                List<Offre> pendingOffers = snapshot.data!;

                return ListView.builder(
                  itemCount: pendingOffers.length,
                  itemBuilder: (context, index) {
                    Offre offre = pendingOffers[index];
                    return FutureBuilder<Demand?>(
                      future: _fetchDemand(offre.demandId ?? 0),
                      builder: (context, demandSnapshot) {
                        if (demandSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (demandSnapshot.hasError) {
                          return Text("Erreur lors de la récupération de la demande");
                        } else if (!demandSnapshot.hasData) {
                          return Text("Aucune demande trouvée");
                        } else {
                          Demand demand = demandSnapshot.data!;
                          return RejectedOffreCard(
                            locationId: demand.id ?? 0,
                            userImage: userImage ?? "",
                            images: 'https://example.com/image1.png',
                            title: demand.title,
                            dateDebut: _formatDateTime(offre.acceptedAt),
                            addedDate: _formatDateTime(demand.addedDate),
                            description: demand.description,
                            location: "Offre rejeté !",
                            ownerName: user.userName,
                            paiement: offre.periode,
                            budget: offre.price.toString()+"€",
                            onContactPressed: () {},
                            onRentPressed: () {},
                            onEditPressed: () {},
                            onCancelPressed: () {},
                          );
                        }
                      },
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}
