import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/DemandeService.dart';

import '../../theme/AppTheme.dart';

void showEditBottomSheet(BuildContext context, {required int idDemand}) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      final TextEditingController priceController = TextEditingController();
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;

      return Padding(
        padding: EdgeInsets.only(
          top: 16.h,
          left: 16.w,
          right: 16.w,
          bottom: bottomInset + 16.h, // Ajustement pour le clavier
        ),
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
                      'Proposition de prix pour la demande #$idDemand',
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
            Padding(
              padding: EdgeInsets.only(left: 20.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre prix',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
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
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () async {
                double? price = double.tryParse(priceController.text);
                if (price == null || price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Veuillez entrer un prix valide supérieur à zéro."),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  try {
                    DemandeService demandService = DemandeService();
                    await demandService.updateDemandPrice(idDemand, price);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Mise à jour du prix réussie"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Erreur lors de la mise à jour du prix: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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
}

