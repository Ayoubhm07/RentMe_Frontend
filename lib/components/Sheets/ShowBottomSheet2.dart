import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/OffreService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/entities/Offre.dart';
import 'package:khedma/entities/User.dart';
import 'package:khedma/theme/AppTheme.dart';

void showAddOffreBottomSheet(BuildContext context, int demandId) async {
  OffreService offreService = OffreService();
  int price = 20; // Initial price
  int duration = 1; // Initial duration
  String durationType = 'jours'; // Default duration type

  try {
    User user = await SharedPrefService().getUser();
    if (user.roles.contains("USER")) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Restricted Access"),
            content: Text("As a user, you cannot submit an offer!"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }
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
                        padding: EdgeInsets.only(right: 8.0), // Optional: Adjust padding as needed
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
                        value: durationType,
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
                        Offre newOffer = Offre(
                          demandId: demandId,
                          status: OfferStatus.pending, // Ensure the status is correctly handled in your backend
                          price: price,
                          periode: "$duration $durationType",
                          acceptedAt: DateTime.now(),
                          finishedAt: DateTime.now(),
                          userId: user.id ?? 0,
                        );
                        await offreService.createOffer(newOffer);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Offer successfully submitted!'))
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error submitting offer: $e'))
                        );
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
                      'Submit',
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
