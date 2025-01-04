import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Services/OffreLocationService.dart';
import '../../Services/UserService.dart';
import '../../entities/OffreLocation.dart';
import '../../entities/User.dart';
import 'AcceptedOfferDetailsCard.dart';


class RentalItemCardHistorique extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final String location;
  final String ownerName;
  final int locationId;
  final VoidCallback onContactPressed;
  final VoidCallback onRentPressed;

  const RentalItemCardHistorique({
    Key? key,
    required this.locationId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.ownerName,
    required this.onContactPressed,
    required this.onRentPressed,
  }) : super(key: key);

  @override
  _RentalItemCardHistoriqueState createState() => _RentalItemCardHistoriqueState();
}

class _RentalItemCardHistoriqueState extends State<RentalItemCardHistorique> {
  List<OffreLocation> _offers = [];
  OffreLocation? _firstOffer;
  UserService userService = UserService();
  String? _username;


  @override
  void initState() {
    super.initState();
    _loadOffers(); // Assurez-vous que cette méthode est appelée dans initState
  }

  Future<void> _loadUserName() async {
    if (_firstOffer != null) {
      User user = await userService.findUserById(_firstOffer!.userId);
      String username = user.userName;
      setState(() {
        _username = username; // Sauvegarder le nom d'utilisateur dans l'état du widget
      });
    }
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} à ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

    Future<void> _loadOffers() async {
      OffreLocationService offreLocationService = OffreLocationService();
      try {
        _offers = await offreLocationService.getOffersByLocationIdAndStatus(widget.locationId, 'accepted');
        if (_offers.isNotEmpty) {
          _firstOffer = _offers[0];
          await _loadUserName(); // Chargement du nom d'utilisateur après l'obtention de la première offre
        }
        setState(() {});
      } catch (e) {
        print('Failed to load offers: $e');
      }
    }


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
          shadowColor: Color(0x3F000000),
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
                SizedBox(height: 10.h),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF585858),
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
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundImage: AssetImage(
                                  "assets/images/img_6.png"),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    widget.ownerName,
                                    style: GoogleFonts.roboto(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    widget.price.toString(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        // Location Section
                        Row(
                          children: [
                            Icon(Icons.book_online_outlined, color: Colors.blue,
                                size: 18.sp),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                widget.location,
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  color: Color(0xFF0C3469),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
        sousCard(),
        if (_firstOffer != null) OfferDetailsCard(offer: _firstOffer!, username: _username!),
      ],

    );
  }
  Widget sousCard() {
    if (_firstOffer == null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        width: 350.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.65.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Text(
            'Aucune offre acceptée disponible.',
            style: GoogleFonts.roboto(
              fontSize: 14.19.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF585858),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      width: 350.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.65.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Période de location",
              style: GoogleFonts.roboto(
                fontSize: 14.19.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF585858),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Loué : ${formatDate(_firstOffer!.acceptedAt)}.',
              style: GoogleFonts.roboto(
                fontSize: 12.42.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xFF585858),
              ),
            ),
            Text(
              'Restitution : ${formatDate(_firstOffer!.finishedAt)}.',
              style: GoogleFonts.roboto(
                fontSize: 12.42.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xFF585858),
              ),
            ),
          ],
        ),
      ),
    );
  }

}



