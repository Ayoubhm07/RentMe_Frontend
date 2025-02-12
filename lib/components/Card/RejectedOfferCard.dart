import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/theme/AppTheme.dart';

import '../../Services/MinIOService.dart';

class RejectedOffreCard extends StatefulWidget {
  final String userImage;
  final int locationId;
  final String images;
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

  const RejectedOffreCard({
    Key? key,
    required this.userImage,
    required this.images,
    required this.locationId,
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
  _RejectedOffreCardState createState() => _RejectedOffreCardState();
}

class _RejectedOffreCardState extends State<RejectedOffreCard> {
  MinIOService minioService = MinIOService();
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
    _loadLocationImages();
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
                  widget.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  widget.dateDebut.toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF585858),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  widget.description,
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
                              backgroundImage: widget.userImage != null
                                  ? FileImage(File(widget.userImage!))
                                  : AssetImage("assets/images/default_avatar.png") as ImageProvider,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                widget.ownerName,
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
                              'Durée: ${widget.paiement}',
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
                              'Budget: ${widget.budget}',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Statut : ${widget.location}",
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
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
