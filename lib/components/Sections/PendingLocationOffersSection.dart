// PendingOffersSection.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:khedma/Services/DemandeService.dart';
import 'package:khedma/Services/LocationService.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/OffreLocationService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/entities/Demand.dart';
import 'package:khedma/entities/Location.dart';
import 'package:khedma/entities/OffreLocation.dart';
import 'package:khedma/entities/User.dart';
import '../../Services/OffreService.dart';
import '../../entities/Offre.dart';
import '../../entities/ProfileDetails.dart';
import '../../theme/AppTheme.dart';
import '../Card/CardOffre.dart';
import '../Card/ConfirmationNotficationCard.dart';
import '../Card/SuccessNotificationCard.dart';
import '../Sheets/showModifyLocationOffreBottomSheet.dart';

class PendingLocationOffersSection extends StatefulWidget {
  final OffreLocationService offreService;

  PendingLocationOffersSection({Key? key, required this.offreService}) : super(key: key);

  @override
  _PendingLocationOffersSectionState createState() => _PendingLocationOffersSectionState();
}

class _PendingLocationOffersSectionState extends State<PendingLocationOffersSection> {
  final LocationService demandeService = LocationService();
  final SharedPrefService sharedPrefService = SharedPrefService();
  final ProfileService profileService = ProfileService();
  final MinIOService minIOService = MinIOService();
  String? userImage;


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
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
  }

  Future<List<OffreLocation>> _fetchPendingOffers() async {
    User? user = await _fetchUser();
    return widget.offreService.getOffersByUserIdAndStatus(user!.id ?? 0, 'pending');
  }

  Future<Location?> _fetchDemand(int demandId) async {
    try {
      return await demandeService.getLocationById(demandId);
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
                          return CardOffre(
                            locationId: demand.id ?? 0,
                            userImage: userImage ?? "",
                            images: demand.images,
                            title: demand.description,
                            dateDebut: _formatDateTime(offre.acceptedAt),
                            addedDate: demand.timeUnit,
                            description: demand.description,
                            location: "Offre actuellement en attente ...",
                            ownerName: user.userName,
                            paiement: offre.periode,
                            budget: "${offre.price} jetons",
                            onContactPressed: () {},
                            onRentPressed: () {},
                            onEditPressed: () => showModifyLocationOffreBottomSheet(context, offre),
                            onCancelPressed: () => _showCancelDialog(context, offre.id ?? 0),
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

  void _showCancelDialog(BuildContext context, int offerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Voulez-vous vraiment annuler cette offre ?',
          logoPath: 'assets/images/logo.png',
          onConfirm: () async {
            Navigator.of(context).pop();
            try {
              await widget.offreService.deleteOffer(offerId);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Votre offre de location a été annulée avec succès.',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/check1.png',
                  );
                },
              );
              await Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pop(); // Fermer SuccessDialog
              Navigator.of(context).pop();
            } catch (e) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Une erreur est survenue lors de l\'annulation de votre offre.',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/echec.png',
                  );
                },
              );

              await Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pop(); // Fermer ErrorDialog
            }
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
