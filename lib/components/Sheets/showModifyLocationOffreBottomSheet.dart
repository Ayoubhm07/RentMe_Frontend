import 'package:dynamic_multi_step_form/dynamic_multi_step_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Services/OffreLocationService.dart';
import '../../entities/OffreLocation.dart';
import '../../theme/AppTheme.dart';
import '../Card/SuccessNotificationCard.dart';

void showModifyLocationOffreBottomSheet(BuildContext context, OffreLocation currentOffer) async {
  OffreLocationService offreLocationService = OffreLocationService();
  int price = currentOffer.price;
  int duration = int.tryParse(currentOffer.periode.split(" ").first) ?? 1;
  String durationType = currentOffer.periode.split(" ").last;

  // Controllers initialized outside the StatefulBuilder
  TextEditingController priceController = TextEditingController(text: price.toString());
  TextEditingController durationController = TextEditingController(text: duration.toString());

  try {
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
                    'Modifier les détails de votre offre de location.',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: priceController, // Use the external controller
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
                    onChanged: (value) {
                      setState(() {
                        price = int.tryParse(value) ?? price;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: durationController, // Use the external controller
                          decoration: InputDecoration(
                            labelText: 'Durée',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              duration = int.tryParse(value) ?? duration;
                            });
                          },
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
                        currentOffer.price = price;
                        currentOffer.periode = "$duration $durationType";

                        await offreLocationService.createOffer(currentOffer);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SuccessDialog(
                              message: 'Offre de location modifiée avec succès!',
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SuccessDialog(
                              message: 'Erreur lors de la modification de l\'offre: $e',
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
                      'Modifier',
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
    print('Error fetching or processing data: $e');
  }
}
