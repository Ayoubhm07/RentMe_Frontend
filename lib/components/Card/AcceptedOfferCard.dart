import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AcceptedOfferCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String dateDebut;
  final String dateDemand;
  final String budget;
  final String duree;
  final String ownerName;
  final String status;
  final VoidCallback onTerminerPressed;
  final VoidCallback onChatPressed;
  final VoidCallback onEditPressed;

  const AcceptedOfferCard({
    Key? key,
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.dateDebut,
    required this.dateDemand,
    required this.status,
    required this.budget,
    required this.duree,
    required this.ownerName,
    required this.onTerminerPressed,
    required this.onChatPressed,
    required this.onEditPressed,
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
          color: Colors.white.withOpacity(0.9),
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
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Date de création : ${dateDebut.toString()}",
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  description,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
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
                      backgroundImage: AssetImage("assets/images/img_6.png"),
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
                    IconButton(
                      icon: Icon(Icons.chat, color: Colors.blue[300], size: 24.sp),
                      onPressed: onChatPressed,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.timer, size: 18.sp, color: Colors.blue),
                    SizedBox(width: 4.w),
                    Text(
                      'Durée: $duree',
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
      Row(
        children: [
          Icon(Icons.date_range, size: 18.sp, color: Colors.blue),
          SizedBox(width: 4.w),
          Text(
            'Date de début: ${dateDebut.toString()}',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ],
      ),
                SizedBox(height: 10.h),
                Text(
                  "Statut : $status",
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: onTerminerPressed,
                      icon: Icon(Icons.check_circle, size: 16.sp, color: Colors.white),
                      label: Text(
                        'Terminer',
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
