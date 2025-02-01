import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/theme/AppTheme.dart';

class CardOffre extends StatelessWidget {
  final String userImage;
  final String imageUrl;
  final String title;
  final String dateDebut;
  final String addedDate;
  final String budget;
  final String description;
  final String location;
  final String ownerName;
  final String paiement;
  final VoidCallback onContactPressed;
  final VoidCallback onRentPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onCancelPressed;

  const CardOffre({
    Key? key,
    required this.userImage,
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.dateDebut,
    required this.addedDate,
    required this.paiement,
    required this.budget,
    required this.location,
    required this.ownerName,
    required this.onContactPressed,
    required this.onRentPressed,
    required this.onEditPressed,
    required this.onCancelPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(8.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          color: Colors.white.withOpacity(0.68),
          elevation: 4,
          shadowColor: const Color(0x3F000000),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.asset(
                    "assets/images/menage.jpeg",
                    width: double.infinity,
                    height: 150.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  dateDebut.toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF585858),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF585858),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.65.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundImage: userImage != null
                                  ? FileImage(File(userImage!))
                                  : AssetImage("assets/images/default_avatar.png") as ImageProvider,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                ownerName,
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Icon(Icons.timer, size: 18.sp, color: Colors.blue),
                            SizedBox(width: 4.w),
                            Text(
                              'Durée: $paiement',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, size: 18.sp, color: Colors.green),
                            SizedBox(width: 4.w),
                            Text(
                              'Budget: $budget',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Statut : $location",
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEEA41D),
                                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: onEditPressed,
                              icon: Icon(Icons.edit, size: 16.sp, color: Colors.white),
                              label: Text(
                                'Modifier',
                                style: GoogleFonts.roboto(fontSize: 12.sp, color: Colors.white),
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: onCancelPressed,
                              icon: Icon(Icons.cancel, size: 16.sp, color: Colors.white),
                              label: Text(
                                'Annuler',
                                style: GoogleFonts.roboto(fontSize: 12.sp, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
