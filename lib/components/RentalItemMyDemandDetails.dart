import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/DemandeService.dart';
import 'package:khedma/components/Sections/MyDemandOffersSection.dart';
import 'package:collection/collection.dart';

import '../Services/OffreService.dart';
import '../Services/ProfileService.dart';
import '../Services/SharedPrefService.dart';
import '../Services/UserService.dart';
import '../entities/Offre.dart';
import '../entities/ProfileDetails.dart';
import '../entities/User.dart';
import '../theme/AppTheme.dart';
import 'Card/DemandAcceptedOfferCard.dart';
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
    print(demandId);
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Confirm"),
        content: Text("Are you sure you want to delete this demand?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog first
              try {
                await DemandeService().deleteDemande(demandId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Demand deleted successfully')),
                );
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete: $error')),
                );
              }
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();
    OffreService offreService = OffreService();

    return Scaffold(
      backgroundColor: AppTheme.grey,
      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.notifications, color: Colors.white),
        title: 'Espace Demandes',
        showSearchBar: false,
        backgroundColor: AppTheme.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.0),
          Center(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w), // Vertical and horizontal padding
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black, // Start with black
                    Colors.grey[850]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10, // Increased blur radius for a smoother shadow
                    offset: Offset(0, 4), // Slightly larger vertical offset
                  ),
                ],
              ),
              child: Text(
                "Détails de la Demande",
                style: GoogleFonts.roboto(
                  fontSize: 20.sp, // Font size for emphasis
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 10.0),
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white,
                  elevation: 4.0, // Optional: for shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20.0), // Optional: rounded corners
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 600.0, // Set a maximum width for the card
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              imageUrl,
                              width: double.infinity,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: Text(
                              title,
                              style: GoogleFonts.roboto(
                                fontSize: 14.19.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description:',
                                style: GoogleFonts.roboto(
                                  fontSize: 12.42.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                description,
                                style: GoogleFonts.roboto(
                                  fontSize: 12.42.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Besoin d’un expert.',
                            style: GoogleFonts.roboto(
                              fontSize: 12.42.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 8.0), // Adding space between texts
                          Row(
                            children: [
                              Text(
                                'Budget: ',
                                style: GoogleFonts.roboto(
                                  fontSize: 12.42.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Image.asset(
                                "assets/icons/tokenicon.png",
                                width: 20.w, // Set an appropriate size for the icon
                                height: 20.h,
                              ),
                              SizedBox(width: 4.w), // Space between icon and text
                              Text(
                                budget.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 12.42.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40.0),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18.r,
                                backgroundImage: FileImage(File(ownerImageUrl)),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                ownerName,
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20.0),
                          Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEEA41D),
                                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onPressed: () => showEditBottomSheet(context,idDemand: demandId),
                                    icon: Icon(Icons.edit, size: 16.sp, color: Colors.white),
                                    label: Text(
                                      'Modifier',
                                      style: GoogleFonts.roboto(fontSize: 12.sp, color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 10.w), // Space between buttons
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onPressed: () => _handleCancelPressed(context),  // Corrected handler invocation
                                    icon: Icon(Icons.cancel, size: 16.sp, color: Colors.white),
                                    label: Text(
                                      'Supprimer',
                                      style: GoogleFonts.roboto(fontSize: 12.sp, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            FutureBuilder<List<Offre>>(
              future: offreService.getOffersByDemand(demandId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  // Search for an accepted offer
                  Offre? acceptedOffer = snapshot.data!.firstWhereOrNull(
                          (offer) => offer.status == OfferStatus.accepted
                  );

                  if (acceptedOffer != null) {
                    return FutureBuilder<User>(
                      future: userService.findUserById(acceptedOffer.userId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
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
                  return Text("No offers available.");
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}




