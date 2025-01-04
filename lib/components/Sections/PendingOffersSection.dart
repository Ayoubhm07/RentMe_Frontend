// PendingOffersSection.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:khedma/Services/DemandeService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/entities/Demand.dart';
import 'package:khedma/entities/User.dart';
import '../../Services/OffreService.dart';
import '../../entities/Offre.dart';
import '../../theme/AppTheme.dart';
import '../Card/CardOffre.dart';

class PendingOffersSection extends StatelessWidget {
  final OffreService offreService;
  final DemandeService demandeService = DemandeService();
  final SharedPrefService sharedPrefService = SharedPrefService();

  PendingOffersSection({Key? key, required this.offreService}) : super(key: key);

  Future<List<Offre>> _fetchPendingOffers() {
    return offreService.getOffersByUserIdAndStatus(6, 'pending');
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
                            onEditPressed: () => _showBottomSheet(context,offre),
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
                  String result = await offreService.deleteOffer(offerId);
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
  void _showBottomSheet(BuildContext context, Offre currentOffer) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        int period = int.tryParse(currentOffer.periode) ?? 1;
        int price = currentOffer.price;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Proposition de prix',
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Proposez une offre de prix afin de répondre à cette demande.',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildIncrementDecrementWidget(
                          "Période(Nuit)", period, (newPeriod) {
                        setState(() {
                          period = newPeriod;
                        });
                      }),
                      SizedBox(width: 20.w),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildIncrementDecrementWidget(
                              "Prix", price, (newPrice) {
                            setState(() {
                              price = newPrice;
                            });
                          }),
                          SizedBox(width: 10.w),
                          Padding(
                            padding: EdgeInsets.only(bottom: 0.h),
                            child: Image.asset(
                              "assets/icons/coins.png",
                              width: 50.w,
                              height: 50.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      currentOffer.periode = period.toString() +" jours";
                      currentOffer.price = price;
                      try {
                        Offre updatedOffer = await offreService.createOffer(currentOffer);
                        // Display a message or update the UI
                      } catch (e) {
                        // Handle error
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 50.w),
                    ),
                    child: Text(
                      'Valider',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIncrementDecrementWidget(
      String label, int value, Function(int) onChanged, {
        bool showCoin = false,
      }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.19.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h), // Add some space between the label and the controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the row content
          children: [
            Column(
              children: [
                Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF0099D5)),
                    borderRadius: BorderRadius.circular(6.6),
                  ),
                  child: Center(
                    child: IconButton(
                      iconSize: 20.w,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (value > 1) {
                          onChanged(value - 1);
                        }
                      },
                      icon: Icon(Icons.remove),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF0099D5)),
                    borderRadius: BorderRadius.circular(6.6),
                  ),
                  child: Center(
                    child: IconButton(
                      iconSize: 20.w,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        onChanged(value + 1);
                      },
                      icon: Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 5.w),
            Container(
              width: 70.w,
              height: 40.h,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 1.3),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF0099D5)),
                borderRadius: BorderRadius.circular(6),
                color: Color(0xFFF4F6F5),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x11124565),
                    offset: Offset(0, 4),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "$value",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
