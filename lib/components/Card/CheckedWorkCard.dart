import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Services/MinIOService.dart';

class CheckedBlogCard extends StatefulWidget {
  final int travailId;
  final String title;
  final String date;
  final String description;
  final String image;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const CheckedBlogCard({
    required this.travailId,
    required this.title,
    required this.date,
    required this.description,
    required this.image,
    required this.onEditPressed,
    required this.onDeletePressed,
    Key? key,
  }) : super(key: key);

  @override
  _CheckedBlogCardState createState() => _CheckedBlogCardState();
}

class _CheckedBlogCardState extends State<CheckedBlogCard> {
  List<String> imageUrls = [];
  int _currentImageIndex = 0;
  MinIOService minioService = MinIOService();

  @override
  void initState() {
    super.initState();
    _loadLocationImages();
  }


  Future<void> _loadLocationImages() async {
    try {
      print("Images reçues :");
      print(widget.image);
      String imagePrefix = 'travail{${widget.travailId}}';
      print(imagePrefix);

      List<String> widgetImages = widget.image.split(',');
      print(widgetImages);
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
            print('Image non trouvée pour : $imageName');
          }
        }
        if (downloadedImagePaths.isNotEmpty) {
          if (mounted) {
            setState(() {
              imageUrls = downloadedImagePaths;
            });
          }
        } else {
          print('Aucune image récupérée pour location ID : ${widget.travailId}');
        }
      } else {
        print('Aucune image correspondant à location ID : ${widget.travailId}');
      }
    } catch (e) {
      print('Erreur lors du chargement des images de la location : $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF2F8FF)], // Dégradé doux
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre et icônes (modifier/supprimer)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          // Date
          Text(
            widget.date,
            style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          // Description
          Text(
            widget.description,
            style: GoogleFonts.roboto(fontSize: 14, color: Colors.black87),
          ),
          SizedBox(height: 8),
          // Image/Video
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
                    height: 130.h,
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
                SizedBox(height: 12.h),
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

        ],
      ),
    );
  }
}