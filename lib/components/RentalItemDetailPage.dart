import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/OffreService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/entities/Offre.dart';
import 'package:khedma/entities/User.dart';

import '../theme/AppTheme.dart';
import 'Sections/OffresSection.dart';
import 'Sheets/ShowBottomSheet2.dart';
import 'appBar/appBar.dart';

class RentalItemDetailPage extends StatelessWidget {
  final int demandId;
  final String imageUrl;
  final String title;
  final String date;
  final bool evalue;
  final double budget;
  final String location;
  final String ownerName;
  final String userEmail;
  final String phoneNumber;
  final String userImage; // Added for owner's image
  final String statut;
  final String description;
  const RentalItemDetailPage({
    Key? key,
    required this.demandId,
    required this.description,
    required this.imageUrl,
    required this.phoneNumber,
    required this.userEmail,
    required this.title,
    required this.date,
    required this.evalue,
    required this.budget,
    required this.location,
    required this.ownerName,
    required this.userImage,
    required this.statut,

  }) : super(key: key);





  @override
  Widget build(BuildContext context) {
    OffreService offreService = OffreService();
    print(phoneNumber);
    return Scaffold(
      backgroundColor: AppTheme.grey,
      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.notifications, color: Colors.white),
        title: 'Espace Demandes',
        showSearchBar: false,
        backgroundColor: AppTheme.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.0),
            Center(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w), // Vertical and horizontal padding
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black, // Start with black
                      Colors.grey[850]!,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10, // Increased blur radius for a smoother shadow
                      offset: Offset(0, 4), // Slightly larger vertical offset
                    ),
                  ],
                ),
                child: Text(
                  "Détails de la Demande",
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp, // Font size for emphasis
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white,
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20.0),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 600.0,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              imageUrl,
                              width: double.infinity,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: Text(
                              title,
                              style: GoogleFonts.roboto(
                                fontSize: 14.19.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description:',
                                style: GoogleFonts.roboto(
                                    fontSize: 12.42.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                description,
                                style: GoogleFonts.roboto(
                                  fontSize: 12.42.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Besoin d’un expert.',
                            style: GoogleFonts.roboto(
                              fontSize: 12.42.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 8.0), // Adding space between texts
                          Row(
                            children: [
                              Text(
                                'Budget: ',
                                style: GoogleFonts.roboto(
                                  fontSize: 12.42.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Image.asset(
                                "assets/icons/tokenicon.png",
                                width: 20.w, // Set an appropriate size for the icon
                                height: 20.h,
                              ),
                              SizedBox(width: 4.w), // Space between icon and text
                              Text(
                                budget.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 12.42.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 18.r,
                                backgroundImage: FileImage(File(userImage)),
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ownerName,
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, color: Colors.blue, size: 14.sp),
                                        SizedBox(width: 4.0),
                                        Expanded(
                                          child: Text(
                                            location,
                                            style: GoogleFonts.roboto(
                                              fontSize: 12.sp,
                                              color: Colors.grey[600],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        Icon(Icons.phone, color: Colors.blue, size: 14.sp),
                                        SizedBox(width: 4.0),
                                        Text(
                                          phoneNumber,
                                          style: GoogleFonts.roboto(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        Icon(Icons.email, color: Colors.blue, size: 14.sp),
                                        SizedBox(width: 4.0),
                                        Text(
                                          userEmail,
                                          style: GoogleFonts.roboto(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 16.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () {
                                showAddOffreBottomSheet(context, demandId);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Proposer une offre',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12.sp, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: 8.w),
                                  Image.asset("assets/icons/offre.png",
                                      height: 16.sp, width: 16.sp),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
