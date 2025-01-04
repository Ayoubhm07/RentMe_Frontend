import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:khedma/Services/LocationService.dart';
import 'package:khedma/Services/OffreLocationService.dart';
import 'package:khedma/Services/OffreService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/entities/OffreLocation.dart';

import '../../entities/User.dart';

class RentalItemCardHistorique2 extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String category;
  final String price;
  final String location;
  final String ownerName;
  final int locationId;
  final String timeUnit;

  const RentalItemCardHistorique2({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.description,
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
  @override
  void initState() {
    super.initState();
    _loadOffers();
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
    bool confirm = await _showConfirmationDialog('Voulez-vous accepter cette offre ?');
    if (confirm) {
      try {
        await locationService.updateLocationStatus(widget.locationId);
        await offreLocationService.acceptOffer(offerId);
        print('Offer accepted and location status updated');
        await _loadOffers();
      } catch (e) {
        print('Error accepting offer: $e');
      }
    }
  }

  Future<void> _rejectOffer(int offerId) async {
    bool confirm = await _showConfirmationDialog('Voulez-vous rejeter cette offre ?');
    if (confirm) {
      try {
        await offreLocationService.rejectOffer(offerId);
        print('Offer rejected');
        await _loadOffers();
      } catch (e) {
        print('Error rejecting offer: $e');
      }
    }
  }

  Future<bool> _showConfirmationDialog(String message) async {
    bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // L'utilisateur doit appuyer sur un bouton pour fermer le dialogue.
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation', style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Non', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(false); // retourne false
              },
            ),
            TextButton(
              child: Text('Oui', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop(true); // retourne true
              },
            ),
          ],
        );
      },
    );

    return result ?? false; // Retourne false si result est null
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.asset(
                    "assets/images/demandeLocationImage.png",
                    width: double.infinity,
                    height: 150.h,
                    fit: BoxFit.cover,
                  ),
                ),
                ExpansionTile(
                  title: Text(
                    "Offres",
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: themeData.primaryColor),
                  ),
                  initiallyExpanded: _isExpanded,
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _isExpanded = expanded;
                    });
                  },
                  iconColor: themeData.primaryColor,
                  collapsedIconColor: Colors.grey,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  childrenPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
                  children: _offers.map((offer) => ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Icon(Icons.euro_symbol, size: 18, color: themeData.primaryColor),
                            SizedBox(width: 4,),
                            Text(
                              "Prix: ",
                              style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            Expanded(
                              child: Text(
                                "${offer.price}€",
                                style: GoogleFonts.roboto(color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Icon(Icons.date_range, size: 18, color: themeData.primaryColor),
                            SizedBox(width: 4),
                            Text(
                              "Période: ",
                              style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            Expanded(
                              child: Text(
                                "${offer.periode}",
                                style: GoogleFonts.roboto(color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Icon(Icons.person_outline, size: 18, color: themeData.primaryColor),
                            SizedBox(width: 4),
                            Text(
                              "Posté par: ",
                              style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            Expanded(
                              child: Text(
                                "${_userNames[offer.userId] ?? 'Inconnu'}",
                                style: GoogleFonts.roboto(color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Icon(Icons.pending_actions, size: 18, color: themeData.primaryColor),
                            SizedBox(width: 4),
                            Text(
                              "Statut: ",
                              style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            Expanded(
                              child: Text(
                                "Offre en attente",
                                style: GoogleFonts.roboto(color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check_circle_outline, color: Colors.green[800]),
                          onPressed: () => _acceptOffer(offer.id ?? 0),
                          tooltip: 'Accepter',
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel_outlined, color: Colors.red[800]),
                          onPressed: () => _rejectOffer(offer.id ?? 0),
                          tooltip: 'Rejeter',
                        ),
                        IconButton(
                          icon: Icon(Icons.chat_bubble_outline, color: themeData.primaryColor),
                          onPressed: () {
                            // Logic to contact the offer poster
                          },
                          tooltip: 'Contactez le postulant',
                        ),
                      ],
                    ),
                  )).toList(),
                ),


                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.title, color: themeData.primaryColor),
                    SizedBox(width: 5.w),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Icon(Icons.description, color: themeData.colorScheme.secondary),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundImage: AssetImage("assets/images/user1.png"),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.ownerName,
                                    style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "Offre encore disponible",
                                    style: GoogleFonts.roboto(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.price,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: themeData.primaryColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Icon(Icons.book_online_outlined, color: Colors.blue,
                                size: 18.sp),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                widget.category,
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
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                        ElevatedButton.icon(
                        icon: Icon(Icons.edit, color: Colors.white),
                  label: Text("Modifier", style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    foregroundColor: Colors.white,
                  ),
                ),
          ElevatedButton.icon(
            icon: Icon(Icons.delete_forever, color: Colors.white),
            label: Text("Annuler", style: TextStyle(color: Colors.white)),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              foregroundColor: Colors.white,
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
