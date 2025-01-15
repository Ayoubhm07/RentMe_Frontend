import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Services/OffreLocationService.dart';
import '../../entities/OffreLocation.dart';

class OfferDetailsCard extends StatelessWidget {
  final OffreLocation offer;
  final String username;

  OfferDetailsCard({Key? key, required this.offer, required this.username}) : super(key: key);

  Future<void> terminerOffre(int id) async {
    OffreLocationService offreLocationService = OffreLocationService();
    try {
      OffreLocation updatedOffer = await offreLocationService.terminerOffre(id);
      print('Offer updated successfully: ${updatedOffer.toJson()}');
    } catch (e) {
      print('Failed to update offer: $e');
      throw Exception('Failed to update offer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      color: Colors.green[300],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails de l\'offre acceptée:',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 10.h),
            iconTextRow(Icons.person, "Username: $username"),
            iconTextRow(Icons.attach_money, "Prix: ${offer.price}£"),
            iconTextRow(Icons.calendar_today, "Période: ${offer.periode}"),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: Icon(Icons.chat, color: Colors.green[800]),
                  label: Text('Contacter le client'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green[800],
                    backgroundColor: Colors.white, // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => terminerOffre(offer.id ?? 0),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green[800],
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text('Terminer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget iconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 24.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
