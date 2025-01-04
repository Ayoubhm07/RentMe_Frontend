import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/OffreService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/entities/Offre.dart';
import 'package:khedma/entities/User.dart';

import '../theme/AppTheme.dart';
import 'Sections/OffresSection.dart';
import 'appBar/appBar.dart';

class RentalItemDetailPage extends StatelessWidget {
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
  const RentalItemDetailPage({
    Key? key,
    required this.demandId,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.evalue,
    required this.budget,
    required this.location,
    required this.ownerName,
    required this.ownerImageUrl,
    required this.statut,

  }) : super(key: key);





  @override
  Widget build(BuildContext context) {
    OffreService offreService = OffreService();

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.notifications, color: Colors.white),
        title: 'Demande Details',
        showSearchBar: false,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20.0),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 600.0,
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
                                backgroundImage: AssetImage("assets/images/user1.png"),
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
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 16.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () {
                                _showBottomSheet(context, demandId);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Proposer une offre',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12.sp, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: 8.w),
                                  Image.asset("assets/icons/offre.png",
                                      height: 16.sp, width: 16.sp),
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
              future: offreService.getOffersByDemand(demandId), // Using OffreService to fetch offers
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return OffersSection(offers: snapshot.data!); // Use the OffersSection widget
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
void _showBottomSheet(BuildContext context, int demandId) async {
  OffreService offreService = OffreService();
  int period = 1;
  int price = 20;
  try {
    User user = await SharedPrefService().getUser();
    if (user.roles.contains("USER")) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Restricted Access"),
            content: Text("En tant que utilisateur vous ne pouvez pas proposer une offre!"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildIncrementDecrementWidget(
                          "Période(Jours)", period, (newPeriod) {
                        setState(() {
                          period = newPeriod;
                        });
                      }),
                      SizedBox(width: 20.w),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildIncrementDecrementWidget(
                              "Prix/Heure", price, (newPrice) {
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
                  ElevatedButton(
                    onPressed: () async {
                      // Création de l'objet offre
                      Offre newOffer = Offre(
                          demandId: demandId ,
                          status: OfferStatus.pending,
                          price: price,
                          periode: "$period jours",
                          acceptedAt: DateTime.now(),
                          finishedAt: DateTime.now(),
                          userId: user.id ?? 0
                      );

                      try {
                        await offreService.createOffer(newOffer);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Offre proposée avec succès!'))
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur lors de la proposition de l\'offre: $e'))
                        );
                      }
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
  } catch (e) {
    print('Error fetching user or processing data: $e');
    // Optionally handle errors or show an error message
  }
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