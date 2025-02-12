import 'dart:core';
import 'dart:core';
import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:khedma/Services/LocationService.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'package:khedma/Services/OffreLocationService.dart';
import 'package:khedma/Services/OffreService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/entities/OffreLocation.dart';

import '../../Services/ConversationAndMessageService.dart';
import '../../entities/Conversation.dart';
import '../../entities/User.dart';
import '../../screens/ChatMessage.dart';
import '../Sheets/ShowModifyLocationBottomSheet.dart';
import 'ConfirmationNotficationCard.dart';
import 'SuccessNotificationCard.dart';

class RentalItemCardHistorique2 extends StatefulWidget {
  final int userId;
  final String images;
  final String title;
  final String category;
  final String price;
  final String location;
  final String ownerName;
  final int locationId;
  final String timeUnit;
  final String userImage;

  const RentalItemCardHistorique2({
    Key? key,
    required this.userId,
    required this.userImage,
    required this.images,
    required this.title,
    required this.category,
    required this.price,
    required this.location,
    required this.ownerName,
    required this.locationId,
    required this.timeUnit,

  }) : super(key: key);

  @override
  _RentalItemCardHistorique2State createState() => _RentalItemCardHistorique2State();
}

class _RentalItemCardHistorique2State extends State<RentalItemCardHistorique2> {
  bool _isExpanded = false;
  List<OffreLocation> _offers = [];
  Map<int, String> _userNames = {};
  UserService userService = UserService();
  LocationService locationService= LocationService();
  OffreLocationService offreLocationService= OffreLocationService();
  MinIOService minIOService = MinIOService();
  String? userProfileImage;
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
  void initState() {
    super.initState();
    _loadOffers();
    _fetchUserProfileImage();
    _loadLocationImages();
  }




