import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Metier {
  final String imagePath;
  final String name;
  final double rating;
  final String location;
  final String expertise;
  final String professionalName;
  bool verified;
  bool isDisliked;

  Metier(this.imagePath, this.name, this.rating, this.location, this.expertise,
      this.professionalName, this.verified,
      {this.isDisliked = false});
}

class BestOffers extends StatefulWidget {
  @override
  _BestOffersState createState() => _BestOffersState();
}

class _BestOffersState extends State<BestOffers> {
  final List<Metier> metierList = [
    Metier('assets/images/img_6.png', 'Design Graphique', 4.9, 'A distance',
        'Expert', 'Nourhene Bakalti', true),
    Metier('assets/images/menage.jpeg', 'Ménage', 4.9, 'Paris', 'Professionnel',
        'Mark Marker', false),
    Metier('assets/images/img_5.png', 'Plombier', 4.9, 'Paris', 'Professionnel',
        'Mark Marker', false),
    Metier('assets/images/img_11.png', 'Ménage', 4.9, 'Paris', 'Professionnel',
        'Mark Marker', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre "Membres Distingués"
        Padding(
          padding: EdgeInsets.only(left: 16.w, top: 16.h, bottom: 16.h),
          child: Text(
            'Membres Distingués',
            style: GoogleFonts.roboto(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
        // Liste horizontale des membres
        Container(
          height: 260.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: metierList.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    Metier metier = metierList[index];
    Color borderColor = metier.verified ? Colors.orange : Colors.green;
    return Container(
      width: 200.w,
      height: 250.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 3.0),
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
          child: Stack(
            children: [
              Image.asset(
                metier.imagePath,
                fit: BoxFit.cover,
                width: 200.w,
                height: 250.h,
              ),
              Container(
                width: 200.w,
                height: 250.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                left: 12.w,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      metier.verified = !metier.verified;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: metier.verified ? Colors.orange : Colors.green,
                    radius: 16.sp,
                    child: Icon(
                      metier.verified ? Icons.verified : Icons.check_circle_outline_outlined,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 12.w,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      metier.isDisliked = !metier.isDisliked;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16.sp,
                    child: Icon(
                      metier.isDisliked ? Icons.favorite_border : Icons.favorite,
                      color: Colors.red,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metier.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      metier.professionalName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: metier.expertise == 'Expert' ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(7.w),
                      ),
                      child: Text(
                        metier.expertise,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow, size: 16.sp),
                            SizedBox(width: 2.w),
                            Text(
                              metier.rating.toString(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16.sp, color: Colors.white),
                            SizedBox(width: 2.w),
                            Text(
                              metier.location,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
