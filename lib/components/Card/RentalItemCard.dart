import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import '../../Services/ConversationAndMessageService.dart';
import '../../Services/UserService.dart';
import '../../entities/Conversation.dart';
import '../../entities/User.dart';
import '../../screens/ChatMessage.dart';
import '../../screens/CheckProfile.dart';

class RentalItemCardDisponible extends StatefulWidget {
  final int locationId;
  final String images;
  final String userImage;
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
  final int userId;

  const RentalItemCardDisponible({
    Key? key,
    required this.locationId,
    required this.userImage,
    required this.images,
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
    required this.userId,
  }) : super(key: key);

  @override
  _RentalItemCardDisponibleState createState() => _RentalItemCardDisponibleState();
}

class _RentalItemCardDisponibleState extends State<RentalItemCardDisponible> {
  MinIOService minIOService = MinIOService();
  String? userProfileImage;
  List<String> imageUrls = [];
  int _currentImageIndex = 0;
  int? currentUserId;
  SharedPrefService sharedPrefService = SharedPrefService();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _fetchUserProfileImage();
    _loadLocationImages();
    print(widget.userId);
  }

  Future<void> getCurrentUser() async {
    User user= await sharedPrefService.getUser();
    currentUserId = user.id;
  }

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
          String response = await minIOService.LoadFileFromServer('images', imageName);
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
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.r),
        onTap: () {
          // Action au clic de la carte (optionnel)
        },
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carrousel d'images
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
              SizedBox(height: 12.h),
              // Titre
              Text(
                widget.title,
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              // Description
              Text(
                widget.description,
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              // Catégorie (location)
              Row(
                children: [
                  Icon(Icons.category, size: 16.sp, color: Colors.blue),
                  SizedBox(width: 4.w),
                  Text(
                    'Catégorie: ${widget.location}',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Prix
              Row(
                children: [
                  Image.asset("assets/icons/tokenicon.png", width: 20.w),
                  SizedBox(width: 4.w),
                  Text(
                    'Prix: ${widget.price}',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Section profil de l'utilisateur
              InkWell(
                onTap: () {
                  // Navigation vers le profil de l'utilisateur
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckProfile(userId: widget.userId),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(30.r),
                splashColor: Colors.blue.withOpacity(0.1),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18.r,
                        backgroundImage: userProfileImage != null
                            ? FileImage(File(userProfileImage!))
                            : AssetImage("assets/images/img_6.png") as ImageProvider,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Profil de",
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              widget.ownerName,
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              // Informations de contact
              _buildContactInfo(Icons.phone, widget.phoneNumber),
              _buildContactInfo(Icons.email, widget.userEmail),
              _buildContactInfo(Icons.location_on, widget.address),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.message,
                    label: 'Contacter',
                    color: Colors.green,
                    onPressed: () async {
                       await _handleMessageClick(context, senderId: currentUserId ?? 0, receiverId: widget.userId);
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.shopping_cart,
                    label: 'Louer',
                    color: Colors.blue,
                    onPressed: widget.onRentPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: Colors.blue),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour construire un bouton d'action
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16.sp, color: Colors.white),
      label: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 12.sp,
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}