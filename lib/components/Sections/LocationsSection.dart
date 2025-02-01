import 'package:dynamic_multi_step_form/dynamic_multi_step_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Services/LocationService.dart';
import 'package:khedma/Services/OffreLocationService.dart';
import 'package:khedma/entities/OffreLocation.dart';
import 'package:khedma/entities/ProfileDetails.dart';

import '../../Services/ProfileService.dart';
import '../../Services/SharedPrefService.dart';
import '../../Services/UserService.dart';
import '../../entities/Location.dart';
import '../../entities/User.dart';
import '../../theme/AppTheme.dart';
import '../Card/RentalItemCard.dart';
import '../Sheets/ShowBottomSheetAddLocationOffer.dart';

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
                    return FutureBuilder<ProfileDetails>(
                        future: ProfileService().getProfileDetails(user.id ?? 0),
                        builder: (context, profileDetailsSnapshot) {
                          if (profileDetailsSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (profileDetailsSnapshot.hasError || !profileDetailsSnapshot.hasData) {
                            return ListTile(
                              title: Text(location.description),
                              subtitle: Text("Erreur de chargement des détails du profil"),
                            );
                          } else {
                            ProfileDetails profileDetails = profileDetailsSnapshot.data!;
                            return RentalItemCardDisponible(
                              imageUrl: location.images,
                              title: location.description,
                              description: location.description,
                              price: "${location.prix}/${location.timeUnit}",
                              location: location.category,
                              phoneNumber: user.numTel!,
                              userEmail: user.email,
                              address: "${profileDetails.ville},${profileDetails.rue},${profileDetails.codePostal},${profileDetails.pays}",
                              ownerName: user.userName,
                              onContactPressed: () {},
                              onRentPressed: () => showAddLocationOffreBottomSheet(context,location.id ?? 0, location.timeUnit),
                            );
                          }
                        }
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