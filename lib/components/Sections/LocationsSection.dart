import 'package:dynamic_multi_step_form/dynamic_multi_step_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/LocationService.dart';
import 'package:khedma/Services/OffreLocationService.dart';
import 'package:khedma/entities/OffreLocation.dart';

import '../../Services/SharedPrefService.dart';
import '../../Services/UserService.dart';
import '../../entities/Location.dart';
import '../../entities/User.dart';
import '../../theme/AppTheme.dart';
import '../Card/RentalItemCard.dart';

class OffersSection extends StatelessWidget {

  OffersSection(BuildContext context, {Key? key}) : super(key: key);


  final LocationService locationService = LocationService();
  final SharedPrefService sharedPrefService = SharedPrefService();
  final UserService userService = UserService();

  Future<List<Location>> getLocationsByNotUserId() async {
    User user= await sharedPrefService.getUser() ;
    int userId= user.id ?? 0;
    return locationService.getLocationsByNotUserId(userId);
  }

  Future<List<Location>> getMyLocationOffers() async {
    User user= await sharedPrefService.getUser() ;
    int userId= user.id ?? 0;
    return locationService.getMyLocationOffers(userId);
  }

  Future<String> getUsername() async {
    User user =await sharedPrefService.getUser();
    return user.userName;
  }
  @override
  Widget build(BuildContext context) {
    return _buildOffersSection(context);
  }

  Widget _buildOffersSection(BuildContext context) {
    return FutureBuilder<List<Location>>(
      future: getLocationsByNotUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Erreur lors de la récupération des offres: ${snapshot.error}");
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Text("Aucune offre disponible");
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Location location = snapshot.data![index];
              return FutureBuilder<User>(
                future: userService.findUserById(location.userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (userSnapshot.hasError || !userSnapshot.hasData) {
                    return ListTile(
                      title: Text(location.description),
                      subtitle: Text("Erreur de chargement du propriétaire"),
                    );
                  } else {
                    User user = userSnapshot.data!;
                    return RentalItemCardDisponible(
                      imageUrl: location.images,
                      title: location.description,
                      description: location.description,
                      price: "${location.prix}€/${location.timeUnit}",
                      location: location.category,
                      ownerName: user.userName,
                      onContactPressed: () {},
                      onRentPressed: () => _showPriceProposalBottomSheet(location.id ?? 0, context, location.timeUnit),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}

void _showPriceProposalBottomSheet(int itemId, BuildContext context, String timeUnit) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return PriceProposalBottomSheet(itemId: itemId, timeUnit: timeUnit);
    },
  );
}

class PriceProposalBottomSheet extends StatefulWidget {
  final int itemId;
  final String timeUnit;

  const PriceProposalBottomSheet({Key? key, required this.itemId, required this.timeUnit}) : super(key: key);

  @override
  _PriceProposalBottomSheetState createState() => _PriceProposalBottomSheetState();
}

class _PriceProposalBottomSheetState extends State<PriceProposalBottomSheet> {
  int period = 1;
  int price = 20;
  OffreLocationService offreService = OffreLocationService();
  late SharedPrefService sharedPrefService;
  late User user;
  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  void initializeUser() async {
    sharedPrefService = SharedPrefService();
    try {
      user = await sharedPrefService.getUser();
      setState(() {});
    } catch (e) {
      print("Failed to load user: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Proposition de prix",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              "Proposez une offre de prix afin de répondre à cette demande.",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIncrementDecrementWidget(
                  "Période(${widget.timeUnit})", period, (newPeriod) {
                setState(() {
                  period = newPeriod;
                });
              }),
              SizedBox(width: 20.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIncrementDecrementWidget(
                      "Prix", price , (newPrice) {
                    setState(() {
                      price = newPrice ;
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
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () async {
              OffreLocation newOffer = OffreLocation(
                  locationId: widget.itemId,
                  status: OfferStatus.pending,
                  price: price,
                  periode: "$period ${widget.timeUnit}",
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
            child: Text("Valider"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppTheme.primaryColor,
              fixedSize: Size(150.w, 44.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncrementDecrementWidget(String label, int value, Function(int) onChanged, {bool showCoin = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.19.sp, color: Colors.black, fontWeight: FontWeight.bold),
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
                      padding: EdgeInsets.zero, // Remove default padding to ensure proper centering
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
            SizedBox(width: 5.w), // Add space between the buttons and the value
            Container(
              width: 70.w, // Adjust width as needed
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$value",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}