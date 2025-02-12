import 'package:flutter/material.dart';
import '../../Services/LocationService.dart';
import '../../Services/ProfileService.dart';
import '../../Services/SharedPrefService.dart';
import '../../entities/Location.dart';
import '../../entities/User.dart';
import '../Card/CardItemHistorique.dart';
import '../Card/CardItemHistorique2.dart';

class MyLocationsOffersSection extends StatelessWidget {
  final LocationService locationService;
  final SharedPrefService sharedPrefService;
  final ProfileService profileService = ProfileService();

  MyLocationsOffersSection({
    Key? key,
    required this.locationService,
    required this.sharedPrefService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildMyOffersSection(context);
  }

  Widget _buildMyOffersSection(BuildContext context) {
    return FutureBuilder<User>(
      future: sharedPrefService.getUser(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (userSnapshot.hasError) {
          return Text("Erreur lors de la récupération de l'utilisateur: ${userSnapshot.error}");
        } else if (!userSnapshot.hasData) {
          return Text("Utilisateur non trouvé");
        } else {
          User user = userSnapshot.data!;
          return FutureBuilder<List<Location>>(
            future: locationService.getMyLocationOffers(user.id ?? 0),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Erreur lors de la récupération de vos offres: ${snapshot.error}");
              } else {
                return FutureBuilder(
                  future: profileService.getProfileDetails(user.id ?? 0),
                  builder: (context, profileSnapshot) {
                    if (profileSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (profileSnapshot.hasError) {
                      return Text("Erreur lors de la récupération des détails du profil: ${profileSnapshot.error}");
                    } else {
                      final profileDetails = profileSnapshot.data;
                      final userImage = profileDetails?.profilePicture ?? '';
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Location location = snapshot.data![index];
                          return location.status == LocationStatus.NON
                              ? RentalItemCardHistorique(
                            userId : location.userId,
                            locationId: location.id ?? 0,
                            images: location.images,
                            title: location.description,
                            price: "${location.prix}/${location.timeUnit}",
                            location: location.category,
                            ownerName: user.userName,
                            userImage: userImage,
                            onContactPressed: () {},
                            onRentPressed: () {},
                          )
                              : RentalItemCardHistorique2(
                            userId : location.userId,
                            timeUnit: location.timeUnit,
                            locationId: location.id ?? 0,
                            category: location.category,
                            images: location.images,
                            title: location.description,
                            price: "${location.prix}/${location.timeUnit}",
                            location: location.category,
                            ownerName: user.userName,
                            userImage: userImage,
                          );
                        },
                      );
                    }
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}
