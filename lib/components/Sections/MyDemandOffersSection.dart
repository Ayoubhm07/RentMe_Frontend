import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/OffreService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/entities/Offre.dart';
import 'package:khedma/entities/User.dart';

class MyDemandOffersSection extends StatefulWidget {
  final List<Offre> offers;

  MyDemandOffersSection({Key? key, required this.offers}) : super(key: key);

  @override
  _MyDemandOffersSectionState createState() => _MyDemandOffersSectionState();
}

class _MyDemandOffersSectionState extends State<MyDemandOffersSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5), // Fond avec opacité réduite
        borderRadius: BorderRadius.circular(12), // Bords arrondis
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Ombre subtile
            blurRadius: 10,
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Liste des Offres',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.offers.length,
              itemBuilder: (context, index) {
                return FutureBuilder<User>(
                  future: UserService().findUserById(widget.offers[index].userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}',
                        style: GoogleFonts.roboto(color: Colors.red),
                      );
                    } else if (snapshot.hasData) {
                      return offerCard(widget.offers[index], snapshot.data!);
                    } else {
                      return Text("User data not available.",
                        style: GoogleFonts.roboto(color: Colors.grey),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget offerCard(Offre offre, User user) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundImage: AssetImage("assets/images/img_6.png"),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        user.userName,
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.timer, color: Colors.blue),
                    SizedBox(width: 4),
                    Text(
                      '${offre.periode} ',
                      style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.monetization_on, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      '€${offre.price}',
                      style: GoogleFonts.roboto(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Statut : Offre en attente ...",
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.check, color: Colors.white),
                      label: Text('Accepter', style: TextStyle(color: Colors.white)),
                      onPressed: () => _showAcceptDialog(context, offre),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.close, color: Colors.white),
                      label: Text('Rejeter', style: TextStyle(color: Colors.white)),
                      onPressed: () => _showRejectDialog(context, offre),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAcceptDialog(BuildContext context, Offre offre) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to accept this offer?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                try {
                  await OffreService().acceptOffer(offre.id ?? 0); // Appel à la méthode acceptOffer
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Offre acceptée avec succès!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de l\'acceptation de l\'offre: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog(BuildContext context, Offre offre) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to reject this offer?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context). pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Add logic to reject the offer
                Navigator.of(context). pop();
              },
            ),
          ],
        );
      },
    );
  }
}
