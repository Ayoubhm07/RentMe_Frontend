
import 'package:dynamic_multi_step_form/dynamic_multi_step_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Services/LocationService.dart';
import '../../theme/AppTheme.dart';
import '../Card/SuccessNotificationCard.dart';

void showModifyLocationBottomSheet(BuildContext context, int locationId) async {
  LocationService locationService = LocationService();
  double price = 50.0;
  String timeUnit = 'jours';
  TextEditingController priceController = TextEditingController(text: price.toStringAsFixed(2));
  String selectedTimeUnit = timeUnit;

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
                  // Titre
                  Text(
                    'Modifier les détails de votre location.',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'Montant de la location',
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
                        price = double.tryParse(value) ?? price;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),

                  // Sélecteur d'unité de temps
                  DropdownButtonFormField<String>(
                    value: selectedTimeUnit,
                    decoration: InputDecoration(
                      labelText: 'Unité de temps',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    items: <String>['heures', 'jours', 'mois'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedTimeUnit = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20.h),

                  // Bouton de validation
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await locationService.updateLocationPriceTime(
                          locationId,
                          price,
                          selectedTimeUnit,
                        );

                        // Afficher le SuccessDialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SuccessDialog(
                              message: 'Location modifiée avec succès!',
                              logoPath: 'assets/images/logo.png',
                              iconPath: 'assets/icons/check1.png',
                            );
                          },
                        );

                        // Fermer les dialogues après un délai
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context); // Fermer SuccessDialog
                          Navigator.pop(context); // Fermer BottomSheet
                        });
                      } catch (e) {
                        // Gérer les erreurs avec un SuccessDialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SuccessDialog(
                              message: 'Erreur lors de la modification de la location: $e',
                              logoPath: 'assets/images/logo.png',
                              iconPath: 'assets/icons/echec.png',
                            );
                          },
                        );

                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context); // Fermer ErrorDialog
                          Navigator.pop(context); // Fermer BottomSheet
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
    print('Erreur lors de la modification de la location: $e');
  }
}
