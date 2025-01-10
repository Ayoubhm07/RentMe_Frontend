import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/DemandeService.dart';
import 'package:khedma/components/Sections/MyDemandOffersSection.dart';
import 'package:collection/collection.dart';

import '../Services/OffreService.dart';
import '../Services/UserService.dart';
import '../entities/Offre.dart';
import '../entities/User.dart';
import '../theme/AppTheme.dart';
import 'Card/DemandAcceptedOfferCard.dart';
import 'appBar/appBar.dart';

class RentalItemMyDemandDetails extends StatelessWidget {
  final int demandId;
  final String imageUrl;
  final String title;
  final String date;
  final bool evalue;
  final double budget;
  final String location;
  final String ownerName;
  final String ownerImageUrl; // Added for owner's image
  final bool statut;

  const RentalItemMyDemandDetails({
    Key? key,
    required this.demandId,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.evalue,
    required this.budget,
    required this.location,
    required this.ownerName,
    required this.ownerImageUrl, // Added for owner's image
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
                Navigator.of(context).pop(); // Optionally navigate back
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
      backgroundColor: AppTheme.primaryColor,
      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.notifications, color: Colors.white),
        title: 'Espace Demandes',
        showSearchBar: false,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView( // Scroll view added in case of overflow
        child: Column(
          children: [
            SizedBox(height: 16.0), // Adds spacing between AppBar and Text
          Center(
            child: Container(
              width: double.infinity, // Assure that the container fills the horizontal space
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w), // Vertical and horizontal padding
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.deepPurple[300]!, Colors.deepPurple[700]!], // Gradient effect from lighter to darker purple
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: Offset(0, 2), // Shadow positioned below the container
                  ),
                ],
              ),
              child: Text(
                "Détails de la Demande",
                style: GoogleFonts.roboto(
                  fontSize: 20.sp, // Font size for emphasis
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color for contrast against the gradient
                ),
                textAlign: TextAlign.center, // Centers the text horizontally in the container
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
                            // Set the radius for the corners
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
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Construction d’une maison à deux étages sur 250m², avec un jardin et une piscine.',
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
                          SizedBox(height: 40.0),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(ownerImageUrl),
                                radius: 20.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                ownerName,
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Column( // Correctly using Column here to wrap the Rows
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        color: Colors.blue, size: 18.sp),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        location,
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
                                SizedBox(height: 8.0),
                                // Adding spacing between rows
                                Row(
                                  children: [
                                    Icon(Icons.phone, color: Colors.blue,
                                        size: 18.sp),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "+99-888-333-322",
                                      style: GoogleFonts.roboto(
                                        fontSize: 12.sp,
                                        color: Color(0xFF0C3469),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                // Adding spacing between rows
                                Row(
                                  children: [
                                    Icon(Icons.alternate_email_outlined,
                                        color: Colors.blue, size: 18.sp),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "jessica.virgolini50@gmail.com",
                                      style: GoogleFonts.roboto(
                                        fontSize: 12.sp,
                                        color: Color(0xFF0C3469),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 16.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () {
                                _showBottomSheet(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEEA41D), // Or any specific color you prefer for the "Modifier" button
                                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onPressed: () {},
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
                                      'Annuler',
                                      style: GoogleFonts.roboto(fontSize: 12.sp, color: Colors.white),
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
                            userName: userSnapshot.data!.userName,
                            userImage: "",
                            acceptedAt: acceptedOffer.acceptedAt,
                            duration: acceptedOffer.periode,
                            price: acceptedOffer.price,
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

void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      int period = 1; // Local state for period (e.g., number of nights)
      int price = 20; // Local state for price

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Proposition de prix',
                          style: GoogleFonts.roboto(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  'Proposez une offre de prix afin de répondre à cette demande.',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.0), // Small left padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildIncrementDecrementWidget("Prix", price, (newPrice) {
                            setState(() {
                              price = newPrice;
                            });
                          }),
                          SizedBox(width: 10.w),
                          Padding(
                            padding: EdgeInsets.only(bottom: 0.h),
                            child: Image.asset(
                              "assets/icons/coins.png",
                              width: 50.w,
                              height: 50.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Update the global price state here if needed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 50.w),
                  ),
                  child: Text(
                    'Valider',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildIncrementDecrementWidget(
    String label, int value, Function(int) onChanged, {
      bool showCoin = false,
    }) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14.19.sp,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 8.h), // Add some space between the label and the controls
      Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the row content
        children: [
          Column(
            children: [
              Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF0099D5)),
                  borderRadius: BorderRadius.circular(6.6),
                ),
                child: Center(
                  child: IconButton(
                    iconSize: 20.w,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (value > 1) {
                        onChanged(value - 1);
                      }
                    },
                    icon: Icon(Icons.remove),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF0099D5)),
                  borderRadius: BorderRadius.circular(6.6),
                ),
                child: Center(
                  child: IconButton(
                    iconSize: 20.w,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      onChanged(value + 1);
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 5.w),
          Container(
            width: 70.w,
            height: 40.h,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 1.3),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF0099D5)),
              borderRadius: BorderRadius.circular(6),
              color: Color(0xFFF4F6F5),
              boxShadow: [
                BoxShadow(
                  color: Color(0x11124565),
                  offset: Offset(0, 4),
                  blurRadius: 7,
                ),
              ],
            ),
            child: Center(
              child: Text(
                "$value",
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}