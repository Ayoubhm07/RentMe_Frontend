import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khedma/Services/LocationService.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/OffreLocationService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/components/Card/DoneOfferCard.dart';
import 'package:khedma/entities/Location.dart';
import 'package:khedma/entities/OffreLocation.dart';
import 'package:khedma/entities/ProfileDetails.dart';
import 'package:khedma/entities/User.dart';


class DoneLocationOffersSection extends StatefulWidget {
  final OffreLocationService offreService;

  DoneLocationOffersSection({Key? key, required this.offreService}) : super(key: key);

  @override
  _DoneLocationOffersSectionState createState() => _DoneLocationOffersSectionState();
}

class _DoneLocationOffersSectionState extends State<DoneLocationOffersSection> {
  final LocationService demandeService = LocationService();
  final SharedPrefService sharedPrefService = SharedPrefService();
  final MinIOService minIOService = MinIOService();
  final ProfileService profileService = ProfileService();
  String? userImage;
  
  @override
  void initState() {
    super.initState();
    _fetchUserProfileImage();
  }

  Future<List<OffreLocation>> _fetchPendingOffers() async {
    User user = await sharedPrefService.getUser();
    return widget.offreService.getOffersByUserIdAndStatus(user.id ?? 0, 'done');
  }

  Future<Location?> _fetchDemand(int demandId) async {
    try {
      return await demandeService.getLocationById(demandId);
    } catch (e) {
      print("Error fetching demand: $e");
      return null;
    }
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

  Future<User?> _fetchUser() async {
    try {
      return await sharedPrefService.getUser();
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
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

          return FutureBuilder<List<OffreLocation>>(
            future: _fetchPendingOffers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Aucune offre en attente'));
              } else {
                List<OffreLocation> pendingOffers = snapshot.data!;

                return ListView.builder(
                  itemCount: pendingOffers.length,
                  itemBuilder: (context, index) {
                    OffreLocation offre = pendingOffers[index];
                    return FutureBuilder<Location?>(
                      future: _fetchDemand(offre.locationId ?? 0),
                      builder: (context, demandSnapshot) {
                        if (demandSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (demandSnapshot.hasError) {
                          return Text("Erreur lors de la récupération de la demande");
                        } else if (!demandSnapshot.hasData) {
                          return Text("Aucune demande trouvée");
                        } else {
                          Location demand = demandSnapshot.data!;
                          return DoneOfferCard(
                            userImage: userImage ?? "",
                            imageUrl: 'https://example.com/image1.png',
                            title: demand.description,
                            dateDebut: _formatDateTime(offre.acceptedAt),
                            addedDate: demand.timeUnit,
                            description: demand.description,
                            location: "Offre terminé !",
                            ownerName: user.userName,
                            paiement: offre.periode,
                            budget: offre.price.toString() + " jetons",
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
