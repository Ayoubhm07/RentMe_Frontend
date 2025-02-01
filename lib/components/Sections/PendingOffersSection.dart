// PendingOffersSection.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:khedma/Services/DemandeService.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/entities/Demand.dart';
import 'package:khedma/entities/User.dart';
import '../../Services/OffreService.dart';
import '../../entities/Offre.dart';
import '../../entities/ProfileDetails.dart';
import '../../theme/AppTheme.dart';
import '../Card/CardOffre.dart';
import '../Sheets/showModifyLocationOffreBottomSheet.dart';
import '../Sheets/showModifyOffreBottomSheet.dart';


class PendingOffersSection extends StatefulWidget {
  final OffreService offreService;

  PendingOffersSection({Key? key, required this.offreService}) : super(key: key);

  @override
  _PendingOffersSectionState createState() => _PendingOffersSectionState();
}

class _PendingOffersSectionState extends State<PendingOffersSection> {
  final DemandeService demandeService = DemandeService();
  final SharedPrefService sharedPrefService = SharedPrefService();
  final MinIOService minIOService = MinIOService();
  final ProfileService profileService = ProfileService();
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

  Future<List<Offre>> _fetchPendingOffers() async {
    User? user = await _fetchUser();
    return widget.offreService.getOffersByUserIdAndStatus(user!.id ?? 0, 'pending');
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
                          return CardOffre(
                            userImage: userImage ?? "",
                            imageUrl: 'https://example.com/image1.png',
                            title: demand.title,
                            dateDebut: _formatDateTime(offre.acceptedAt),
                            addedDate: _formatDateTime(demand.addedDate),
                            description: demand.description,
                            location: "Offre actuellement en attente ...",
                            ownerName: user.userName,
                            paiement: offre.periode,
                            budget: offre.price.toString()+"€",
                            onContactPressed: () {},
                            onRentPressed: () {},
                            onEditPressed: () => showModifyOffreBottomSheet(context,offre),
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
        return AlertDialog(
          title: Text('Annulation de l\'offre'),
          content: Text('Voulez-vous vraiment annuler cette offre ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Non', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  String result = await widget.offreService.deleteOffer(offerId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de la suppression de l\'offre: $e')),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Oui', style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }


  int period = 1;
  int price = 20;
}
