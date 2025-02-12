import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Services/MinIOService.dart';
import '../../Services/OffreLocationService.dart';
import '../../Services/UserService.dart';
import '../../entities/OffreLocation.dart';
import '../../entities/User.dart';
import 'AcceptedOfferDetailsCard.dart';


class RentalItemCardHistorique extends StatefulWidget {
  final String images;
  final String title;
  final String price;
  final String location;
  final String ownerName;
  final int locationId;
  final VoidCallback onContactPressed;
  final VoidCallback onRentPressed;
  final String userImage;

  const RentalItemCardHistorique({
    Key? key,
    required this.userImage,
    required this.locationId,
    required this.images,
    required this.title,
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
  MinIOService minioService = MinIOService();
  String? userProfileImage;
  List<String> imageUrls = [];
  int _currentImageIndex = 0;

  Future<void> _loadLocationImages() async {
    try {
      print("Images reçues :");
      print(widget.images);
      String imagePrefix = 'location{${widget.locationId}}';
      print(imagePrefix);

      List<String> widgetImages = widget.images.split(',');
      List<String> cleanedImageNames = widgetImages
          .map((imageName) => imageName.replaceFirst('images_', '')) // Enlever 'images_' des noms
          .where((imageName) => imageName.startsWith(imagePrefix)) // Filtrer les images par préfixe
          .toList();
      print(cleanedImageNames);

      if (cleanedImageNames.isNotEmpty) {
        List<String> downloadedImagePaths = [];
        for (String imageName in cleanedImageNames) {
          String response = await minioService.LoadFileFromServer('images', imageName);
          if (response.isNotEmpty) {
            downloadedImagePaths.add(response);
          } else {
            print('❌ Image non trouvée pour : $imageName');
          }
        }
        if (downloadedImagePaths.isNotEmpty) {
          if (mounted) {
            setState(() {
              imageUrls = downloadedImagePaths;
            });
          }
        } else {
          print('⚠️ Aucune image récupérée pour location ID : ${widget.locationId}');
        }
      } else {
        print('⚠️ Aucune image correspondant à location ID : ${widget.locationId}');
      }
    } catch (e) {
      print('❌ Erreur lors du chargement des images de la location : $e');
    }
  }


  @override
  void initState() {
    super.initState();
    _loadOffers();
    _fetchUserProfileImage();
    _loadLocationImages();
  }

  Future<void> _fetchUserProfileImage() async {
    try {
      String objectName = widget.userImage.replaceFirst('images_', '');
      String filePath = await minioService.LoadFileFromServer('images', objectName);
      setState(() {
        userProfileImage = filePath;
      });
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
  }

  Future<void> _loadUserName() async {
    if (_firstOffer != null) {
      User user = await userService.findUserById(_firstOffer!.userId);
      String username = user.userName;
      setState(() {
        _username = username;
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
          await _loadUserName();
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
                if (imageUrls.isNotEmpty)
                  Column(
                    children: [
                      CarouselSlider(
                        items: imageUrls.map((imageUrl) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.file(
                              File(imageUrl),
                              width: double.infinity,
                              height: 150.h,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 250.h,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imageUrls.asMap().entries.map((entry) {
                          return Container(
                            width: 8.w,
                            height: 8.h,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == entry.key
                                  ? Colors.blue
                                  : Colors.grey.withOpacity(0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                else
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
                SizedBox(height: 10.h),
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
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Image.asset("assets/icons/tokenicon.png", width: 20),
                    SizedBox(width: 4.w),
                    Text(
                      widget.price ,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                              backgroundImage: userProfileImage != null
                                  ? FileImage(File(userProfileImage!))
                                  : AssetImage("assets/images/user1.png") as ImageProvider,
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
                                ],
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
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(10.65.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Text(
            'Offre de location terminé',
            style: GoogleFonts.roboto(
              fontSize: 14.19.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
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



