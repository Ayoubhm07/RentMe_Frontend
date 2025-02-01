import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:khedma/Services/MinIOService.dart';

import '../../theme/AppTheme.dart';
import '../RentalItemDetailPage.dart';

class RentalItemCardDisponibleOffre extends StatefulWidget {
  final int demandId;
  final String imageUrl;
  final String title;
  final String date;
  final bool evalue;
  final double budget;
  final String location;
  final String ownerName;
  final String statut;
  final String description;
  final String userEmail;
  final String phoneNumber;
  final String userImage;



  const RentalItemCardDisponibleOffre({
    Key? key,
    required this.demandId,
    required this.userEmail,
    required this.userImage,
    required this.phoneNumber,
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.location,
    required this.ownerName,
    required this.date,
    required this.evalue,
    required this.budget,
    required this.statut,
  }) : super(key: key);

  @override
  _RentalItemCardDisponibleOffreState createState() =>
      _RentalItemCardDisponibleOffreState();
}

class _RentalItemCardDisponibleOffreState extends State<RentalItemCardDisponibleOffre> {
  int period = 1;
  int price = 20;

  MinIOService minIOService = MinIOService();
  String? userProfileImage;


  Future<void> _fetchUserProfileImage() async {
    try {
      String objectName = widget.userImage.replaceFirst('images_', '');
      String filePath = await minIOService.LoadFileFromServer('images', objectName);
      setState(() {
        userProfileImage = filePath;
      });
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
  }



  @override
  void initState() {
    super.initState();
    _fetchUserProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentalItemDetailPage(
              demandId: widget.demandId,
              description: widget.description,
              imageUrl: widget.imageUrl,
              userEmail: widget.userEmail,
              phoneNumber: widget.phoneNumber,
              userImage: userProfileImage ?? "",
              title: widget.title,
              date: widget.date,
              evalue: widget.evalue,
              budget: widget.budget,
              location: widget.location,
              ownerName: widget.ownerName,
              statut: widget.statut,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  widget.imageUrl,
                  width: double.infinity,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10.h),
              // Profile picture and owner name
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundImage: userProfileImage != null
                        ? FileImage(File(userProfileImage!))
                        : AssetImage("assets/images/default_avatar.png") as ImageProvider,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      widget.ownerName,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Title
              Text(
                widget.title,
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              // Date and description
              Row(
                children: [
                  Icon(Icons.date_range, color: Colors.blue, size: 18.sp),
                  SizedBox(width: 6.w),
                  Text(
                    widget.date,
                    style: GoogleFonts.roboto(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.description, color: Colors.blue, size: 18.sp),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      widget.description,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              // Budget section
              Row(
                children: [
                  Image.asset("assets/icons/tokenicon.png", width: 22.w),
                  SizedBox(width: 6.w),
                  Text(
                    "Budget: ${widget.budget.toStringAsFixed(2)}",
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              // Status
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: widget.statut == 'open' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  widget.statut.toUpperCase(),
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.statut == 'open' ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
