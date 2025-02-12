import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Services/ConversationAndMessageService.dart';
import '../../Services/MinIOService.dart';
import '../../Services/UserService.dart';
import '../../entities/Conversation.dart';
import '../../entities/User.dart';
import '../../screens/ChatMessage.dart';

class AcceptedOfferCard extends StatefulWidget {
  final int userId ;
  final int receiverId;
  final String userImage;
  final String images;
  final int locationId;
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
    required this.userId,
    required this.receiverId,
    required this.userImage,
    required this.images,
    required this.locationId,
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
  _AcceptedOfferCardState createState() => _AcceptedOfferCardState();
}

class _AcceptedOfferCardState extends State<AcceptedOfferCard> {
  MinIOService minioService = MinIOService();
  List<String> imageUrls = [];
  int _currentImageIndex = 0;

  Future<void> _handleMessageClick(BuildContext context, {required int senderId, required int receiverId}) async {
    try {
      User currentUser = await UserService().findUserById(senderId);
      User receiver = await UserService().findUserById(receiverId);

      if (senderId == null || receiverId == null) {
        throw Exception("senderId ou receiverId est null");
      }

      ConversationAndMessageService service = ConversationAndMessageService();
      Conversation conversation = await service.createConversation(
        senderId,
        [receiverId],
      );

      int conversationId = conversation.id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatMessagePage(
            conversationId: conversationId,
            receiver: receiver,
            currentUser: currentUser,
          ),
        ),
      );
    } catch (e) {
      print("Erreur lors de la création de la conversation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de la création de la conversation: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


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
          color: Colors.white.withOpacity(0.9),
          elevation: 4,
          shadowColor: const Color(0x3F000000),
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
                    child: Container(
                      color: Colors.white, // Fond blanc
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: double.infinity,
                        height: 200.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 10.h),
                Text(
                  widget.title,
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Date de création : ${widget.dateDebut.toString()}",
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  widget.description,
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
                    IconButton(
                      icon: Icon(Icons.chat, color: Colors.blue[300], size: 24.sp),
                      onPressed: () async {
                        await _handleMessageClick(context, senderId: widget.userId, receiverId: widget.receiverId);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.timer, size: 18.sp, color: Colors.blue),
                    SizedBox(width: 4.w),
                    Text(
                      'Durée: ${widget.duree}',
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
      Row(
        children: [
          Icon(Icons.date_range, size: 18.sp, color: Colors.blue),
          SizedBox(width: 4.w),
          Text(
            'Date de début: ${widget.dateDebut.toString()}',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ],
      ),
                SizedBox(height: 10.h),
                Text(
                  "Statut : ${widget.status}",
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
                      onPressed: widget.onTerminerPressed,
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
