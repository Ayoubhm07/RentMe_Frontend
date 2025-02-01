import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/OffreLocationService.dart';
import 'package:khedma/Services/OffreService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/entities/OffreLocation.dart';
import 'package:khedma/entities/User.dart';
import 'package:khedma/theme/AppTheme.dart';

import '../Card/SuccessNotificationCard.dart';

void showAddLocationOffreBottomSheet(BuildContext context, int locationId, String timeUnit) async {
  OffreLocationService offreLocationService = OffreLocationService();
  SharedPrefService sharedPrefService = SharedPrefService();
  int price = 20;
  int duration = 1;
  String durationType = timeUnit;

  try {
    User user = await sharedPrefService.getUser();
    int userId = user.id ?? 0;

    List<OffreLocation> existingOffers = await offreLocationService.getOffersByLocation(locationId);

    bool hasUserPostedOffer = existingOffers.any((offer) => offer.userId == userId);

    if (hasUserPostedOffer) {
      // Show a SuccessDialog informing the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SuccessDialog(
            message: 'Vous avez déjà soumis une offre pour cette location.',
            logoPath: 'assets/images/logo.png',
            iconPath: 'assets/icons/echec.png',
          );
        },
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context); // Close SuccessDialog
      });
      return; // Exit the function to prevent further actions
    }

    // Show the modal bottom sheet for adding a new offer
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Proposez une offre de prix afin de répondre à cette demande.',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Montant de l\'offre',
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Image.asset("assets/icons/coins.png", width: 24, height: 24),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {
                      price = int.tryParse(value) ?? price;
                    }),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Durée',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => setState(() {
                            duration = int.tryParse(value) ?? duration;
                          }),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      DropdownButton<String>(
                        value: (['heures', 'jours', 'mois'].contains(durationType)) ? durationType : 'jours',
                        items: <String>['heures', 'jours', 'mois'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              durationType = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        OffreLocation newOffer = OffreLocation(
                          locationId: locationId,
                          status: OfferStatus.pending,
                          price: price,
                          periode: "$duration $durationType",
                          acceptedAt: DateTime.now(),
                          finishedAt: DateTime.now(),
                          userId: userId,
                        );
                        await offreLocationService.createOffer(newOffer);

                        // Show success dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SuccessDialog(
                              message: 'Offre de location ajoutée correctement.',
                              logoPath: 'assets/images/logo.png',
                              iconPath: 'assets/icons/check1.png',
                            );
                          },
                        );
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context); // Close SuccessDialog
                          Navigator.pop(context); // Close BottomSheet
                        });
                      } catch (e) {
                        // Show error dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SuccessDialog(
                              message: 'Problème lors de l\'ajout de votre offre!',
                              logoPath: 'assets/images/logo.png',
                              iconPath: 'assets/icons/echec.png',
                            );
                          },
                        );
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context); // Close ErrorDialog
                          Navigator.pop(context); // Close BottomSheet
                        });
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
                      'Soumettre',
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
  } catch (e) {
    print('Error fetching user or processing data: $e');
  }
}
