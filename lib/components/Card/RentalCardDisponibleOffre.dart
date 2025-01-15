import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _showProposeButton = false;
  int period = 1;
  int price = 20;
  @override
  void initState() {
    super.initState();
  }
  bool _showOfferText = true;

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
              userImage: widget.userImage,
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
        margin: EdgeInsets.all(8.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  widget.imageUrl,
                  width: double.infinity,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage: FileImage(File(widget.userImage)),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      widget.ownerName,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                widget.title,
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.date_range, color: Colors.blue),
                  SizedBox(width: 8.w),
                  Text(
                    widget.date,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(Icons.description, color: Colors.blue),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      widget.description,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        color: Colors.grey[800],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Image.asset("assets/icons/tokenicon.png", width: 20),
                  SizedBox(width: 8.w),
                  Text(
                    "Budget: ${widget.budget.toStringAsFixed(2)}",
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.statut,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: widget.statut == 'open' ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
