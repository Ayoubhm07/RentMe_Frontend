import 'package:flutter/material.dart';
import 'package:khedma/Services/OffreLocationService.dart';
import '../../Services/LocationService.dart';
import '../../Services/SharedPrefService.dart';
import '../../entities/Location.dart';
import '../../entities/User.dart';
import '../Card/CardItemHistorique.dart';
import '../Card/CardItemHistorique2.dart';

class MyLocationsOffersSection extends StatelessWidget {
  final LocationService locationService;
  final SharedPrefService sharedPrefService;

  MyLocationsOffersSection({Key? key, required this.locationService, required this.sharedPrefService}) : super(key: key);

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
          return FutureBuilder<List<Location>>(
            future: locationService.getMyLocationOffers(userSnapshot.data!.id ?? 0),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Erreur lors de la récupération de vos offres: ${snapshot.error}");
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Text("Vous n'avez aucune offre");
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Location location = snapshot.data![index];
                    return location.status == LocationStatus.NON
                        ? RentalItemCardHistorique(
                      locationId: location.id ?? 0,
                      imageUrl: location.images,
                      title: location.description,
                      description: location.description,
                      price: "${location.prix}€/${location.timeUnit}",
                      location: location.category,
                      ownerName: userSnapshot.data!.userName,
                      onContactPressed: () {},
                      onRentPressed: () {},
                    )
                        : RentalItemCardHistorique2(
                      timeUnit: location.timeUnit,
                      locationId: location.id ?? 0,
                      category: location.category,
                      imageUrl: location.images,
                      title: location.description,
                      description: location.description,
                      price: "${location.prix}€/${location.timeUnit}",
                      location: location.category,
                      ownerName: userSnapshot.data!.userName,

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
}