  void _handleCancelPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Êtes-vous sûr de vouloir supprimer cette demande de location ?',
          logoPath: 'assets/images/logo.png',
          onConfirm: () async {
            Navigator.of(context).pop(); // Close the dialog first
            try {
              await LocationService().deleteLocation(widget.locationId);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Votre demande de location a été supprimée',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/check1.png',
                  );
                },
              );
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            } catch (error) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Erreur lors de la suppression de votre demande de location!',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/echec.png',
                  );
                },
              );
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }
          },
          onCancel: () {
            Navigator.of(context).pop(); // Simply close the dialog on cancel
          },
        );
      },
    );
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

  Future<void> _loadOffers() async {
    OffreLocationService offreLocationService = OffreLocationService();
    try {
      _offers = await offreLocationService.getOffersByLocationIdAndStatus(widget.locationId,"pending");
      await _loadUserNames();
      setState(() {});
    } catch (e) {
      print('Failed to load offers: $e');
    }
  }

  Future<void> _loadUserNames() async {
    for (var offer in _offers) {
      User user = await userService.findUserById(offer.userId);
      _userNames[offer.userId] = user.userName;
    }
  }

  Future<void> _acceptOffer(int offerId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Voulez-vous accepter cette offre ?',
          logoPath: 'assets/images/logo.png', // Replace with your actual logo path
          onConfirm: () async {
            Navigator.of(context).pop(); // Close the ConfirmationDialog
            try {
              await locationService.updateLocationStatus(widget.locationId);
              await offreLocationService.acceptOffer(offerId);
              print('Offer accepted and location status updated');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Offre acceptée avec succès!',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/check1.png',
                  );
                },
              );
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(); // Close SuccessDialog
                Navigator.of(context).pop(); // Close ErrorDialog
                Navigator.of(context).pop(); // Close ErrorDialog
              });
            } catch (e) {
              print('Error accepting offer: $e');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Erreur lors de l\'acceptation de l\'offre: $e',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/echec.png',
                  );
                },
              );
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop();
                // Close ErrorDialog
              });
            }
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }


  Future<void> _rejectOffer(int offerId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Voulez-vous rejeter cette offre ?',
          logoPath: 'assets/images/logo.png', // Replace with your actual logo path
          onConfirm: () async {
            Navigator.of(context).pop(); // Close the ConfirmationDialog
            try {
              await offreLocationService.rejectOffer(offerId);
              print('Offer rejected');
              await _loadOffers();
              // Optionally show success feedback
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Offre rejetée avec succès!',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/check1.png',
                  );
                },
              );
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(); // Close SuccessDialog
                Navigator.of(context).pop(); // Close SuccessDialog
              });
            } catch (e) {
              print('Error rejecting offer: $e');
              // Optionally show error feedback
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Erreur lors du rejet de l\'offre: $e',
                    logoPath: 'assets/images/logo.png',
                    iconPath: 'assets/icons/echec.png',
                  );
                },
              );
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(); // Close ErrorDialog
              });
            }
          },
          onCancel: () {
            Navigator.of(context).pop(); // Close the ConfirmationDialog
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(8.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          color: Colors.white.withOpacity(0.9),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Section texte
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre de la demande
                          Text(
                            widget.title,
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Emplacement
                          Row(
                            children: [
                              Icon(Icons.book_online_outlined, color: Colors.blue, size: 20.sp),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Text(
                                  widget.location,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // Prix
                          Row(
                            children: [
                              Image.asset("assets/icons/tokenicon.png", width: 20),
                              SizedBox(width: 4.w),
                              Text(
                                widget.price,
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),

                    // Actions : Modifier et Supprimer
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange, size: 24.sp),
                          tooltip: "Modifier la demande",
                          onPressed: () {
                            showModifyLocationBottomSheet(context, widget.locationId);
                            print("Modifier la demande : ${widget.title}");
                          },
                        ),

                        SizedBox(width: 8.w),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 24.sp),
                          tooltip: "Supprimer la demande",
                          onPressed: () => _handleCancelPressed(context),
                        ),
                      ],
                    ),
                  ],
                ),

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
                      child: Text(
                        widget.ownerName,
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        "Liste des offres de locations",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  initiallyExpanded: _isExpanded,
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _isExpanded = expanded;
                    });
                  },
                  iconColor: themeData.primaryColor,
                  collapsedIconColor: Colors.grey,
                  backgroundColor: Colors.white,
                  collapsedBackgroundColor: Colors.grey[200],
                  childrenPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: _offers.map((offer) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOfferRow(
                              icon: Icons.euro_symbol,
                              label: "Prix:",
                              value: "${offer.price} jetons",
                              themeColor: themeData.primaryColor,
                            ),
                            SizedBox(height: 8),
                            _buildOfferRow(
                              icon: Icons.date_range,
                              label: "Période:",
                              value: "${offer.periode}",
                              themeColor: themeData.primaryColor,
                            ),
                            SizedBox(height: 8),
                            _buildOfferRow(
                              icon: Icons.person_outline,
                              label: "Posté par:",
                              value: "${_userNames[offer.userId] ?? 'Inconnu'}",
                              themeColor: themeData.primaryColor,
                            ),
                            SizedBox(height: 8),
                            _buildOfferRow(
                              icon: Icons.pending_actions,
                              label: "Statut:",
                              value: "Offre en attente",
                              themeColor: themeData.primaryColor,
                            ),
                            Divider(color: Colors.grey[300], thickness: 1.0, height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildActionIcon(
                                  icon: Icons.check_circle_outline,
                                  color: Colors.green,
                                  tooltip: 'Accepter',
                                  onPressed: () => _acceptOffer(offer.id ?? 0),
                                ),
                                _buildActionIcon(
                                  icon: Icons.cancel_outlined,
                                  color: Colors.red,
                                  tooltip: 'Rejeter',
                                  onPressed: () => _rejectOffer(offer.id ?? 0),
                                ),
                                _buildActionIcon(
                                  icon: Icons.chat_bubble_outline,
                                  color: Colors.blue,
                                  tooltip: 'Contactez le postulant',
                                  onPressed: () async {
                                    await _handleMessageClick(context, senderId: widget.userId, receiverId: offer.userId);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildOfferRow({
    required IconData icon,
    required String label,
    required String value,
    required Color themeColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: themeColor),
        SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 24),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
