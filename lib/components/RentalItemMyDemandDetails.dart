import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/DemandeService.dart';
import 'package:khedma/components/Sections/MyDemandOffersSection.dart';
import 'package:collection/collection.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

import '../Services/OffreService.dart';
import '../Services/ProfileService.dart';
import '../Services/SharedPrefService.dart';
import '../Services/UserService.dart';
import '../entities/Offre.dart';
import '../entities/ProfileDetails.dart';
import '../entities/User.dart';
import '../theme/AppTheme.dart';
import 'Card/ConfirmationNotficationCard.dart';
import 'Card/DemandAcceptedOfferCard.dart';
import 'Card/SuccessNotificationCard.dart';
import 'appBar/appBar.dart';
import '../components/Sheets/showBottomSheet.dart';

class RentalItemMyDemandDetails extends StatelessWidget {
  final int demandId;
  final String imageUrl;
  final String title;
  final String date;
  final bool evalue;
  final double budget;
  final String description;
  final String ownerName;
  final String ownerImageUrl;
  final String statut;

  const RentalItemMyDemandDetails({
    Key? key,
    required this.demandId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
    required this.evalue,
    required this.budget,
    required this.ownerName,
    required this.ownerImageUrl,
    required this.statut,
  }) : super(key: key);

  void _handleCancelPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Êtes-vous sûr de vouloir supprimer cette demande ?',
          logoPath: 'assets/images/logo.png',
          onConfirm: () async {
            Navigator.of(context).pop();
            try {
              await DemandeService().deleteDemande(demandId);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: 'Votre demande a été supprimée',
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
                    message: 'Erreur lors de la suppression de votre demande!',
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
  @override
  Widget _buildNoOffersCard() {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 50.0, color: Colors.grey[600]),
            SizedBox(height: 16.0),
            Text(
              'Pas d\'offres encore pour cette demande',
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemandDetailsCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 8.0, // Ombre plus prononcée
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Bordures arrondies
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec bordure arrondie
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
            SizedBox(height: 20.0),

            // Titre centré
            Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Description
            Text(
              'Description: $description',
              style: GoogleFonts.poppins(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),


            SizedBox(height: 16.0),

            // Budget
            Row(
              children: [
                Text(
                  'Budget: ',
                  style: GoogleFonts.poppins(
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Image.asset(
                  "assets/icons/tokenicon.png",
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  budget.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

              ],
            ),

            SizedBox(height: 16.0),

            // Date
            Text(
              'Ajoutée le: $date',
              style: GoogleFonts.poppins(
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 24.0),

            // Propriétaire
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: FileImage(File(ownerImageUrl)),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Propriétaire',
                      style: GoogleFonts.poppins(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      ownerName,
                      style: GoogleFonts.poppins(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.0),

            // Boutons Modifier et Supprimer
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bouton Modifier
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEEA41D), // Couleur orange
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 4.0, // Ombre du bouton
                    ),
                    onPressed: () => showEditBottomSheet(context, idDemand: demandId),
                    icon: Icon(Icons.edit, size: 16.sp, color: Colors.white),
                    label: Text(
                      'Modifier',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // Bouton Supprimer
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Couleur rouge
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 4.0, // Ombre du bouton
                    ),
                    onPressed: () => _handleCancelPressed(context),
                    icon: Icon(Icons.delete, size: 16.sp, color: Colors.white),
                    label: Text(
                      'Supprimer',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();
    OffreService offreService = OffreService();

    return Scaffold(
      backgroundColor: AppTheme.brightBlue,
      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.notifications, color: Colors.white),
        title: 'Consultez Votre Demande',
        showSearchBar: false,
        backgroundColor: AppTheme.brightBlue,
      ),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                SizedBox(height: 16.0),
                _buildDemandDetailsCard(context),
                FutureBuilder<List<Offre>>(
                  future: offreService.getOffersByDemand(demandId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          margin: EdgeInsets.all(16.0),
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      Offre? acceptedOffer = snapshot.data!.firstWhereOrNull(
                              (offer) => offer.status == OfferStatus.accepted
                      );

                      if (acceptedOffer != null) {
                        return FutureBuilder<User>(
                          future: userService.findUserById(acceptedOffer.userId),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              );
                            } else if (userSnapshot.hasError) {
                              return Text('Error fetching user: ${userSnapshot.error}');
                            } else if (userSnapshot.hasData) {
                              return DemandAcceptedOfferCard(
                                benifId: acceptedOffer.userId,
                                userName: userSnapshot.data!.userName,
                                userImage: "",
                                acceptedAt: acceptedOffer.acceptedAt,
                                duration: acceptedOffer.periode,
                                price: acceptedOffer.price,
                                demandId: acceptedOffer.demandId,
                              );
                            } else {
                              return Text("User data not available.");
                            }
                          },
                        );
                      }

                      List<Offre> pendingOffers = snapshot.data!.where(
                              (offer) => offer.status == OfferStatus.pending
                      ).toList();

                      return MyDemandOffersSection(offers: pendingOffers);
                    } else {
                      return _buildNoOffersCard();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}