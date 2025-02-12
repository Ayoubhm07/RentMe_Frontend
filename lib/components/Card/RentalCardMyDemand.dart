import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/components/RentalItemMyDemandDetails.dart';

class RentalItemCardMyDemand extends StatefulWidget {
  final int demandId;
  final String imageUrl;
  final String title;
  final String date;
  final bool evalue;
  final double budget;
  final String location;
  final String description;
  final String userImage;
  final String ownerName;
  final String statut;

  const RentalItemCardMyDemand({
    Key? key,
    required this.userImage,
    required this.demandId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.ownerName,
    required this.date,
    required this.evalue,
    required this.budget,
    required this.statut,
  }) : super(key: key);

  @override
  _RentalItemCardMyDemandState createState() => _RentalItemCardMyDemandState();
}

class _RentalItemCardMyDemandState extends State<RentalItemCardMyDemand> {
  @override
  Widget build(BuildContext context) {
    bool isClosed = widget.statut.toLowerCase() == 'closed';
    return GestureDetector(
      onTap: isClosed ? null : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentalItemMyDemandDetails(
              demandId: widget.demandId,
              description: widget.description,
              imageUrl: widget.imageUrl,
              title: widget.title,
              date: widget.date,
              evalue: widget.evalue,
              budget: widget.budget,
              ownerName: widget.ownerName,
              statut: widget.statut,
              ownerImageUrl: widget.userImage,
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
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  color: Colors.black12, // Fond blanc
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: double.infinity,
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundImage: widget.userImage != null
                        ? FileImage(File(widget.userImage!))
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
