import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RentalItemCardDisponible extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final String location;
  final String ownerName;
  final VoidCallback onContactPressed;
  final VoidCallback onRentPressed;
  final String userEmail;
  final String phoneNumber;
  final String address;

  const RentalItemCardDisponible({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.userEmail,
    required this.phoneNumber,
    required this.address,
    required this.description,
    required this.price,
    required this.location,
    required this.ownerName,
    required this.onContactPressed,
    required this.onRentPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                "assets/images/demandeLocationImage.png",
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Text(
              'Category: $location',
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Image.asset("assets/icons/tokenicon.png", width: 20),
                SizedBox(width: 4.w),
                Text(
                  '$price',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
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
                      fontSize: 13.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue),
                SizedBox(width: 4.w),
                Text(
                  phoneNumber,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 4.w),
                Text(
                  userEmail,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    address,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.message, color: Colors.white),
                  label: Text('Contacter le propriétaire',     style: TextStyle(color: Colors.white, fontSize: 10.sp) // Smaller font size
                  ),
                  onPressed: onContactPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w), // Reduced vertical padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  label: Text('Louer cet article', style: TextStyle(color: Colors.white, fontSize: 10.sp) // Smaller font size
                  ),
                  onPressed: onRentPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w), // Reduced vertical padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
